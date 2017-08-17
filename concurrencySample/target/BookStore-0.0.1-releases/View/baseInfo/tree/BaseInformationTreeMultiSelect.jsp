<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="true"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "spring" uri = "http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <META http-equiv="Content-Type" content="text/html;charset=UTF-8">
  	<%@ include file="/View/ScriptHeader/Head.jsp" %>
  	<%@ include file="/View/ScriptHeader/FancyDialog.jsp" %>
  	<%@ include file="/View/ScriptHeader/TreeHead.jsp" %>
 	<script type="text/javascript">
 			var subSystemType = 'common' ;
 			var headerId = '<%=request.getParameter("headerId")%>' ;
 			var im0="iconText.gif";
 			var im1="tombs_open.gif";
 			var im2="tombs.gif";
			var NodeId=-1;
			var restUrl="<c:url value = '/rest/core/baseInformation' />";
			var FirstData='<?xml version="1.0" encoding="utf-8"?><tree id="0">';
			var XMLData=FirstData;
			var parentsText="";
			var baseInfoes=new Array(); 
			
			$(function () {
			  	$("txtSearchTopic").focus();		  		
				initTree();
				$("#txtSearchTree").autocomplete({ 
			           source: function(req, resp){
				                   jsonReq={ searchTopic : req.term , subSystemType : subSystemType, status : 1, resultCount:10};
							       $.getJSON(restUrl+"/autoComplete/"+headerId, jsonReq, function(data) { 
						               	resp( $.map( data, function( baseInfoViewModel ) {
													return {
															  label: baseInfoViewModel.topic,
															  value: baseInfoViewModel.id
															};
													}));
							            });  
			       	  },  
			    	  select: function(event, ui) {
			    		  	baseInformationIdInsearch=ui.item.value;
			    	    	$(event.target).val(ui.item.label);
			                return false;
			            },  
			            minLength: 1  
			    });
			});

		  	function searchBaseInformation(){
                if(baseInformationIdInsearch > 0)
					reMakeTreeAfterAutoComplete(baseInformationIdInsearch);
                else
                	clearAllFilters();
            }
		  	
		  	function reMakeTreeAfterAutoComplete(id){
				XMLData = FirstData;
				Loader(true);
				$.get(restUrl+"/reMakeTreeAfterAutoComplete/" + id + "/" + headerId + "/" + subSystemType + "/1" , function(data){	
					XMLData = XMLData + data + "</tree>";
					tree.destructor();
					configTree();
					tree.loadXMLString(XMLData);
					tree.selectItem("B"+id);
					tree.focusItem("B"+id);
					Loader(false);
				});
			}
		  	
			function initTree(){
				Loader(true);
				if(headerId == 'null' || headerId == -1 || headerId == "") {
					showMessage("بازیابی اطلاعات امکان پذیر نیست");
					return;
				}
				configTree();
				$.get(restUrl+"/getHeader/"+ subSystemType +"/"+headerId , function(data){	
					XMLData=XMLData+data	+"</tree>";
			    	tree.loadXMLString(XMLData);
					Loader(false);
				});
				setChecked();
			}
			function configTree(){
				tree = new dhtmlXTreeObject("treeboxbox_tree", "100%", "100%", 0);
		 		tree.setSkin('dhx_skyblue');
				tree.setImagePath("<c:url value = '/Scripts/MyJQuery/dhtmlxTree/imgs_rtl/' />");
				tree.enableCheckBoxes(1);
				tree.enableThreeStateCheckboxes(1);
				tree.setOnCheckHandler(toncheck); 
				tree.attachEvent("onClick", function(id, e){
					NodeId=id;	
					findBaseInformationHeaderId(id);
					parentsText=tree.getItemText(NodeId);
					findParents(NodeId);
				});
				tree.attachEvent('onOpenEnd', function(id,state) { 
	 				if(state == 1) 
	 					treeOnClick(id);
					NodeId=id;
		 			findBaseInformationHeaderId(id);
					parentsText=tree.getItemText(NodeId);
					findParents(NodeId);
	 			});
			}

			function findBaseInformationHeaderId(id){
				if(id.substring(0,1)=="B"){	
					var parentId = tree.getParentId(id);
					BaseInformationHeaderId=parentId;
					findBaseInformationHeaderId(parentId);						
				}
			}
			
			function findParents(id){
				if(id>0){	
					var parentId = tree.getParentId(id);
					parentsText =tree.getItemText(parentId)+"/"+parentsText;
					findParents(parentId);						
				}
			}
			
			function treeOnClick(id){
				var tempScrollTop = $('.containerTableStyle').scrollTop();
			 	var treeStr='';
			 	var src = '<item text="..." im0="leaf.gif" id="t'+id+'" />';
		 		if(tree.getItemText('t'+id) === '...'){
		 			Loader(true);
		 			$.get(restUrl+"/getChilds/"+id+"/1", function(data){	 
				 		XMLData=XMLData.replace(src, data);
						tree.destructor();
						configTree();
		 				tree.loadXMLString(XMLData);
						tree.openItem(id);	
						$('.containerTableStyle').scrollTop(tempScrollTop);
						setChecked();
						Loader(false);	
					});		
		 		} 	
			}
			function selectList(){
				var batchArray=tree.getAllChecked().split(',');
				var selectedArray=new Array();
				for(var i=0;i<batchArray.length;i++){
					if(batchArray[i].startsWith('B')){
						selectedArray.push({id:batchArray[i].substring(1),topic:tree.getItemText(batchArray[i])});
					}
				}
				if(selectedArray.length == 0){
					showMessage('موردی انتخاب نشده است.');
					return ;
				}else{
				   if('<%=request.getParameter("func")%>' !='null'){
						window.parent.<%=request.getParameter("func")%>(selectedArray);
				   }
				   else{
						window.parent.setBaseInformationList(selectedArray);
					}
				}
				
	    	}
			
			function clearAllFilters(){
				$("#txtSearchTree").val('');
				baseInformationIdInsearch=-1;
				tree.closeAllItems();
				$("#txtSearchTree").focus();
				tree._unselectItems();
			}
		    function clearAllFiltersExceptStatusCombo(){
				$("#txtSearchTree").val('');
				baseInformationIdInsearch=-1;
				tree.closeAllItems();
				$("#txtSearchTree").focus();
				tree._unselectItems();
			}
		    function setChecked(){
				   nodes=  tree.getAllItemsWithKids();
				   nodes=nodes+","+tree.getAllChildless();
				   var array = nodes.split(',');  
				   for(var i = 0; i < array.length; i++ ) {
				 		if(array[i].substring(0,1)!=='t')
					 		setCheckNodeIfUserHaveThis(array[i]);
				   }	
			}
		    function setCheckNodeIfUserHaveThis(id){
				  $.each(baseInfoes, function (i, entityItem) {
					  if(entityItem.id==id){
						  tree.setCheck(id,1);
					  }
				  });
			}
		    function toncheck(id, state) {
				   if(state)//checked
					   addFromBaseInfo(id);
				   else//unchecked
					   removeFromBaseInfo(id);
		    }
		    function addFromBaseInfo(id){
				  for(var i = 0; i < baseInfoes; i++ ) {
					  if(baseInfoes[i].id==id){
						  return false;
					  }
				  }
				  baseInfoes.push({'id':id});  
			}
		    function removeFromBaseInfo(id){
		    	 baseInfoes= jQuery.grep(baseInfoes, function(baseInfo) {
					  	return baseInfo.id != id;
				  });	  
			}
</script>
</head>
<body>
	<form id="FormMain" >
		<span id="confirm"></span>
		<fieldset dir="rtl" style="margin: 10px;">
		<legend style="font-size: 12px;">لطفا برای انتخاب، بروی آیتم مورد نظر دوبار کلیک کنید</legend>
	    	<table style="width:100%;height:100%;" dir="rtl">
	    		<tr>
			    	<td align="right" style="padding-right: 10px">
			    		عنوان:
			    		<input type="text" id="txtSearchTree" style="direction:rtl;width:42%;" maxlength="20" class="text ui-autocomplete-input" autocomplete="off" role="textbox" aria-autocomplete="list" aria-haspopup="true"/>
				    	<input type="button" id="search" style="width: 70px;" onclick="searchBaseInformation()" value='<spring:message code="UI.General.Search"/>'/>
				    	<input type="button" id="clear" style="width: 70px;" onclick="clearAllFilters()" value='<spring:message code="UI.General.Clear"/>'/>
			    	</td>
			    </tr>
			    <tr>
			    	<td align="center">
			    		<div id="treeboxbox_tree" style="width:98%; height:487px;background-color:#f5f5f5;border :1px solid Silver;overflow:scroll;" ></div>
			    	</td>
			    </tr>
				<tr>
					<td align="right">
						<input type="button" value='<spring:message code="UI.General.Select"  />' onclick="selectList()" class="actionBtn" />	
					</td>
				</tr>
	    	</table>
    	</fieldset>
	</form>
</body>
</html>
