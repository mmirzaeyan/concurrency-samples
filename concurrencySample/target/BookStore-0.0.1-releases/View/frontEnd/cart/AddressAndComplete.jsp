<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="codePlus" tagdir="/WEB-INF/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
<%@ include file="/View/ScriptHeader/FrontEndHead.jsp"%>
<%@ include file="/View/ScriptHeader/ValidationHead.jsp" %>
<%@ include file="/View/ScriptHeader/SweetAlertHead.jsp" %>
<script type="text/javascript" src="<c:url value='/Scripts/AppJs/core/keyUtility.js' />"></script>


<style>
#horizental-menu {
	display: none !important;
}
.panel-body>.row div {
	float: right;
}

#shoppingList {
	margin-top: 20px;
	border: none;
}

#panel-info {
	border: none;
}

#panel-heading {
	background: #fbf6b3;
	color: #d91f2b;
	border: none;
}

#panel-body {
	border: none;
	margin: 0;
	padding: 0;
	left: 0;
	right: 0;
}
/* #order-list-heading > div{ */
/* 	border : 1px solid #eee; */
/* } */
/* #order-list-row > div{ */
/* 	border-left : 1px solid #eee; */
/* 	border-right :1px solid #eee; */
/* 	height: 100%; */
/*  } */
.row {
	margin: 0;
}

.tr-header {
	width: 100%;
	height: auto;
}

.tr {
	width: 100%;
	height: 280px;
}

.td-header {
	height: auto;
	border: 1px solid #f1f0f0;
	text-align: center;
	background: #fcfad5;
}

.td {
	text-align: center;
	padding: 10px;
	height: 280px;
	line-height: 280px;
	border: 1px solid #f1f0f0;
	display: flex;
	justify-content: center;
	flex-direction: column;
}

.link-icon {
	background: #ffada7;
	color: white;
}

.link-icon span {
	color: white;
}

#price-container {
	padding: 0;
	margin: 10px 0;
}

.price {
	border: 1px solid #f1f0f0;
	padding: 10px;
}

.price-total {
	background: #fbf6b3;
}

.btn-icon {
	line-height: 20px;
}
#FormEdit {
	margin:20px 0;
}
#FormEdit .form-group  *{
	float:right;
} 
</style>
<script language="javascript" type="text/javascript">
	var restUrlOrder = "<c:url value = '/rest/order/order' />";
	var orderId =<%=request.getParameter("orderId")%>;
	var entityCompleteOrder = {
			orderId : -1,
			mobilePhone : "",
			address:"",
			tel : "",
			description : ""
		};
	$(function() {
		initKeyUtility();
	});

	function completeOrder(){
		if (!$("#FormEdit").validationEngine('validate'))
			return;
		entityCompleteOrder.orderId=orderId;
		entityCompleteOrder.mobilePhone=$("#txtMobilePhone").val();
		entityCompleteOrder.tel=$("#txtPhone").val();
		entityCompleteOrder.address=$("#txtAddress").val();
		entityCompleteOrder.escription=$("#txtDesc").val();
		$.ajax({
			type : "POST",
			url : restUrlOrder + "/front/updateAndComplete",
			data : JSON.stringify(entityCompleteOrder),
			contentType : "application/json;",
			dataType : "json"
		}).always(function(res) {
			swal("", "سفارش شما با موفقیت ثبت شد و "+res.responseText+" شماره پیگیری خرید شماست", "success");
		  }); 
	}
</script>
</head>
<body>
	<%@ include file="../homePage/Header.jsp"%>
	<%@ include file="../homePage/TopMenu.jsp"%>
	<div class="container" id="shoppingList">
		<div class="row">
			<div class="col-sm-12 col-md-12 ">
				<div class="panel panel-info" id="panel-info">
					<div class="panel-heading" id="panel-heading">
						<div class="panel-title">
							<div class="row">
								<div class="col-xs-9 pull-right">
									<h4>
										<span class="fa fa-shopping-cart fa-lg"></span> 
										ثبت آدرس و تکمیل اطلاعات
									</h4>
								</div>
								<div class="col-xs-3"  onclick="completeOrder()">
									<a class="btn btn-success btn-block" > 
									<i class="fa fa-arrow-left pull-left btn-icon"></i> تکمیل اطلاعات و ادامه خرید
									</a>
								</div>
							</div>
						</div>
					</div>
					<div class="panel-body" id="panel-body">
						<form id="FormEdit" class="form-horizontal">
							<div class="row">
							<div class="col-md-10 col-md-offset-1">
								<div class="form-group ">
										<label for="txtMobilePhone" class="col-md-2 control-label">
										شماره تماس ضروری (‌همراه):
										</label>
										<div class="col-md-4">
											<input 	type="text" id="txtMobilePhone" maxlength="11"
												class="numberOnly validate[required,min[11]] form-control"  />
										</div>
										<label for="txtPhone" class="col-md-2 control-label">
										شماره تماس ثابت :
										</label>
										<div class="col-md-4">
											<input type="text" id="txtPhone" class="validate[min[10]] numberOnly form-control input-md " maxlength="10" />
										</div>
								</div>
								<div class="form-group">
									<label for="txtAddress" class=" col-md-2 control-label">آدرس :	</label>
									<div class="col-md-4">
										<textarea class="form-control validate[required,min[10]]" rows="3" id="txtAddress" ></textarea>
									</div>
									<label for="txtDesc" class="col-md-2 control-label">
										توضیحات:	
									</label>
									<div class="col-md-4">
										<textarea class=" form-control" rows="3" id="txtDesc" ></textarea>
									</div>
								</div>
							</div>
							</div>			
						</form>
					</div>
					<div class="panel-footer" id="panel-footer">
						<div class="row text-center">
							<div class="col-xs-3 " onclick="completeOrder()">
								<a class="btn btn-success btn-block" > <i 
									class="fa fa-arrow-left pull-left btn-icon"></i> تکمیل اطلاعات و ادامه خرید
								</a>
							</div>
						</div>
					</div>
				</div>
				
			</div>
			
		</div>
		
	</div>


</body>
</html>