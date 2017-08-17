<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<%@ taglib prefix="codePlus" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
<%@ include file="/View/ScriptHeader/AdminFrameHead.jsp"%>
<%@ include file="/View/ScriptHeader/Head.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<script language="javascript" type="text/javascript">
	var currentId = -1;
	var emptyEntity = {
		id : -1,
		firstName : "",
		lastName : "",
		userName : "",
		passWord : "",
		email : "",
		enabled : false,
		admin:false

	};
	var id =<%=request.getParameter("id")%>;
	var currentEntity = $.extend(true, {}, emptyEntity);
	var restUrl = "<c:url value = '/rest/security/user' />";

	$(function() {
		if (id != null)
			showCurrent(id)
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
				swal({
					title : "عملیات  با موفقیت انجام شد",
					timer : 1500,
					showConfirmButton : false,
					type : "success"
				});
				fillTable();
				$("#closeModal").click(); 
				Loader(false);
			}
		});
	}

	function setEntityFromInput(entity) {
		baseSetEntityFromInput(entity);
		if ($("#checkEnabled").is(":checked"))
			entity.enabled=true
		else
			entity.enabled=false
		if ($("#checkAdmin").is(":checked"))
			entity.admin=true
		else
			entity.admin=false
	}

	function setInputByEntity(entity) {
		baseSetInputByEntity(entity);
		if (entity.enabled==true)
			$('#checkEnabled').prop('checked', true);
		else
			$('#checkEnabled').prop('checked', false);

		if (entity.admin==true)
			$('#checkAdmin').prop('checked', true);
		else
			$('#checkAdmin').prop('checked', false);

	}
</script>
</head>
<body>
	<input type="hidden" id="id" value="-1" />
	<div id="myModal" class="modal-header">
		<button type="button" class="close" data-dismiss="modal"
			aria-label="Close">
			<span aria-hidden="true">&times;</span>
		</button>
		<h4 class="modal-title ">افزودن کاربر جدید</h4>
	</div>
	<form id="FormEdit">
		<div class="modal-body">
			<div class="row">
				<input type="hidden" id="hiddenFieldId" data-bind="id" value="-1" />
				<label for="txtFirstName" style="color: red;">نام </label> 
				<input data-bind="firstName" maxlength="20" id="txtFirstName" type="text" class="form-control validate[required]" size="40" /> 
				<label for="txtLastName" style="color: red;">نام خاتوادگی</label> 
				<input data-bind="lastName" maxlength="20" id="txtLastName" type="text" class="form-control validate[required]" size="40" /> 
					<label for="txtEmail" style="color: red;">پست الکترونیک</label> 
					<input data-bind="email" id="txtEmail" type="text" class="form-control input-email validate[required]" style="direction: ltr" size="40" /> 
					<label for="txtUserName"style="color: red;">نام کاربری</label> 
					<input name="userName" maxlength="20" id="txtUserName" type="text" class="form-control validate[required]" style="direction: ltr"size="40" /> 
					<label for="txtPassWord" style="color: red;">رمز
					عبور</label> <input data-bind="passWord" id="txtPassWord" type="password"
					class="form-control validate[required]" style="direction: ltr"
					size="40" /> 
					<label for="chkEnabled" >فعال/ غیرفعال</label>
					<input type="checkbox"  id="checkEnabled" /> 
					<label for="checkAdmin"style="margin-right: 40px;" >مدیر سامانه</label>
					<input type="checkbox"  id="checkAdmin" / > 
			</div>
			<div class="row">
					<input type="button" id="BtnWriteEntity" value=' ثبت' onclick="saveEntity()" class="btn btn-primary" />
					<input type="button" data-dismiss="modal" style="display: none;" id="closeModal">
			</div>
		</div>
	</form>
</body>
</html>
