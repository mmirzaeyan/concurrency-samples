<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">


<%@ taglib prefix="codePlus" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
<%@ include file="/View/ScriptHeader/AdminFrameHead.jsp"%>
<%@ include file="/View/ScriptHeader/Head.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<script language="javascript" type="text/javascript">
	var currentId = -1;
	var emptyEntity = {
		id : -1,
		publisherName : "",
		tel : "",
		address : "",
		version:0
	};
	
	var id =<%=request.getParameter("id")%>	;
	var currentEntity = $.extend(true, {}, emptyEntity);
	var restUrl = "<c:url value = '/rest/core/publisher' />";

	$(function() {
		if (id != null)
			showCurrent(id);
		if (id != null){
			$("#publisherProductViewer").attr("src","PublisherProduct.jsp?publisherId="+ id);
			$("#publisherProductViewer").css("display","block");
			}
	});

	function showCurrent(CurrentId) {
		clearEntity();
		currentId = CurrentId;
		Loader(true);
		$.getJSON(restUrl + "/load/" + currentId, function(entityData) {
			setInputByEntity(entityData);
			Loader(false);
		});
	}


	//to cleaning the entity that we pass throgh ajax and earasing forms data

	function setEntityFromInput(entity) {
		baseSetEntityFromInput(entity);
	}

	function setInputByEntity(entity) {
		baseSetInputByEntity(entity);
	}
	//to cleaning the entity that we pass throgh ajax and earasing forms data
	function clearEntity() {
		setInputByEntity(emptyEntity);
	}

	function saveEntity() {
		if (!$("#FormEdit").validationEngine('validate'))
			return;
		setEntityFromInput(currentEntity);
		Loader(true);
		$.ajax({
			type : "POST",
			url : restUrl + "/save",
			data : JSON.stringify(currentEntity),
			contentType : "application/json;",
			dataType : "json",
			success : function(res) {
				$("#publisherProductViewer").attr("src","PublisherProduct.jsp?publisherId="+ res);
				$("#publisherProductViewer").css("display","block");
				fillTable();
				swal("ثبت!", "عملیات با موفقیت انجام شد", "success");
				Loader(false);
			}
		});
	}

</script>
<style type="text/css">
	.form-group *{float: right;} 
</style>
</head>
<body >
	<input type="hidden" id="id" value="-1" />
	
	<div id="myModal" class="modal-header">
		<button type="button" class="close" data-dismiss="modal"
			aria-label="Close">
			<span aria-hidden="true">&times;</span>
		</button>
		<h4 class="modal-title ">افزودن انتشارات جدید </h4>
	</div>
	
		<div class="modal-body" >
			<div class="row ">
				<form id="FormEdit" class="form-horizontal" >
					<fieldset >
						<div class=" form-group " >
							<label for="txtName" class="col-md-2 control-label" >نام انتشارات</label> 
							<div class="col-md-3">
							<input type="hidden" id="hiddenFieldVersion" data-bind="version" value="0" />
								<input	type="text"  class="form-control input-md validate[required]" id="txtName" maxlength="50" data-bind="publisherName">
							</div>
							<label for="txtName" class=" col-md-2 control-label ">شماره تماس </label> 
							<div class="col-md-3">
								<input	type="text"  class="numberOnly form-control input-md validate[required]" id="txtName" maxlength="11" data-bind="tel"> 
							</div>
						</div>
						<div class=" form-group ">
							<label for="txtName" class="col-md-2 control-label">آدرس  </label>
							<div class="col-md-8">
								<textarea class=" form-control" rows="3" id="txtDesc" data-bind="address"></textarea>
							</div>
						</div>
						<div class=" form-group ">
							<label class="col-md-2"></label>
							<div class="col-md-3">
								<input type="button" id="btnCancel" class="btn btn-default col-lg-1" data-dismiss="modal" 	style="margin:5px ; padding:5px"	 value="انصراف" >
				                <input type="button" id="btnSave" 	class="btn btn-primary col-lg-1" onclick="saveEntity()" style="margin:5px ; padding:5px"	 value="ذخیره" >
							</div>
						</div>
					</fieldset>
				</form>
				
				
			</div>
			<div >
				<iframe class="iframe" id="publisherProductViewer" style="display: none;" src="" width="100%" frameborder="0" height="250" allowtransparency="true" >	
				</iframe>			
			</div>
		</div>
	
	<div class="modal-footer">
<!-- 		<button id="btnCancel" class="btn btn-default" data-dismiss="modal">انصراف</button> -->
	</div>
</body>
</html>
