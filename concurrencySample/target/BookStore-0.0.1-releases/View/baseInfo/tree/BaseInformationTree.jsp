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
 			var im0="iconText.gif";
 			var im1="tombs_open.gif";
 			var im2="tombs.gif";
		 	var baseInformationIdInsearch; //id of selected element from autocomplete textBox  
			var BaseInformationHeaderId=-1;
			var NodeId=-1;
			var restUrl="<c:url value = '/rest/core/baseInformation' />";
			var FirstData='<?xml version="1.0" encoding="utf-8"?><tree id="0">';
			var XMLData=FirstData;
			var parentsText="";
			var modalUrl="";
			var funcList=["setUrl()","clickUrl()"];
			
		  	$(function () {
			  	$("txtSearchTopic").focus();		  		
				initTree();
				$("#cmbStatus").change(function(){
					clearAllFiltersExceptStatusCombo();
			    });
				
			});

			function executeAsynchronously(funcs, timeout) {
				  for(var i = 0; i < funcs.length; i++) {
				    setTimeout(funcs[i], timeout);
				  }
				}

			function setUrl(){
				$("#showEdit").attr("href",modalUrl);
			}

			function clickUrl(){
				$("#showEdit").click();
			}

		  	function searchBaseInformation(){
                if(baseInformationIdInsearch > 0)
					reMakeTreeAfterAutoComplete(baseInformationIdInsearch);
                else
                	clearAllFilters();
            }
            
			function reMakeTreeAfterAutoComplete(id){
				XMLData = FirstData;
				Loader(true);
				$.get(restUrl+"/reMakeTreeAfterAutoComplete/" + id  + "/" +$("#cmbStatus").val() , function(data){
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
				configTree();
				$.get(restUrl+"/listAllHeaders", function(data){	
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
				tree.attachEvent("onRightClick", function(id, e){
					NodeId=id;
					findBaseInformationHeaderId(id);
					parentsText=tree.getItemText(NodeId);
					findParents(NodeId);
					menu.showContextMenu(e.clientX,e.clientY);						
				});
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
			
				//Start Config Contex Menu
				menu = new dhtmlXMenuObject();
				menu.renderAsContextMenu();
				menu.attachEvent("onClick", onButtonClick);
				menu.loadXML("ContextMenu.xml");
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
		 			$.get(restUrl+"/getChilds/"+id+"/"+$("#cmbStatus").val(), function(data){	 
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
			
			
			
			function onButtonClick(menuitemId, type){
				if (menuitemId==='1'){ // یعنی حالت درج	 
					if (NodeId.substring(0,1)=="B"){
						sweetAlert("خطا...", "درج در این نود امکان پذیر نیست", "error");
						return;
					}
					modalUrl="<c:url value='Edit.jsp?id="+NodeId+"&parentId="+BaseInformationHeaderId+"&editMode=0"+"' />" ;
					executeAsynchronously(funcList,10);
				}
				else if (menuitemId==='2'){ // یعنی حالت ویرایش	 
						if(NodeId.substring(0,1)=="B"){
							var Treeurl="<c:url value='Edit.jsp?id="+NodeId+"&parentId="+BaseInformationHeaderId+"&editMode=1' />" ;
							console.log(Treeurl)
							$("#showEdit").attr("href",Treeurl);
							$("#showEdit").click();
						}
						else
							alert(" عملیات ویرایش برای این آیتم مجاز نمی باشد.");
				}
				else if (menuitemId==='3'){ // یعنی حالت حذف	
					if(NodeId.substring(0,1)=="B")
						deleteClicked (NodeId);
					else
						sweetAlert("خطا...", "حذف امکان پذیر نیست", "error");
			    }
			}

			
			
		    function deleteClicked(id) {
		          if (id.substring(0,1)!="H" ) {
		        	  swal({
							title: "آیا از انجام این کار مطمئن هستید ؟",
							  text: "پس از انجام عملیات حذف امکان بازیابی وجود ندارد",
							  type: "warning",
							  showCancelButton: true,
							  confirmButtonText: "بله ، حذف میکنم",
							  cancelButtonText: "خیر ، انصراف میدهم",
							  confirmButtonColor: "#DD6B55",
							  closeOnConfirm: false
							},function(){
		        		  Loader(true);
		              	  $.ajax({
		            			  url: restUrl+"/delete/"+id.substring(1),
		            			  type: 'DELETE',
		            			  dataType: 'json',
		            			  contentType: 'application/json; charset=utf-8',
		            			  success: function(res) {
			            			 if(res){
		            				 	 tree.deleteItem(id,true);
			            			 }
			            			 else
			            				 sweetAlert("خطا...", "حذف امکان پذیر نیست", "error");
		                             Loader(false);
			            	  	  },
			            	  	  error:function (){
			            	  			sweetAlert("خطا...", "حذف امکان پذیر نیست", "error");
			            	  		    Loader(false);
			            	  	  }	
		            	  });
		              	swal("حذف!", "عملیات با موفقیت انجام شد", "success");
		              	Loader(false)
		  			  });
		          }
		     }
		     
		     function refreshTree(){
	   	  		tree.destructor();
		      	$("#treeboxbox_tree").html('');
			   	NodeId=-1;
			   	BaseInformationHeaderId=-1;
			 	XMLData=FirstData;
				initTree();
		     }

		    function clearAllFilters(){
				$("#txtSearchTree").val('');
				$("#cmbStatus").val(-1);
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
			
		    function closeFancybox(){
				$.fancybox.close();
            }
</script>
</head>
<body>
<!--------------------------- edit Content ---------------------------------->
<div class="modal fade" id="addModal" >
    <div class="modal-dialog modal-lg " >
        <div class="modal-content" >

        </div>
    </div>
</div>
<!--------------------------- edit Content ---------------------------------->

 <form id="FormMain" >
 <a id="showEdit" data-toggle="modal" href="" data-target="#addModal" style="display: none;">show Edit</a>
	<span id="confirm"></span>
    <table style="width: 100%" dir="rtl">
	    <tr>
	    	<td align="right" style="padding-right: 10px">
	    		وضعیت:
		    	<select id="cmbStatus" style="width: 205px" >
		    		<option value="-1" selected="selected" >جستجو در همه رکوردها</option>
		    		<option value="0" >جستجو فقط در رکوردهای غیرفعال</option>
		    		<option value="1" >جستجو فقط در رکوردهای فعال</option>
		    	</select>
	    		عنوان:
	    		<input type="text" id="txtSearchTree" style="direction:rtl;width:35%;" maxlength="20"  autocomplete="off" role="textbox" aria-autocomplete="list" aria-haspopup="true"/>
		    	<input type="button" id="search"  style="width: 70px;" onclick="searchBaseInformation()" value='جستجو' />
		    	<input type="button" id="clear"  style="width: 70px;" onclick="clearAllFilters()" value='پاک کردن'/>
	    	</td>
	    </tr>
	    <tr>
	    	<td align="center">
	    		<div id="treeboxbox_tree" style="width:98%; height:487px;background-color:#f5f5f5;border :1px solid Silver;overflow:scroll;" ></div>
	    	</td>
	    </tr>
    </table>
    </form>
</body>
</html>
