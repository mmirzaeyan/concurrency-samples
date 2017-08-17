<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "spring" uri = "http://www.springframework.org/tags" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head > 
    <title></title>
    <META http-equiv="Content-Type" content="text/html;charset=UTF-8">
    <%@ include file="/View/ScriptHeader/Head.jsp" %>
    <script language="javascript" type="text/javascript">
        var restUrl="<c:url value = '/rest/core/menu' />";
        var id = '<%=request.getParameter("id")%>';
		var parentId = '<%=request.getParameter("parentId")%>';
		var editMode = <%=request.getParameter("editMode")%> ;
		var level = '<%=request.getParameter("level")%>' ;
		var emptyEntity = { id: -1,title:"", parentId: parentId ,parentTopic:"" } ;
        var currentEntity = $.extend(true, {}, emptyEntity);
        
		$(function(){
			if (editMode==0){ //insert
            	$("#hiddenFieldParentId").val(parentId);
            	$("#lblParentTitle").html(level);
			}
			else 
				if (editMode==1 ){   //edit
					showCurrent(id);
			}
	    });
        function init() {
            
        }
        function showCurrent(id) {
            clearEntity();
            Loader(true);
            $.getJSON(restUrl+"/load/"+id, function (entityData) {
                setInputByEntity(entityData); Loader(false);
            });
        }
        function saveEntity() {
            if (!$("#FormEdit").validationEngine('validate'))
                return;
            setEntityFromInput(currentEntity);
            Loader(true);
            $.ajax({
				type:"POST",
				url	:restUrl+"/save",
				data:JSON.stringify(currentEntity),
				contentType:"application/json;",
				dataType:"json",
				success:function(res){
					refreshTree();
					swal("ثبت!", "عملیات با موفقیت انجام شد", "success");
				    Loader(false);
				    $("#closeModal").click();
				}
            });
        }
        
        function clearEntity() {
            setInputByEntity(emptyEntity);
            $("#FormEdit").validationEngine('hide');
        }
        
        function setInputByEntity(entity) {
            baseSetInputByEntity(entity);
            
            $("#lblParentTitle").html(entity.parentTopic);
        }
       function setEntityFromInput(entity) {
            baseSetEntityFromInput(entity);
        }
       
        function clearInputs(){
    	    $("#hiddenFieldId").val(-1);
			$("#txtTitle").val("");
       }
       function refreshForm(){
           if($("#hiddenFieldId").val()>0)
		   		showCurrent($("#hiddenFieldId").val());
       }
    </script>
  <style type="text/css">
	.form-group *{float: right;} 
</style>
</head>
<body >
<div id="myModal" class="modal-header">
		<button type="button" class="close" data-dismiss="modal"
			aria-label="Close">
			<span aria-hidden="true">&times;</span>
		</button>
		<h4 class="modal-title ">افزودن رکورد جدید </h4>
	</div>
	<div class="modal-body" >
		<div class="row ">
    	<form id="FormEdit"  class="form-horizontal" >
    		<fieldset >
    			<input type="hidden" data-bind="id" id="hiddenFieldId" value="-1" />
		    	<input type="hidden" value="-1" data-bind="parentId" id="hiddenFieldParentId" />
    			<div class="form-group" style="display:none;">
    				<label for="lblParentTitle" class="col-md-2 control-label" > عنوان منو اصلی </label>
    				<div class="col-md-3">
    					<span id="lblParentTitle" style="color:black" ></span>
    				</div>
    			</div>
    			<div class="form-group" >
    				<label for="txtTitle" style="color: red;" class="col-md-2 control-label"> عنوان </label>
    				<div class="col-md-3">
    					<input data-bind="title" id="txtTitle" type="text" class="form-control input-md validate[required]"  maxlength="200"/>
    				</div>
    				</div>
    			<div class="form-group">
    				<div class="col-md-3">
    					<input type="button" id="btnCancel" class="btn btn-default col-lg-1" data-dismiss="modal" 	style="margin:5px ; padding:5px"	 value="انصراف" >
    					<input type="button"  value='ثبت' onclick="saveEntity()" class="btn btn-primary col-lg-1" style="margin:5px ; padding:5px"  id="BtnSaveEntity" style="margin-top: 10px;"/>
    					<input type="button" data-dismiss="modal" style="display: none;" id="closeModal">
    				</div>
    			</div>
    		</fieldset>
    	</form>
    	</div>
    	</div>
</body>
</html>
