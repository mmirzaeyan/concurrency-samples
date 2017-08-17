<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="true"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="codePlus" tagdir="/WEB-INF/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lass="no-js" lang="">
<head>
<title></title>
<META http-equiv="Content-Type" content="text/html;charset=UTF-8">
	<%@ include file="/View/ScriptHeader/Head.jsp"%>
	<%@ include file="/View/ScriptHeader/baharanJqueryUi.jsp"%>
	<%@ include file="/View/ScriptHeader/FancyDialog.jsp"%>
	<%@ include file="/View/ScriptHeader/Tooltip.jsp"%>
	<script language="javascript" type="text/javascript">
		var isFirstShow = true;
		var entitiesCache = {};
		var pageSize = 5;
		var pageNo = 0;
		var order = 'e.id asc';
		var resultNum = 0;
		var restUrl = "<c:url value = '/rest/security/user' />";

		$(function() {

		});

		function init() {
			fillTable();
		}
		
		function fillTable() {
			jsonData = {
				order : order,
				pageNumber : pageNo,
				pageSize : pageSize
			};
			loadGrid('GridRowTemplate', 'entityBody', restUrl + "/list/grid",jsonData);
		}

		function deleteEntity(id) {
			if (id) {
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
						$ .ajax({
								type : "DELETE",
								url : restUrl + "/delete/" + id,
								contentType : "application/json;",
								success : function(res) {
									if (res)
										fillTable();
									else
										sweetAlert("خطا...", "حذف امکان پذیر نیست", "error");
									},
								error : function() {
									sweetAlert("خطا...", "حذف امکان پذیر نیست", "error");
									}
							});
							swal("حذف!", "عملیات با موفقیت انجام شد", "success");
							Loader(false);
						}) ;
			} else
				sweetAlert("خطا...", "حذف امکان پذیر نیست", "error");
		}
		
		function closeModal(){
			console.log("index");
			console.log($("#addModal"));
			$("#addModal").hide();
			}
	</script>
</head>
<body id="minovate" class="appWrapper rtl" onload="pageLoad()">
	<span id="confirm"></span>
	<form id="FormMain">
		<div dir="rtl">
			<%@ include file="Grid.jsp"%>
		</div>
	</form>
</body>
</html>
