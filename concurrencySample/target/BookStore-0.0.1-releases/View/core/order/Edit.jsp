<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="true"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">


<%@ taglib prefix="codePlus" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<html>
<head>
<%@ include file="/View/ScriptHeader/AdminFrameHead.jsp"%>
    <%@ include file="/View/ScriptHeader/FrontEndHead.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<script language="javascript" type="text/javascript">
	
	var id =<%=request.getParameter("id")%>	;
	var restUrlOrder = "<c:url value = '/rest/order/order' />";
	var restUrlOrderItem = "<c:url value = '/rest/order/orderItem' />";
	

	$(function() {
		fillTable();
		loadOrderDetail(id);
	});

	function fillTable() {
		jsonData = {
			order : order,
			pageNumber : pageNo,
			pageSize : pageSize
		};
		loadGrid('GridRowTemplateOrderItem', 'entityBodyOrderItem', restUrlOrderItem + "/getOrderItem/"+id,jsonData);
	}

	function loadOrderDetail(orderId){
		Loader(true);
		$.getJSON(restUrlOrder + "/load/" + orderId, function(entityData) {
			$("#sumPrice").html(toMoneyFormat(entityData.price));
			$("#mobilePhone").html(entityData.mobilePhone);
			$("#tel").html(entityData.tel);
			$("#address").html(entityData.address);
			$("#descirption").html(entityData.description);
			Loader(false);
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
		<h4 class="modal-title ">مشاهده جزییات سفارش </h4>
	</div>
	
		<div class="modal-body" >
				
	
<!--------------------------- Grid Header ---------------------------------->
<div class="tile">
	<!-- tile header -->
	<div class="tile-header dvd dvd-btm">
		<h1 class="custom-font">
			<strong>لیست کالاها</strong>
		</h1>
		<ul class="controls">
			<li class="dropdown">
				<ul
					class="dropdown-menu pull-right with-arrow animated littleFadeInUp">
					<li>
						<a role="button" tabindex="0" class="tile-toggle"> 
						<span class="minimize"><i class="fa fa-angle-down">	</i>&nbsp;&nbsp;&nbsp;کوچک کردن</span> 
						<span class="expand"><i class="fa fa-angle-up"></i>&nbsp;&nbsp;&nbsp;بزرگ کردن</span>
						</a>
					</li>
					<li>
						<a role="button" tabindex="0" class="tile-fullscreen">
						<i class="fa fa-expand"></i> تمام صفحه</a>
					</li>
				</ul>
			</li>
		</ul>
	</div>
	<!-- /tile header -->
<!------------------------------- Grid Header ---------------------------------->
	
<!------------------------------- Grid Body ------------------------------------>
	<div class="tile-body">
		<div id="gridSearchBox" style="display: none">
			<div class="panel panel-default panel-filled ">
				<div class="panel-heading bg-default">
					<h3 class="panel-title custom-font ">جستجو</h3>
				</div>
				<div class="panel-body bg-default" id="searchBox">
					<input id="id" data-bind="id" type="hidden" value="-1" data-default="-1"> 
					<input id="type" data-bind="type" type="hidden" value="0" data-default="0"> 
					<input id="hiddenCategoryType" data-search="categoryType" type="hidden"	value="-1" data-default="-1"> 
					<input id="hiddenLanguageId" data-search="languageId" type="hidden" value="0" data-default="-1">
					<div class="form-group">
						<label for="inputEmail3" class="col-sm-2 control-label">عنوان</label>
						<div class="col-sm-10 col-md-10">
							<input data-search="name" type="text" class="form-control" placeholder="عنوان" name="name" />
						</div>
					</div>
				</div>
				<div class="clearfix"></div>
				<div class="form-group">
					<div class="col-sm-offset-2 col-sm-10"></div>
				</div>
				<div class="form-group">
					<div class=" col-sm-12">
						<button	class="btn btn-default btn-ef btn-ef-3 btn-ef-3c actionBtn search  pull-left" type="button">
							<i class="fa fa-search"></i> جستجو
						</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="table-responsive">
		<table class="table table-custom" width="100%" align="center">
			<thead>
				<tr>
					<th class="centered">ردیف</th>
					<th class="centered">نام کالا
					</th>
					<th class="centered">تعداد  
					</th>
					<th class="centered">قیمت  
					</th>
				</tr>
			</thead>
			<tbody id="entityBodyOrderItem" class="entityBody">
				<script id="GridRowTemplateOrderItem" type="text/html">
							<tr class="odd gradeX">
							<td class="centered"> <span class="tmplRowIndex"></span> </td>
		                	<td class="centered">${goodsName}</td>
							<td class="centered">${quantity}</td>
							<td class="centered money">${goodsPrice}</td>
		            	</tr>
					</script>
			</tbody>
		</table>
		<table style="width: 100%;">
			<tr>
				<td align="left"><codePlus:DataGridPaging pageSize="10" /></td>
			</tr>
		</table>
	</div>
<!------------------------------- Grid Body ------------------------------------>
	</div>
			
			
			<div class="row">
			<form id="FormEdit" class="form-horizontal">
				<fieldset>
			
					<h4 class="modal-title" style="color:blue;">اطلاعات ارسال سفارش </h4>
					<br/>
					<div class="form-group ">
						<label for="sumPrice" class="col-md-2 control-label">جمع مبلغ خرید</label>
						<span id="sumPrice"></span>
					</div>
					<div class="form-group ">
						<label for="mobilePhone" class="col-md-2 control-label">تلفن همراه خریدار</label>
						<span id="mobilePhone"></span>
					</div>
					<div class="form-group ">
						<label for="tel" class="col-md-2 control-label">تلفن</label>
						<span id="tel"></span>
					</div>
					<div class="form-group ">
						<label for="address" class="col-md-2 control-label">آدرس خریدار:</label>
						<span id="address"></span>
					</div>
					<div class="form-group ">
						<label for="descirption" class="col-md-2 control-label">توضیحات:</label>
						<span id="descirption"></span>
					</div>
				</fieldset>
			</form>
			</div>
		</div>
	
	<div class="modal-footer">
	</div>
</body>
</html>
