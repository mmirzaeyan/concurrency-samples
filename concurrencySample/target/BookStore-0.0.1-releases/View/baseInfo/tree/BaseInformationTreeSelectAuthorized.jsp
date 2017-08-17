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
	<%@ include file="/View/ScriptHeader/baharanJqueryUi.jsp"%>
 	<script type="text/javascript">
 			var subSystemType = '<%=request.getParameter("subSystemType")%>' ;
 			var headerId = '<%=request.getParameter("headerId")%>' ;
 			var im0="iconText.gif";
 			var im1="tombs_open.gif";
 			var im2="tombs.gif";
			var NodeId=-1;
			var restUrl="<c:url value = '/rest/core/baseInformation'/>";
			var FirstData='<?xml version="1.0" encoding="utf-8"?><tree id="0">';
			var XMLData=FirstData;
			var parentsText="";
			
		  	$(function () {
		  		$("#treeboxbox_tree").css("height",$(window).height()-70);
		  		$(window).resize(function(){
					$("#treeboxbox_tree").css("height",$(window).height()-70);
				});
		  		initTree();
			});
			
			function initTree(){
				Loader(true);
				configTree();
				$.get(restUrl+"/getChildsAuthorize/"+"H"+headerId+"/1", function(data){	 
					XMLData=XMLData+data+"</tree>";
			    	tree.loadXMLString(XMLData);
			    	Loader(false);	
				});
			}
			
			function configTree(){
				tree = new dhtmlXTreeObject("treeboxbox_tree", "100%", "100%", 0);
		 		tree.setSkin('dhx_skyblue');
				tree.setImagePath("<c:url value = '/Scripts/MyJQuery/dhtmlxTree/imgs_rtl/' />");
				tree.enableHighlighting(true);
				tree.setOnDblClickHandler(treeOnDoubleClick); 
				tree.attachEvent("onClick", function(id, e){
					NodeId=id;	
					findBaseInformationHeaderId(id);
					parentsText=tree.getItemText(NodeId);
					findParents(NodeId);
				});
				tree.attachEvent('onOpenEnd', function(id,state){
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
			 	var src = '<item text="..." im0="leaf.gif" id="t'+id+'"/>';
		 		if(tree.getItemText('t'+id) === '...'){
		 			Loader(true);
		 			$.get(restUrl+"/getChildsAuthorize/"+id+"/1", function(data){	 
				 		XMLData=XMLData.replace(src, data);
						tree.destructor();
						configTree();
		 				tree.loadXMLString(XMLData);
						tree.openItem(id);	
						$('.containerTableStyle').scrollTop(tempScrollTop);
						Loader(false);	
					});		
		 		} 	
			}
			function treeOnDoubleClick(itemId,state){
				if(itemId.substring(0,1) == "H"){
					showMessage(" این آیتم امکان انتخاب ندارد ");
					return;
				}
				$.getJSON(restUrl+"/load/"+itemId.substring(1,itemId.length), function (BaseInformationEntity) {
					if('<%=request.getParameter("func")%>' != 'null')
		              	window.parent.<%=request.getParameter("func")%>(BaseInformationEntity);
					else
		           		window.parent.setBaseInfo(BaseInformationEntity);
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
			    	<td align="center">
			    		<div id="treeboxbox_tree" style="width:98%; height:487px;background-color:#f5f5f5;border :1px solid Silver;overflow:scroll;" ></div>
			    	</td>
			    </tr>
	    	</table>
    	</fieldset>
	</form>
</body>
</html>
