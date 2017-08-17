<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="true"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<!--------------------------- edit Content ---------------------------------->
<div class="modal fade" id="addModal" >
    <div class="modal-dialog modal-lg">
        <div class="modal-content">

        </div>
    </div>
</div>
<!--------------------------- edit Content ---------------------------------->



<!--------------------------- Grid Header ---------------------------------->
<div class="tile">
	<!-- tile header -->
	<div class="tile-header dvd dvd-btm">
		<h1 class="custom-font">
			<strong>لیست کتاب ها</strong>
		</h1>
		<ul class="controls">
			
			<li class="dropdown">
				<a role="button" onclick="fillTable()">
					<i class="fa fa-refresh" role="button"></i>
				</a>
			</li>
			<li class="dropdown">
				<a role="button" id="btn-edit-modal" tabindex="0" class="dropdown-toggle btn btn-greensea color-gray-light" data-toggle="modal" href="Edit.jsp" data-target="#addModal">
				 ثبت رکورد جدید 
				 </a>
			</li>
			<li class="dropdown " style="margin-left: 24px;">
				<!-- data-toggle="modal" data-target="#modal-search" --> 
				<a role="button" id="btn-search-modal" tabindex="1"	class="dropdown-toggle btn-ef btn-ef-3 btn-default" onclick="clearSearch()"> پاک کردن </a>
			</li>
			<li class="dropdown " style="margin-left: 24px;">
				<!-- data-toggle="modal" data-target="#modal-search" --> 
				<a role="button" id="btn-search-modal" tabindex="1"	class="dropdown-toggle btn-ef btn-ef-3 btn-default" onclick="fillTable()"> جستجو </a>
			</li>
		</ul>
	</div>
	<!-- /tile header -->
	<fieldset class="form-horizontal">
	<div class="form-group">
	<label for="txtNameSearch" class="col-md-1 control-label " >نام کتاب</label>
		<div class="col-md-2">
			<input	type="text"  class="form-control input-md searchControl"  id="txtNameSearch" >
		</div>
		<label for="txtIsbnSearch" class="col-md-1 control-label" >شابک</label>
		<div class="col-md-2">
			<input	type="text"  class="form-control input-md searchControl"  id="txtIsbnSearch" >
		</div>
		<label for="txtPrintYearSearch" class="col-md-1 control-label">سال چاپ</label>
		<div class="col-md-2">
				<input	type="text"  class="form-control input-md numberOnly searchControl" maxlength="4" id="txtPrintYearSearch" >
		</div>
		<div class="form-group">
			<label for="txtAuthorSearch" class="col-md-1 control-label">نویسنده</label>
			<div class="col-md-2">
					<input	type="text"  class="form-control input-md searchControl" maxlength="4" id="txtAuthorSearch" >
			</div>
			<label for="txtTranslatorSearch" class="col-md-1 control-label">مترجم</label>
			<div class="col-md-2">
					<input	type="text"  class="form-control input-md searchControl" maxlength="4" id="txtTranslatorSearch" >
			</div>
			<label for="cmbPublisherSearch" class="col-md-1 control-label">انتشارات</label>
			<div class="col-md-2">
					<select class="multiCombo" multiple="multiple" class="col-md-2"  id="cmbPublisherSearch" onchange="fillCmbPublihserProductSearch()">
						<option value="-1">...</option>
					</select>
			</div>
			<label for="cmbPublisherProductSearch" class="col-md-1 control-label">محصول</label>
			<div class="col-md-2">
					<select class="multiCombo" multiple="multiple" class="col-md-2"  id="cmbPublisherProductSearch" >
						<option value="-1">...</option>
					</select>
			</div>
			
			<label for="cmbFieldSearch" class="col-md-1 control-label">رشته</label>
			<div class="col-md-2">
					<select class="multiCombo" multiple="multiple" class="col-md-2"  id="cmbFieldSearch" >
						<option value="-1">...</option>
					</select>
			</div>
		</div>
	
	<div class="form-group">
		<label for="cmbLessonSearch" class="col-md-1 control-label">درس</label>
		<div class="col-md-2">
				<select class="multiCombo" multiple="multiple" class="col-md-2"  id="cmbLessonSearch" >
					<option value="-1">...</option>
				</select>
		</div>
		
		<label for="cmbGradeSearch" class="col-md-1 control-label">مقطع</label>
		<div class="col-md-2">
				<select class="multiCombo" multiple="multiple" class="col-md-2"  id="cmbGradeSearch" >
					<option value="-1">...</option>
				</select>
		</div>
		<label for="cmb‌‌BookTypeSearch" class="col-md-1 control-label"> نوع کتاب </label>
		<div class="col-md-2">
			<select class="multiCombo col-md-2" multiple="multiple" id="cmb‌‌BookTypeSearch">
				<option value="-1">...</option>
			</select>
		</div>
	
	</div>
	</div>
	</fieldset>
<!------------------------------- Grid Header ---------------------------------->
	
<!------------------------------- Grid Body ------------------------------------>
	<div class="tile-body">
		<div id="gridSearchBox" style="display: none">
			<div class="panel panel-default panel-filled ">
				<div class="panel-heading bg-default">
					<h3 class="panel-title custom-font ">جستجو</h3>
				</div>
				<div class="panel-body bg-default" id="searchBox">
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
		<table class="table table-custom" id="grid" 
			width="100%" align="center">
			<thead>
				<tr>
					<th class="centered">ردیف</th>
					<th class="centered">نام کتاب 
						<a class="orderLink" order="e.name" type="asc"> 	<i class="fa fa-caret-down"></i></a> 
						<a class="orderLink" order="e.name" type="desc"> <i	class="fa fa-caret-up"></i></a>
					</th>
					<th class="centered">انتشارات 
						<a class="orderLink" order="e.name" type="asc"> <i class="fa fa-caret-down"></i></a> 
						<a class="orderLink" order="e.name" type="desc"> <i	class="fa fa-caret-up"></i></a>
					</th>
					<th class="centered">ویرایش  
						<a class="orderLink" order="e.categoryType" type="asc"><i class="fa fa-caret-down"></i></a>
						<a class="orderLink" order="e.categoryType" type="desc"><i class="fa fa-caret-up"></i></a>
					</th>
					<th class="centered"> قیمت 
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
		                	<td class="centered">${name}</td>
		                	<td class="centered">${publisherName}</td>
		                	<td class="centered">${publishEdition}</td>
							<td class="centered money">${price}</td>
							<td class="centered">
								<div class="btn-group btn-group-xs">
										<button type="button" class="btn btn-greensea" role="button" tabindex="0" data-toggle="modal" href="Edit.jsp?id=${id}" data-target="#addModal">ویرایش</button>
                                    	<button type="button" class="btn btn-red" role="button" tabindex="0" onclick="deleteEntity(${id})">حذف</button>
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

