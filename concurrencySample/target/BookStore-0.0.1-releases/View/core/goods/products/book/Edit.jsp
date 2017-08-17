<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="true"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib prefix="codePlus" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<html>
<head>
<%@ include file="/View/ScriptHeader/AdminFrameHead.jsp"%>
<%@ include file="/View/ScriptHeader/Head.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<script language="javascript" type="text/javascript">
	var currentId = -1;
	var gradeArray = [];
	var fieldArray = [];
	var emptyEntity = {
		id : -1,
		goodsType : "0",
		name : "",
		isbn : "",
		code : "",
		price : "0",
		bookFormatTypeId : "",
		bookFormatTypeTopic : "",
		printYear : "",
		author : "",
		translator : "",
		pagesCount : 0,
		bookWeight : 0,
		bookTypeId : "",
		bookTypeTopic : "",
		grade : [],
		field : [],
		lessonId : "",
		lessonTopic : "",
		publisherId : "",
		publisherName : "",
		publisherProductId : "",
		publisherProductProductName : "",
		publishEdition : "",
		description : ""
	};

	var emptyEntityPictures = {
			id : -1,
			goodsId : "0",
			main:false,
			pictureName:"",
			pictureCode : "",
			description : ""
		};
	var id =<%=request.getParameter("id")%>;
	var currentEntity = $.extend(true, {}, emptyEntity);
	var currentEntityPictures= $.extend(true, {}, emptyEntityPictures);
	var restUrl = "<c:url value = '/rest/core/goods/products/book' />";
	var restUrlPublisher = "<c:url value = '/rest/core/publisher' />";
	var restUrlPublisherProduct = "<c:url value = '/rest/core/publisherProduct' />";
	var restUrlPictures = "<c:url value = '/rest/core/goods/products/goodsPictures' />";

	function init() {

	}

	$(function() {
		fillCombo("cmbBookFormatType",
				"<c:url value = '/rest/core/baseInformation/list/3' />", {},
				"id", "topic", "...");
		fillCombo("cmb‌‌BookType",
				"<c:url value = '/rest/core/baseInformation/list/4' />", {},
				"id", "topic", "...");
		fillCombo("cmbLesson",
				"<c:url value = '/rest/core/baseInformation/list/7' />", {},
				"id", "topic", "...");
		fillCombo("cmbPublisher", restUrlPublisher + "/getAll", {}, "id",
				"publisherName", "...");
		fillBaseInfo(6, "fieldBox");
		fillBaseInfo(5, "gradeBox");

		if (id != null)
			showCurrent(id);
	});

	function fillBaseInfo(baseInfoId, fieldsetId) {
		var restUrlBaseInfo = "<c:url value = '/rest/core/baseInformation/list/' />";
		$.getJSON(
						restUrlBaseInfo + baseInfoId,
						function(entityData) {
							$(entityData)
									.each(
											function(i, e) {
												$("#" + fieldsetId)
														.append(
																"<input type='checkbox' id='chk" + e.id + "' value='" + e.topic + "' class='" + fieldsetId  +"' realId='"+ e.id +"' />");
												$("#" + fieldsetId).append(
														"<span id=spn'" + e.id + "' >"
																+ e.topic
																+ "</span>");
												$("#" + fieldsetId).append(
														"<br/>")
											});

						});
	}

	function checkBaseInfoField() {
		fieldArray = [];
		$('.fieldBox').each(function(i, e) {
			if ($(this).is(':checked')) {
				fieldArray.push({
					id : $(this).attr('realId')
				});
			}
		});
	}

	function checkBaseInfoGrade() {
		gradeArray = [];
		$('.gradeBox').each(function(i, e) {
			if ($(this).is(':checked')) {
				gradeArray.push({
					id : $(this).attr('realId')
				});
			}
		});
	}

	function showCurrent(CurrentId) {
		clearEntity();
		currentId = CurrentId;
		Loader(true);
		$.getJSON(restUrl + "/load/" + currentId, function(entityData) {
			setInputByEntity(entityData);
			$("#goodsId").val(CurrentId);
			fillCmbPublihserProduct();
			fillTablePics();
			Loader(false);
		});
	}

	function clearEntity() {
		setInputByEntity(emptyEntity);
	}

	function setEntityFromInput(entity) {
		baseSetEntityFromInput(entity);
		checkBaseInfoField();
		checkBaseInfoGrade();
		entity.grade = gradeArray;
		entity.field = fieldArray;
		entity.price = removeMoneyFormat($("#txtPrice").val());

	}

	function setInputByEntity(entity) {
		baseSetInputByEntity(entity);
		$(entity.field).each(function(i, e) {
			$('#chk' + e.id).prop('checked', 'checked');
		});
		$(entity.grade).each(function(i, e) {
			$('#chk' + e.id).prop('checked', 'checked');
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
				window.parent.closeModal();
				fillTable();
				$("#closeModal").click();
				Loader(false);
			}
		});
	}

	function fillCmbPublihserProduct() {
		var publisherId = $("#cmbPublisher").val()
		if (publisherId == -1) {
			$('#cmbPublisherProduct').find('option:not(:first)').remove();
		} else {
			fillCombo("cmbPublisherProduct", restUrlPublisherProduct
					+ "/getAll/" + publisherId, {}, "id", "productName", "...");
		}
	}
	
	function fillPicture(fileCode) {
		var src = "<c:url value='/rest/attachment/front/getFile/' />"
				+ fileCode
		$("#bookPic").attr('src', src);
	}

	function saveEntityPictures(){
		currentEntityPictures.id=$("#pictureId").val();
		currentEntityPictures.goodsId=$("#goodsId").val();
		currentEntityPictures.pictureCode=$("#hiddenFileCode_picFileUpload").val();
		currentEntityPictures.pictureName=$("#tmpPath_picFileUpload").val();
		currentEntityPictures.description=$("#txtDescPicture").val();
		currentEntityPictures.main=$("#isMain").is(':checked');
		if(currentEntityPictures.pictureCode=="" || currentEntityPictures.pictureName=="")
			sweetAlert("خطا...!", " امکان ثبت بدون تصویر وجود ندارد", "error");
		
		Loader(true);
		$.ajax({
			type : "POST",
			url : restUrlPictures + "/save",
			data : JSON.stringify(currentEntityPictures),
			contentType : "application/json;",
			dataType : "json",
			success : function(res) {
				clearEntityPics();
				swal({
					title : "عملیات  با موفقیت انجام شد",
					timer : 1500,
					showConfirmButton : false,
					type : "success"
				});
				fillTablePics();
				Loader(false);
			}
		});
	}
	function deletePhotoEntity(id) {
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
				},
				function(){
					Loader(true);
					$ .ajax({
						type : "DELETE",
						url : restUrlPictures + "/delete/" + id,
						contentType : "application/json;",
						success : function(res) {
							if (res)
								fillTablePics();
							else
								sweetAlert("Oops...", "Something went wrong!", "error");
							},
						error : function() {
							sweetAlert("خطا...!", "خطای سیستمی", "error");
							Loader(false);
							}
							
					});
				  	swal("Deleted!", "Your imaginary file has been deleted.", "success");
				  	Loader(false);
			});
		}
    }
   function clearEntityPics(){
    	currentEntityPictures.id=-1;
		currentEntityPictures.pictureCode="";
		currentEntityPictures.pictureName="";
		currentEntityPictures.description="";
		currentEntityPictures.main="";
		$("#hiddenFileCode_picFileUpload").val("");
		$("#tmpPath_picFileUpload").val("");
		$("#txtDescPicture").val("");
		
    }

	  function fillTablePics() {
		  loadGridWithoutPaging('GridRowTemplatePics', 'entityBodyPics', restUrlPictures + "/getAll/"+id);
		}

		function showPhoto(photoId){
			var photoCode=$("#view"+photoId).attr('fileCode')
			var url = "<c:url value='/rest/attachment/front/getFile/' />"+photoCode;
			window.open(url);
				
		}
</script>

</head>
<body>
		<div id="tab">
			<!--   tab definition-->
			<ul class="nav nav-tabs">
				<li role="" class="active"><a href="#1a" 
					data-toggle="tab">  اطلاعات اصلی کتاب</a></li>
				<li role=""><a href="#2a" 
					data-toggle="tab">تصاویر</a></li>
			</ul>
			<!--   tab definition-->
			<div class="tab-content clearfix" style="padding: 5px 15px;">
				<div role="tabpanel" class="tab-pane active" id="1a">

					<input type="hidden" id="id" value="-1" />

					<div class="modal-body">
						<div class="row">

							<form id="FormEdit" class="form-horizontal">
								<fieldset>
									<div class=" form-group ">
										<label for="txtCode" class="col-md-2 control-label">کد
											کتاب</label>
										<div class="col-md-2">
											<input type="text" class="form-control input-md" id="txtCode"
												readonly="readonly" data-bind="code" />
										</div>
										<label for="txtName" class="col-md-2 control-label"
											style="color: red;">نام کتاب</label>
										<div class="col-md-6">
											<input type="text"
												class="form-control input-md validate[required]"
												id="txtName" data-bind="name" />
										</div>
									</div>
									<div class="form-group ">
										<label for="txtIsbn" class="col-md-2 control-label">شابک</label>
										<div class="col-md-2">
											<input type="text" class="form-control input-md"
												maxlength="50" id="txtIsbn" data-bind="isbn" />
										</div>
										<label for="txtPrice" class="col-md-2 control-label"
											style="color: red">قیمت</label>
										<div class="col-md-2">
											<input type="text" id="txtPrice" data-bind="price"
												class="form-control input-md numberOnly validate[required] moneySeprator" />
										</div>
										<label for="txtPrintYear" class="col-md-2 control-label">سال
											چاپ</label>
										<div class="col-md-2">
											<input type="text" class="form-control input-md numberOnly "
												maxlength="4" id="txtPrintYear" data-bind="printYear" />
										</div>
									</div>
									<div class=" form-group ">
										<label for="cmbBookFormatType" class="col-md-2 control-label">قطع
											کتاب</label>
										<div class="col-md-2">
											<select class="form-control input-md" id="cmbBookFormatType"
												data-bind="bookFormatTypeId" />
											<option value="-1">...</option>
											</select>
										</div>
										<label for="cmbPublisher" class="col-md-2 control-label"
											style="color: red;">انتشارات</label>
										<div class="col-md-2">
											<select
												class="form-control input-md validate[required,combo]"
												id="cmbPublisher" data-bind="publisherId"
												onchange="fillCmbPublihserProduct()">
												<option value="-1">...</option>
											</select>
										</div>
										<label for="cmbPublisherProduct"
											class="col-md-2 control-label">محصول</label>
										<div class="col-md-2">
											<select class="form-control input-md"
												id="cmbPublisherProduct" data-bind="publisherProductId">
												<option value="-1">...</option>
											</select>
										</div>
									</div>
									<div class="form-group">
										<label for="txtPublishEdition" class="col-md-2 control-label">نوبت
											چاپ</label>
										<div class="col-md-2">
											<input type="text" class="form-control input-md numberOnly"
												maxlength="3" id="txtPublishEdition"
												data-bind="publishEdition">

										</div>
										<label for="txtAuthor" class="col-md-2 control-label">نویسنده</label>
										<div class="col-md-2">
											<input type="text" class="form-control input-md "
												maxlength="20" id="txtAuthor" data-bind="author" />
										</div>
										<label for="txtTranslator" class="col-md-2 control-label">مترجم</label>
										<div class="col-md-2">
											<input type="text" class="form-control input-md "
												maxlength="20" id="txtTranslator" data-bind="author" />
										</div>
									</div>
									<div class="form-group">
										<label for="txtPagesCount" class="col-md-2 control-label">تعداد
											صفحات</label>
										<div class="col-md-2">
											<input type="text" class="form-control input-md numberOnly"
												maxlength="5" id="txtPagesCount" data-bind="pagesCount" />
										</div>
										<label for="txtBookWeight" class="col-md-2 control-label">وزن
											کتاب</label>
										<div class="col-md-2">
											<input type="text" class="form-control input-md numberOnly"
												maxlength="6" id="txtBookWeight" data-bind="bookWeight" />
										</div>
										<label for="cmb‌‌BookType" class="col-md-2 control-label">نوع
											کتاب</label>
										<div class="col-md-2">
											<select class="form-control input-md" id="cmb‌‌BookType"
												data-bind="bookTypeId">
												<option value="-1">...</option>
											</select>
										</div>
									</div>
									<div class="form-group">
										<label for="cmbLesson" class="col-md-2 control-label">درس</label>
										<div class="col-md-2">
											<select class="form-control input-md" id="cmbLesson"
												data-bind="lessonId">
												<option value="-1">...</option>
											</select>
										</div>
									</div>
									<div class="form-group">
										<fieldset id="fieldBox">
											<legend class="">رشته تحصیلی </legend>
										</fieldset>
									</div>
									<div class="form-group">
										<fieldset id="gradeBox">
											<legend class="">مقطع تحصیلی </legend>
										</fieldset>
									</div>
									<div class="form-group">
										<label for="txtDesc" class="col-md-2 control-label">توضیحات
										</label>
										<div class="col-md-6">
											<textarea class=" form-control" rows="3" id="txtDesc"
												data-bind="description"></textarea>
										</div>
									</div>
								</fieldset>
							</form>
						</div>
					</div>

<!-- 					<div class="modal-footer"> -->
						<button id="btnCancel" class="btn btn-default"
							data-dismiss="modal">انصراف</button>
						<input type="button" id="btnSave" class="btn btn-primary"
							onclick="saveEntity()" value="ذخیره"> <input
							type="button" data-dismiss="modal" style="display: none;"
							id="closeModal">
<!-- 					</div> -->
				</div>
				<div role="tabpanel" class="tab-pane" id="2a">
					<div class="modal-body">
						<div class="row">
							<form id="FormPics" class="form-horizontal">
							<input type="hidden" id="pictureId" value="-1" />
							<input type="hidden" id="goodsId" value="-1" />
								<fieldset>
									<div class=" form-group ">
										<div class="col-md-4">
										<label for="tmpPath_picFileUpload"
											class="col-md-6 control-label" style="color: red;">انتخاب
											تصویر </label>
											<codePlus:FileUpload id="picFileUpload" haveDelete="false"
												extensions="pdf|doc|docx|png|jpg|jpeg|bmp"
												fileNameDataBind="pictureName"
												fileCodeDataBind="pictureCode" maxSize="2000"
												callback="fillPicture">
											</codePlus:FileUpload>
										</div>
										<div class="col-md-2">
											<span>تصویر اصلی</span><input type="checkbox" id="isMain" />
										</div>
											
										<div class="col-md-4">
										<label for="txtDescPicture" class="control-label col-md-4 ">توضیحات
											</label>
											<input type="text" class="form-control col-md-6"  id="txtDescPicture"
												data-bind="description" />
										</div>
										<div class="col-md-2">
											<input type="button" id="btnSavePicture" 
												class="btn btn-primary" onclick="saveEntityPictures()"
												value="ذخیره">
												<input type="button" id="btnSearchPictures" 
												class="btn btn-primary" onclick="fillTablePics()"
												value="جستجو">
										</div>
									</div>
								</fieldset>
							</form>
						</div>
						
						<table class="table table-custom" id="gridPics" 
			width="100%" align="center">
			<thead>
			<tr>
				<th class="centered">ردیف</th>
				<th class="centered">نام تصویر 
					<a class="orderLink" order="e.name" type="asc"> 	<i class="fa fa-caret-down"></i></a> 
					<a class="orderLink" order="e.name" type="desc"> <i	class="fa fa-caret-up"></i></a>
				</th>
				<th class="centered">تصویر اصلی 
					<a class="orderLink" order="e.name" type="asc"> <i class="fa fa-caret-down"></i></a> 
					<a class="orderLink" order="e.name" type="desc"> <i	class="fa fa-caret-up"></i></a>
				</th>
					<th style="width: 160px;" class="centered">عملیات</th>
				</tr>
			</thead>
			<tbody id="entityBodyPics" class="entityBody">
				<script id="GridRowTemplatePics" type="text/html">
							<tr class="odd gradeX">
							<td class="centered"> <span class="tmplRowIndex"></span> </td>
		                	<td class="centered">${pictureName}</td>
		                	<td class="centered">
								{{if main==true}}
									<img src="<c:url value='/Content/images/Tick.png' /> " style="width:20px;height:20px;" />
								{{else}}
									<img src="<c:url value='/Content/images/Cancel.png' /> " style="width:20px;height:20px;" />
								{{/if}}

							</td>
							<td class="centered">
								<div class="btn-group btn-group-xs">
										<button type="button" id="view${id}" class="btn btn-greensea" role="button" fileCode=${pictureCode} onclick="showPhoto(${id})"  >مشاهده</button>
                                    	<button type="button" class="btn btn-red" role="button" tabindex="0" onclick="deletePhotoEntity(${id})">حذف</button>
								</div>
							</td>
								
		            	</tr>
					</script>
			</tbody>
		</table>
					</div>
				</div>
				<!--  end of pictures content -->
			</div>
		</div>
</body>
</html>