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
        var restUrl="<c:url value = '/rest/core/menuSetting' />";
    	var restUrlPublisher = "<c:url value = '/rest/core/publisher' />";
        var restUrlPublisherProduct = "<c:url value = '/rest/core/publisherProduct' />";
        var id = '<%=request.getParameter("id")%>';
		var level = '<%=request.getParameter("level")%>' ;
		var emptyEntity = { id: -1,
							menuId:id,
							bookTypeId:"",
							bookTypeTopic: "",
							gradeId:"" ,
							gradeTopic:"",
							fieldId:"",
							fieldTopic:"",
							lessonId:"",
							lessonTopic:"",
							publisherId:"",
							publisherName:"",
							publisherProductId:"",
							publisherProductProductName:""} ;
        var currentEntity = $.extend(true, {}, emptyEntity);
        
		$(function(){

			fillCombo("cmb‌‌BookType","<c:url value = '/rest/core/baseInformation/list/4' />", {},"id", "topic", "...");
			fillCombo("cmbGrade","<c:url value = '/rest/core/baseInformation/list/5' />", {},"id", "topic", "...");
			fillCombo("cmbField","<c:url value = '/rest/core/baseInformation/list/6' />", {},"id", "topic", "...");
			fillCombo("cmb‌‌Lesson","<c:url value = '/rest/core/baseInformation/list/7' />", {},"id", "topic", "...");
			fillCombo("cmbPublisher", restUrlPublisher + "/getAll", {}, "id","publisherName", "...");

			showCurrent(id);
			
	    });
        function init() {
            
        }
        
        function showCurrent(id) {
            clearEntity();
            Loader(true);
            $.getJSON(restUrl+"/load/"+id, function (entityData) {
                setInputByEntity(entityData); 
				if (entityData.id="")
					id=<%=request.getParameter("id")%>;
					$("#hiddenFieldId").val(id);
                Loader(false);
            });
        }
        
        function saveEntity() {
            if (!$("#FormEdit").validationEngine('validate'))
                return;
            setEntityFromInput(currentEntity);
            if (currentEntity.bookTypeId=="" && currentEntity.gradeId=="" &&  currentEntity.fieldId=="" && 
            		currentEntity.lessonId=="" && currentEntity.publisherId=="" && currentEntity.publisherProductId=="" )  {
    			sweetAlert("خطا...!", " حداقل باید یکی از اطلاعات را وارد کنید ", "error");
				return;
            }
    		
            Loader(true);
            $.ajax({
				type:"POST",
				url	:restUrl+"/save",
				data:JSON.stringify(currentEntity),
				contentType:"application/json;",
				dataType:"json",
				success:function(res){
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
    
       function refreshForm(){
           if($("#hiddenFieldId").val()>0)
		   		showCurrent($("#hiddenFieldId").val());
       }
	   	function fillCmbPublihserProduct() {
			var publisherId = $("#cmbPublisher").val()
			if (publisherId == -1) {
				$('#cmbPublisherProduct').find('option:not(:first)').remove();
			} else {
				fillCombo("cmbPublisherProduct", restUrlPublisherProduct+ "/getAll/" + publisherId, {}, "id", "productName", "...");
			}
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
		<h4 class="modal-title ">ثبت تنظیمات منو </h4>
	</div>
	<div class="modal-body" >
		<div class="row ">
    	<form id="FormEdit"  class="form-horizontal" >
    		<fieldset >
    			<input type="hidden" data-bind="id" id="hiddenFieldId" value="-1" />
    			<div class="form-group" style="display:none;">
    				<label for="lblParentTitle" class="col-md-2 control-label" > عنوان منو اصلی </label>
    				<div class="col-md-3">
    					<span id="lblParentTitle" style="color:black" ></span>
    				</div>
    			</div>
    			<div class="form-group" >
    				<label for="cmb‌‌BookType" class="col-md-2 control-label">نوع کتاب</label>
					<div class="col-md-2"> 
						<select class="form-control input-md" id="cmb‌‌BookType" data-bind="bookTypeId">
							<option value="-1">...</option>
						</select>
					</div>
					<label for="cmbField" class="col-md-2 control-label">رشته</label>
					<div class="col-md-2"> 
						<select class="form-control input-md" id="cmbField" data-bind="fieldId">
							<option value="-1">...</option>
						</select>
					</div>
					<label for="cmbGrade" class="col-md-2 control-label">مقطع</label>
					<div class="col-md-2"> 
						<select class="form-control input-md" id="cmbGrade" data-bind="gradeId">
							<option value="-1">...</option>
						</select>
					</div>
					<label for="cmb‌‌Lesson" class="col-md-2 control-label">درس</label>
					<div class="col-md-2"> 
						<select class="form-control input-md" id="cmb‌‌Lesson" data-bind="lessonId">
							<option value="-1">...</option>
						</select>
					</div>
    				<label for="cmbPublisher" class="col-md-2 control-label" >انتشارات</label>
					<div class="col-md-2">
						<select class="form-control input-md " id="cmbPublisher" data-bind="publisherId" onchange="fillCmbPublihserProduct()">
							<option value="-1">...</option>
						</select>
					</div>
					<label for="cmbPublisherProduct" class="col-md-2 control-label">محصول</label>
					<div class="col-md-2">
						<select class="form-control input-md" id="cmbPublisherProduct" data-bind="publisherProductId">
							<option value="-1">...</option>
						</select>
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
