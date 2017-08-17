<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="true" %>
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
.countInput{
	width:40%;
	float:right;
	padding: 5px 5px;
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
</style>
<script language="javascript" type="text/javascript">
	var restUrlOrderItem = "<c:url value = '/rest/order/orderItem' />";
	var orderId=0;
	$(function() {
		fillTableBasket();
	});

	function fillTableBasket() {
		$('#entityBody' + ' :not(script)').remove();
		$.getJSON(restUrlOrderItem + "/front/loadOrderItem",
				function(entities) {
					if (entities.length>0){
						orderId=entities[0].orderId;
					}
					if (entities.entityList)
						$('#GridRowTemplate').tmpl(entities.entityList)
								.prependTo('#entityBody');
					else {
						$('#GridRowTemplate').tmpl(entities).prependTo(
								"#entityBody");
					}
					calculatePriceSum();
				});
	}

	function dropFromBasket(id) {
		if (id) {
			var conf = confirm("?آیا از حذف رکورد اطمینان دارید")
			if (conf)
				$.ajax({
					type : "DELETE",
					url : restUrlOrderItem + "/front/delete/" + id,
					contentType : "application/json;",
					success : function(res) {
						if (res)
							fillTableBasket();
						else
							alert('حذف امکان پذیر نیست');
					},
					error : function() {
						alert('حذف امکان پذیر نیست');
					}
				});
		} else
			alert('هیچ رکوردی انتخاب نشده است');
	}
	function calculatePriceSum() {
		var sum = 0;
		$('.sumPrice').each(function(i, e) {
			sum = sum + parseFloat($(this).html());
			$("#sumItem").html(sum);
			$("#sumPayment").html(sum);
		});

	}
	function showSaveIcon(id) {
		$("#btnsave" + id).css('display', 'block');
	}

	function saveItem(orderItemId){
		$.ajax({
			type : "POST",
			url : restUrlOrderItem + "/front/updateQuantity/"+orderItemId+"/" +$("#txtQuantity"+orderItemId).val(),
			success : function(res) {
				if (res)
					fillTableBasket();
			}
		});

	}

	function continueOrder(){
		window.location = "<c:url value ='/View/frontEnd/cart/AddressAndComplete.jsp?orderId="+ orderId + "'/>";
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
										<span class="fa fa-shopping-cart fa-lg"></span> سبد خرید شما
										در بوک شاپ
									</h4>
								</div>
								<div class="col-xs-3"  onclick="continueOrder()">
									<a class="btn btn-success btn-block" > <i 
										class="fa fa-arrow-left pull-left btn-icon"></i> ثبت سفارش و ادامه خرید
									</a>
								</div>
							</div>
						</div>
					</div>

					<div class="panel-body" id="panel-body">
						<div class="row tr-header" id="order-list-heading">
							<div class="col-xs-6 td-header">
								<h4 class="product-name">
									<strong>نام محصول</strong>
								</h4>
							</div>
							<div class="col-xs-1 text-right td-header">
								<h4 class="product-name">
									<strong>تعداد </strong>
								</h4>
							</div>
							<div class="col-xs-2 td-header">
								<h4 class="product-name">
									<strong>قیمت واحد </strong>
								</h4>
							</div>
							<div class="col-xs-3 td-header">
								<h4 class="product-name">
									<strong>قیمت کل </strong>
								</h4>
							</div>
						</div>
						<div id="entityBody" class="entityBody row">
							<script id="GridRowTemplate" type="text/html">
						<div class="row tr" id="order-list-row">
							<div class="col-xs-6 pull-right td">
								<div class="td-content">
									<img class="col-xs-4 img-responsive pull-right"
										src="<c:url value='/rest/attachment/front/getFile/' />${goodsPictureCode}">
									<h4 class="product-name col-xs-8 text-right">
										${goodsName}
									</h4>
									<h4 class="col-xs-8 text-right">
										<small >
											${goodsDescription}
										</small>
									</h4>
								</div>
							</div>
							<div class="col-xs-1 td">
								<div class="td-content">
									<input type="text" class="form-control input-sm countInput" id="txtQuantity${id}"  value="${quantity}" onkeyup="showSaveIcon(${id})">
									<a class="btn " id="btnsave${id}" onclick="saveItem(${id})">	
										<i class="fa fa-refresh fa-lg"></i>
									</a> 
								</div>
							</div>
							<div class="col-xs-2 text-right td">
								<div class="td-content">
									<h6>
										<strong>${goodsPrice}<span class="text-muted">ریال</span></strong>
									</h6>
								</div>
							</div>
							<div class="col-xs-2 td">
								<div class="td-content">
									<h6>
										<strong class="sumPrice" >${ quantity*goodsPrice}</strong><span class="text-muted">ریال</span>
									</h6>
								</div>
							</div>
							<div class="td link-icon col-xs-1">
							<a class="btn btn-lg " onclick="dropFromBasket(${id})">	
								<i class="fa fa-trash-o fa-lg"></i>
							</a> 
							</div>
						</div>
						</script>
						</div>
						<div class="row">
							<div class="col-xs-7"></div>
							<div class="col-xs-5" id="price-container">
								<div class="col-xs-12 price ">
									<h5 class="text-right">
										جمع کل خرید شما : <span class="pull-left" id="sumItem">0
											<span>ریال</span>
										</span>
									</h5>
								</div>
								<div class="col-xs-12 price price-total">
									<h5 class="text-right">
										مبلغ قابل پرداخت : <span class="pull-left" id="sumPayment">0
											<span>ریال</span>
										</span>
									</h5>
								</div>
							</div>
						</div>
					</div>
					<div class="panel-footer" id="panel-footer">
						<div class="row text-center">
							<div class="col-xs-3 " onclick="continueOrder()">
								<a class="btn btn-success btn-block" > <i 
									class="fa fa-arrow-left pull-left btn-icon"></i> ثبت سفارش و ادامه خرید
								</a>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%@ include file="../homePage/Footer.jsp" %>
</body>
</html>