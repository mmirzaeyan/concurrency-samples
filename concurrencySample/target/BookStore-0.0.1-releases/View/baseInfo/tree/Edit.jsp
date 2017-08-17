<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
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
        var restUrl="<c:url value = '/rest/core/baseInformation' />";
		var id = '<%=request.getParameter("id")%>';
		var parentId = '<%=request.getParameter("parentId")%>';
		var editMode = <%=request.getParameter("editMode")%> ;
		var level = '<%=request.getParameter("level")%>' ;
		var emptyEntity = { id: -1,code:0,topic:"",description:"",active:true, parentId: parentId.substring(1) ,parentTopic:"", masterInformationId:-1 , masterInformationTopic : "" } ;
        var currentEntity = $.extend(true, {}, emptyEntity);
        
		$(function(){
			if (editMode==0){ //insert
				if(id.substring(0,1)=="H"){
	            	$("#hiddenFieldParentId").val(id.substring(1));
	            	$("#hiddenFieldMasterInformationId").val(-1);
	            	$("#lblParentTitle").html(level);
				}
	            else if(id.substring(0,1)=="B"){
	            	$("#hiddenFieldParentId").val(parentId.substring(1));
	            	$("#hiddenFieldMasterInformationId").val(id.substring(1));
	            	$("#lblParentTitle").html(level);
	            }
			}
			else 
				if (editMode==1 && id.substring(0,1)!="H"){   //edit
					showCurrent(id.substring(1));
			}
	    });
        function init() {
            
        }
        function showCurrent(id) {
            clearEntity();
            Loader(true);
            $.getJSON(restUrl+"/loadBaseInfoViewModel/"+id, function (entityData) {
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
				url	:restUrl+"/saveWithViewModel",
				data:JSON.stringify(currentEntity),
				contentType:"application/json;",
				dataType:"json",
				success:function(res){
					reMakeTreeAfterAutoComplete(res);
					swal("ثبت!", "عملیات با موفقیت انجام شد", "success");
				    Loader(false);
				}
            });
        }
        function clearEntity() {
            setInputByEntity(emptyEntity);
            $("#FormEdit").validationEngine('hide');
        }
        function setInputByEntity(entity) {
            baseSetInputByEntity(entity);
            if(entity.masterInformationId>0)
            	$("#lblParentTitle").html(entity.masterInformationTopic);
            else 
            	$("#lblParentTitle").html(entity.parentTopic);
            if(entity.active) 
                $("#activeCheckBox").attr("checked","checked"); 
            else  
                $("#activeCheckBox").removeAttr("checked");
        }
        function setEntityFromInput(entity) {
            baseSetEntityFromInput(entity);
            if(!entity.masterInformationId > 0)
            	entity.masterInformationId=-1;
            entity.active=$('#activeCheckBox').is(':checked');
        }
        function clearInputs(){
    	    $("#hiddenFieldId").val(-1);
    	    $("#txtCode").val("");
			$("#txtTopic").val("");
			$("#txtSecondTopic").val("");
			$("#txtDescription").val("");
			$("#activeCheckBox").attr("ckecked","ckecked");
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
		    	<input type="hidden" value="-1" data-bind="masterInformationId" id="hiddenFieldMasterInformationId" />
    			<div class="form-group" >
    				<label for="lblParentTitle" class="col-md-2 control-label" > موضوع </label>
    				<div class="col-md-3">
    					<span id="lblParentTitle" style="color:black" ></span>
    				</div>
    			</div>
    			<div class="form-group" >
    				<label for="txtCode" style="color: red;" class="col-md-2 control-label">کد </label>
    				<div class="col-md-3">
		   				<input type="text" data-bind="code" id="txtCode" maxlength="9" style="width: 100px"  class="form-control input-md validate[required] numberOnly" />
		   			</div>
    				<label for="txtTopic" style="color: red;" class="col-md-2 control-label"> عنوان </label>
    				<div class="col-md-3">
    					<input data-bind="topic" id="txtTopic" type="text" class="form-control input-md validate[required]"  maxlength="200"/>
    				</div>
    				</div>
    				<div class="form-group" >
    			
    				<label for="txtDescription" class="col-md-2 control-label"> توضیحات &nbsp;:</label>
    				<div class="col-md-8">
    					<textarea class="form-control"	data-bind="description"	id="txtDescription"  maxlength="250"></textarea>
    				</div>
    			</div>
    			<div class="form-group">
    				<label for="activeCheckBox">فعال&nbsp;:</label>
    				<div class="col-md-1">
    					<input type="checkbox" id="activeCheckBox" data-bind="active" checked="checked" />
    				</div>
    			</div>
    			<div class="form-group">
    				<div class="col-md-3">
    					<input type="button" id="btnCancel" class="btn btn-default col-lg-1" data-dismiss="modal" 	style="margin:5px ; padding:5px"	 value="انصراف" >
    					<input type="button"  value='ثبت' onclick="saveEntity()" class="btn btn-primary col-lg-1" style="margin:5px ; padding:5px"  id="BtnSaveEntity" style="margin-top: 10px;"/>
    				</div>
    			</div>
    		</fieldset>
    	</form>
    	</div>
    	</div>
</body>
</html>
