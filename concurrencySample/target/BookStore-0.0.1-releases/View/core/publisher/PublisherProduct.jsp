<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8" isELIgnored="true"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib prefix="sec"	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="codePlus" tagdir="/WEB-INF/tags"%>
<html>
<head>
<META http-equiv="Content-Type" content="text/html;charset=UTF-8">
    <%@ include file="/View/ScriptHeader/Head.jsp" %>
    <%@ include file="/View/ScriptHeader/FancyDialog.jsp"%>
    <%@ include file="/View/ScriptHeader/baharanJqueryUi.jsp"%>
    <%@ include file="/View/ScriptHeader/Tooltip.jsp"%>
    <script language="javascript" type="text/javascript"> 

		var publisherId =<%=request.getParameter("publisherId")%>	;
	    var isFirstShow = true;
		var entitiesCache = {};
	    var pageSize = 5;
	    var pageNo = 0;
	    var order = 'e.id asc';
	    var resultNum = 0;
    	

    	var currentId = -1;
    	var emptyEntity = {
    		id : -1,
    		publisherId : publisherId,
    		productName : ""
    	};
    	
    	
    	var currentEntity = $.extend(true, {}, emptyEntity);
    	var restUrl = "<c:url value = '/rest/core/publisherProduct' />";
// 		var restPublisherUrl = "<c:url value = '/rest/core/publisher' />"

    	
    	$(function() {
    		fillTable();
//     		if (publisherId = null)
//     			showCurrent(publisherId);
    	});

    	function fillTable() {
			jsonData = {
				order : order,
				pageNumber : pageNo,
				pageSize : pageSize
			};
			loadGrid('GridRowTemplate', 'entityBody', restUrl + "/list/grid/"+publisherId,jsonData);
		}

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

    	function clearEntity() {
		setInputByEntity(emptyEntity);
	}

	function setEntityFromInput(entity) {
		baseSetEntityFromInput(entity);
	}

	function setInputByEntity(entity) {
		baseSetInputByEntity(entity);
	}
	//it works same as ready in jquery
	function init() {

	}
	//to cleaning the entity that we pass throgh ajax and earasing forms data
	function clearEntity() {
		setInputByEntity(emptyEntity);
	}

	function saveFunc() {
		if (!$("#edit").validationEngine('validate'))
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
// 				window.parent.closeModal();
				fillTable();
				clearBox();
// 				$("#closeModal").click();
				Loader(false);
			}
		});
	}

	function setEntityFromInput(entity) {
		baseSetEntityFromInput(entity);
	}

	function setInputByEntity(entity) {
		baseSetInputByEntity(entity);
	}

	function deleteEntity(id) {
		console.log(id);
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
								if (res){
									fillTable();
									swal("حذف!", "عملیات با موفقیت انجام شد", "success");
							}
								else
									swal("حذف!", "عملیات با موفقیت انجام شد", "success");
								},
							error : function() {
								swal("حذف!", "خطا..!", "error");
								}
						});
						Loader(false);
					}) ;
		} else
			swal("حذف!", "خطا..!", "error");
	}

	function clearBox() {
		$("#txtPublisherProduct").val("");
	}
    	
    </script>
    
<style type="text/css">
	body{
	background: #fff;
	width:100%; 
	padding-right: 20px;
	}
	h4{
	height: 50px;
	line-height: 3em;
	}
	.form-group *{float: right;} 
	</style>

</head>

<body >
	<input type="hidden" id="id" value="-1" />
	
	
	
	
	<div class="row"  >
		<h4 >افزودن محصولات انتشارات </h4>
			<form id="edit" style="border-top:1px solid #eee; " class="form-horizontal">
			<br><br>
				<fieldset >
					<div class="form-group">
						<label for="txtPublisherProduct" class="col-md-2 control-label">نام محصول</label> 
						<div class="col-md-3" style="margin-right: 20px;">
							<input type="text" class="form-control input-md validate[required]" id="txtPublisherProduct" data-bind="productName">
						</div>
					</div>
					<div class="form-group">
							<label class="col-md-2 control-label"></label>
						<div class="col-md-3" style="padding-right: 95px;">
							<input type="button" id="Cancel" class="btn btn-default col-md-2" onclick="clearBox()" style="margin:5px ; padding:5px"	 value="پاک کردن" >
		                	<input type="button" id="Save" 	class="btn btn-primary col-md-2" onclick="saveFunc()" style="margin:5px ; padding:5px"	 value="ذخیره" >
						</div> 
					</div>
				</fieldset>
			</form>
	</div>
	
	
	
<!--------------------------- Grid Header ---------------------------------->
<div class="tile">
	<!-- tile header -->
	<div class="tile-header dvd dvd-btm">
		<h1 class="custom-font">
			<strong>لیست  محصولات انتشارات</strong>
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
<!-- 			<li class="dropdown"> -->
<!-- 				<a role="button" onclick="showGrid()"> -->
<!-- 					<i class="fa fa-refresh" role="button"></i> -->
<!-- 				</a> -->
<!-- 			</li> -->
<!-- 			<li class="dropdown"> -->
<!-- 				<a role="button" id="btn-edit-modal" tabindex="0" class="dropdown-toggle btn btn-greensea color-gray-light" data-toggle="modal" href="Edit.jsp" data-target="#addModal"> -->
<!-- 				 ثبت رکورد جدید  -->
<!-- 				 </a> -->
<!-- 			</li> -->
<!-- 			<li class="dropdown " style="margin-left: 24px;"> -->
<!-- 				data-toggle="modal" data-target="#modal-search"  -->
<!-- 				<a role="button" id="btn-search-modal" tabindex="1"	class="dropdown-toggle btn-ef btn-ef-3 btn-default"> جستجو </a> -->
<!-- 			</li> -->
		</ul>
	</div>
	<!-- /tile header -->
<!------------------------------- Grid Header ---------------------------------->
	
<!------------------------------- Grid Body ------------------------------------>
	<span id="confirm"></span>
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
		<table class="table table-custom" id="grid" data-component="grid"
			data-options="url:'<c:url value = '/rest/category/getAllGrid' />', notFoundDataAlert: false, createSearchOptions: true,order:'e.id desc'"
			width="100%" align="center">
			<thead>
				<tr>
					<th class="centered">ردیف</th>
					<th class="centered">نام انتشارات 
						<a class="orderLink" order="e.name" type="asc"> 	<i class="fa fa-caret-down"></i></a> 
						<a class="orderLink" order="e.name" type="desc"> <i	class="fa fa-caret-up"></i></a>
					</th>
					<th class="centered">نام محصول  
						<a class="orderLink" order="e.categoryType" type="asc"><i class="fa fa-caret-down"></i></a>
						<a class="orderLink" order="e.categoryType" type="desc"><i class="fa fa-caret-up"></i></a>
					</th>
					<th style="width: 160px;" class="centered">عملیات</th>
				</tr>
			</thead>
			<tbody id="entityBody" class="entityBody">
				<script id="GridRowTemplate" type="text/html">
							<tr class="odd gradeX">
							<td class="centered"> <span class="tmplRowIndex"></span> </td>
		                	<td class="centered">${productName}</td>
							<td class="centered">
								<div class="btn-group btn-group-xs">
										<button type="button" class="btn btn-greensea" role="button" tabindex="0"  onclick="showCurrent(${id})">ویرایش</button>
                                    	<button type="button" class="btn btn-red" 	   role="button" tabindex="0"  onclick="deleteEntity(${id})">حذف</button>
								</div>
							</td>
								
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
	
	
</body>
</html>