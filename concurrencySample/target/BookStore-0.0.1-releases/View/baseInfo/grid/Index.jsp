<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8" isELIgnored="true"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "spring" uri = "http://www.springframework.org/tags" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head > 
    <title></title>
    <META http-equiv="Content-Type" content="text/html;charset=UTF-8">
    <%@ include file="/View/ScriptHeader/Head.jsp" %>
    <%@ include file="/View/ScriptHeader/FancyDialog.jsp"%>
    <%@ include file="/View/ScriptHeader/baharanJqueryUi.jsp"%>
     
    <script language="javascript" type="text/javascript">
        var pageSize = 10;
        var pageNo = 0;
        var order = 'e.topic asc';
        var resultNum = 0;
        var emptyEntity = { id: -1,code:0,topic:"",secondTopic:"",description:"",active:-1, parentId: -1 ,parentTopic:"", masterInformationId:-1 , masterInformationTopic : "" } ;
        var currentEntity = $.extend(true, {}, emptyEntity);
        var restUrl="<c:url value = '/rest/core/baseInformation' />";
        var currentFullPath="";
        var topOfStack=0;
        var stack = new Array();
		var subSystemType = '<%=request.getParameter("subSystemType")%>';
		$(function(){
			 $("#btnSearchParentTopic").click(function(){
				 viewFancyBox("<c:url value ='/View/baseInfo/grid/BaseInformationHeaderSearch.jsp?subSystemType="+subSystemType+"&func=setBaseInformationHeaderInSearch' />",'75%','75%');
				 $('#navigationSpan').html('');
			 });
	    });
		function closeFancybox(){
			$.fancybox.close();
        }
        function init() {
            fillTable();
        }
        function lastIndexOf(string,subStr){
            var lastIndex=-1;
            var status=1;
        	for(var i=string.length ; i>0,status==1 ; i--)
			{
				if(string.charAt(i-1)==subStr)
					{
						status=0;
						lastIndex=i-1;
						break;
					}
			}
			return lastIndex;
        }
        function fillTable() {
            if(stack.length>0){
	            jsonData = { topic : $("#txtSearchTopic").val(),
							 parentId: stack[0],
							 masterInformationId: stack.length>1 ? stack[topOfStack] : -1 ,
							 status:$('#cmbStatus').val(),
							 order: order,
							 pageNumber: pageNo,
							 pageSize: pageSize };
	        	loadGrid('GridRowTemplate', 'entityBody', restUrl+"/list/searchGrid/?random="+getBaharanRandom(), jsonData); 
            } 
        }
        function returnToGrid() {
             clearSearchFilter();
        	 $("#FormMain").validationEngine('hide');
        	 showElements(new Array('table_content'));
        	 if(stack.length==1){
        		 $("#hiddenFieldSearchParentId").val(stack[0]);
        		 fillTable();
        	 }
        	 else if(stack.length > 1){
            	  $("#hiddenFieldSearchParentId").val(-1);
            	  $("#hiddenFieldSearchMasterInformationId").val(stack[topOfStack]);
            	  fillTable();
        	 	}
        }
        function showCurrent(id,parentId,parentTopic) {
            clearEntity();
            if(id==-1){
            	if(stack.length<=0)
                {
					showMessage('<spring:message code="UI.BaseInformation.firstMessage" />');
					return;
                }
            	
            	var MasterInformationId=-1;
            	var MasterInformationTopic="";
            	if(stack.length > 1){
               	  	MasterInformationId=stack[topOfStack];
               	 	MasterInformationTopic=$("#"+MasterInformationId).html().substring(5);
           	 	}
            	else{
            		MasterInformationTopic=$("#"+stack[0]).html();
            	}
            	
            	var url="<c:url value='/View/baseInfo/tree/Edit.jsp?id=B"+MasterInformationId+"&parentId=B"+stack[0]+"&editMode=0&level="+MasterInformationTopic+"&sourceFrom=1' />" ;
            	viewFancyBox(url,"70%","70%");
            }
            else{
	            var url="<c:url value='/View/baseInfo/tree/Edit.jsp?id=B"+id+"&parentId="+parentId+"&editMode=1&level="+parentTopic+"&sourceFrom=1' />" ;
				viewFancyBox(url,"70%","70%");
	        }
        }
        function refreshForm(){
			if($("#hiddenFieldId").val()>0)
				showCurrent($("#hiddenFieldId").val(),$("#hiddenFieldSearchParentId").val(),$("#txtSearchParentTopic").val());	
        }
        function clearEntity() {
            setInputByEntity(emptyEntity);
        }
        function clearSearchFilter() {
        	$("#cmbStatus").val(-1);
        	$('#txtSearchTopic').val("");
        	if(stack.length==1)
       	  		$("#hiddenFieldSearchMasterInformationId").val(-1);
        	else if(stack.length > 1)
        			{
    					$("#hiddenFieldSearchParentId").val(-1);
    					$("#hiddenFieldSearchMasterInformationId").val(stack[topOfStack]);
        			}
        }
        function setBaseInformationHeaderInSearch(id,topic){
        	stack = new Array();
        	currentFullPath="";
			$("#hiddenFieldSearchParentId").val(id);
			$("#txtSearchParentTopic").val(topic+" ( "+ id +" ) ");
			$("#navigationSpan").append("<a index='0' id='" + id + "' style='cursor:pointer;color:blue;'  onclick='reloadGrid("+id+",-1);' >"+ topic + "</a>" );
			currentFullPath+=topic;
			topOfStack = 0;
			stack.push(id);
			fillTable();
			$.fancybox.close();
        }
        function setInputByEntity(entity) {
            baseSetInputByEntity(entity);
        }
        function setEntityFromInput(entity) {
            baseSetEntityFromInput(entity);
            entity.parentId=stack[0];
            if(stack.length==1)
            	entity.masterInformationId=-1;
            else
            	entity.masterInformationId=stack[topOfStack];
        }
        function navigateFrom(id,topic){
        	stack.push(id);
        	topOfStack+=1;
			$("#navigationSpan").append("<a index='"+ topOfStack +"' id='"+ id +"' style='cursor:pointer;color:blue;' onclick='reloadGrid("+stack[0]+","+id+")' >"+" > "+ topic +"</a>" );
			currentFullPath=currentFullPath + " > " + topic; 
			reloadGrid(stack[0],id);
			
        }
        function reloadGrid(parentId,masterInformationId){
            if(masterInformationId<0){
            	for ( var i=topOfStack; i>0 ;i--) {
                	stack.pop();
                	$("[index="+topOfStack+"]").remove();
                	currentFullPath=currentFullPath.substr(0,lastIndexOf(currentFullPath,">"));
                	topOfStack-=1;
        	 	}
             }
            else
            	for ( var i=topOfStack; i>=0 ;i--) {
                    if(stack[i]!=masterInformationId)
                        {
                        	stack.pop();
                        	$("[index="+topOfStack+"]").remove();
                        	currentFullPath=currentFullPath.substr(0,lastIndexOf(currentFullPath,'>'));
                        	topOfStack-=1;
                        }
                    else
                        break;
   			 }
                
        	 jsonData = { topic : $("#txtSearchTopic").val(),
						 parentId : parentId,
						 masterInformationId : masterInformationId,
						 status:$('#cmbStatus').val(),
						 order: order,
						 pageNumber: pageNo,
						 pageSize: pageSize };
    		 loadGrid('GridRowTemplate', 'entityBody', restUrl+"/list/searchGrid/?random="+getBaharanRandom(), jsonData); 
        }
       function deleteBaseInfo(id){
    	   if (baharanConfirm('حذف اطلاعات پایه','آیا از حذف این آیتم اطمینان دازید؟',function() {
    		   Loader(true);
               $.ajax({
	   				type:"DELETE",
	   				url	:restUrl+"/delete/"+id,
	   				contentType:"application/json;",
	   				success:function(res){
		   				fillTable();
		   				Loader(false);
	   				},
	   				error :function(){
		   				showMessage('<spring:message code="ui.General.DeleteImposible" />');
		   				Loader(false);
	   				}
               });
	        }
       	 ));
      }
       function getNavigationSpanLabel(){
	   		return currentFullPath;
       }
    </script>
</head>
<body onload="pageLoad()">
	<span id="confirm"></span>
    <form id="FormMain" >
	    <div dir="rtl">
				<%@ include file="Grid.jsp" %>	
		</div>
	</form>
</body>
</html>
