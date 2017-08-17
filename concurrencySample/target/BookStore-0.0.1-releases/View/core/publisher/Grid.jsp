<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="true"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<!--------------------------- edit Content ---------------------------------->
<div class="modal fade" id="addModal" >
    <div class="modal-dialog modal-lg " >
        <div class="modal-content" >

        </div>
    </div>
</div>
<!--------------------------- edit Content ---------------------------------->

<!--------------------------- Grid Header ---------------------------------->
<div class="tile">
	<!-- tile header -->
	<div class="tile-header dvd dvd-btm">
		<h1 class="custom-font">
			<strong>لیست  انتشارات</strong>
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
			<li class="dropdown">
				<a role="button" onclick="showGrid()">
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
				<a role="button" id="btn-search-modal" tabindex="1"	class="dropdown-toggle btn-ef btn-ef-3 btn-default"> جستجو </a>
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
					<th class="centered">شماره تماس 
						<a class="orderLink" order="e.name" type="asc"> <i class="fa fa-caret-down"></i></a> 
						<a class="orderLink" order="e.name" type="desc"> <i	class="fa fa-caret-up"></i></a>
					</th>
					<th class="centered">آدرس  
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
		                	<td class="centered">${publisherName}</td>
		                	<td class="centered">${tel}</td>
		                	<td class="centered">${address}</td>
							<td class="centered">
								<div class="btn-group btn-group-xs">
										<button type="button" class="btn btn-greensea" role="button" tabindex="0" data-toggle="modal" href="Edit.jsp?id=${id}" data-target="#addModal" onclick="showPublisherProduct()">ویرایش</button>
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

