<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="codePlus" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
    <%@ include file="/View/ScriptHeader/FrontEndHead.jsp" %>
    <style>
        .bb {
            border: 1px solid darkred;
        }

        #content {
            padding: 20px 0;
        }

        .artifact-item {
            height: 400px;
            margin: 20px 0;
        }

        .artifact-item img {
            width: 100%;
            height: 288px;
        }

        .artifact-details {
            padding: 0 10px;
        }

        .separator {
            margin: 0;
        }

        .shop-icon {
            color: green;
            margin-top: 10px;
        }

        /*right panel */
        .right-panel {
            height: auto;
            padding: 0 5px;
        }

        /*multi select custom setting*/
        #searchTools .multiselect {

        }

        .multiselect-container {
            right: 0;
            text-align: right;
        }

        .checkbox input[type="checkbox"], .checkbox-inline input[type="checkbox"], .radio input[type="radio"], .radio-inline input[type="radio"] {
            margin-right: -20px;
        }

        .checkbox input[type="checkbox"] {
            opacity: 1 !important;
        }

        .checkbox-primary input[type="checkbox"] {
            opacity: 0 !important;
        }

        .multiselect-container > li > a > label {
            padding: 3px 35px 3px 40px;
        }

        .tooltip {
            direction: ltr;
        }

    </style>
    <script language="javascript" type="text/javascript">
        var restUrl = "<c:url value = '/rest/core/goods/products/book' />";
        var restUrlPublisher = "<c:url value = '/rest/core/publisher' />";
        var restUrlPublisherProduct = "<c:url value = '/rest/core/publisherProduct' />";
        var restUrlMenuSetting = "<c:url value = '/rest/core/menuSetting' />";
    	var menuId =null;
        
        var pageSize = 8;
        var pageNo = 0;
        var pageCount = 0;
        var order = 'e.id asc';

        function refreshcombo() {
            $("#cmbPublisherSearch").select2();
            $("#cmbPublisherProductSearch").select2();
            $("#cmbLessonSearch").select2();
            $("#cmbGradeSearch").select2();
            $("#cmbFieldSearch").select2();
            $("#cmb‌‌BookTypeSearch").select2();

        }

        $(function () {
        	menuId= <%=request.getParameter("menuId")%>;
            fillCombo("cmbPublisherSearch", restUrlPublisher + "/getAll", {}, "id", "publisherName", "...", -1, refreshcombo);
            fillCombo("cmbLessonSearch", "<c:url value = '/rest/core/baseInformation/list/7' />", {}, "id", "topic", "...", -1, refreshcombo);
            fillCombo("cmbGradeSearch", "<c:url value = '/rest/core/baseInformation/list/5' />", {}, "id", "topic", "...", -1, refreshcombo);
            fillCombo("cmbFieldSearch", "<c:url value = '/rest/core/baseInformation/list/6' />", {}, "id", "topic", "...", -1, refreshcombo);
            fillCombo("cmb‌‌BookTypeSearch", "<c:url value = '/rest/core/baseInformation/list/4' />", {}, "id", "topic", "...", -1, refreshcombo);
            stylingMultiCheckBox();
            fillTable();
            $("#ex2").slider({});
            $('.ui.dropdown')
                .dropdown({});
            $(".select2").select2();
        });


        function getPageCount(totalResult) {
            var divRes = totalResult / pageSize;
            pageCount = Math.ceil(divRes);
        }

        function loadBootPage() {
            // init bootpag
            $('#page-selection').bootpag({
                total: pageCount
            }).on("page", function (event, /* page number here */ num) {
                pageNo = num - 1;
                fillTable();
            });
        }
        function collapsePanel() {
            $("#collapseCat").on("hide.bs.collapse", function () {
                $("#catIcon").removeClass("fa fa-chevron-up");
                $("#catIcon").addClass("fa fa-chevron-down");
            });
            $("#collapseCat").on("show.bs.collapse", function () {
                $("#catIcon").removeClass("fa fa-chevron-down");
                $("#catIcon").addClass("fa fa-chevron-up");
            });
        }
        function fillTable() {
            var jsonData = {
                order: "e.id",
                pageNumber: pageNo,
                pageSize: pageSize,
                menuId:menuId,
                name: "",
                isbn: "",
                printYear: "",
                author: "",
                translator: "",
                publishers: getSelectedFromMultiple('cmbPublisherSearch'),
                publisherProducts: getSelectedFromMultiple('cmbPublisherProductSearch'),
                fields: getSelectedFromMultiple('cmbFieldSearch') ,
                lessons: getSelectedFromMultiple('cmbLessonSearch'),
                grades: getSelectedFromMultiple('cmbGradeSearch')
            };
            $.getJSON(restUrl + "/front/list/grid", jsonData,
                function (entities) {
                    if (entities.entityList) {
                        $('#entityBody  :not(script)').remove();
                        getPageCount(entities.totalRecords);
                        $('#GridRowTemplate').tmpl(entities.entityList).prependTo('#entityBody');
                        loadBootPage();
                    } else {
                        $('#entityBody  :not(script)').remove();
                        $('#GridRowTemplate').tmpl(entities).prependTo("#entityBody");
                    }
                    if (menuId!=null)
                    	loadSettingDetail(menuId); 
                	menuId=null;
                });
        }

        function loadSettingDetail(menuId){
    		$.getJSON(restUrlMenuSetting + "/front/load/" + menuId, function(entityData) {
        		if (entityData.publisherId!=null){
        			$("#cmbPublisherSearch").val(entityData.publisherId);
        			$("#cmbPublisherSearch").trigger('change');
        		} 
        		if (entityData.gradeId!=null){
        			$("#cmbGradeSearch").val(entityData.gradeId);
        			$("#cmbGradeSearch").trigger('change');
        		}
        		if (entityData.fieldId!=null){
        			$("#cmbFieldSearch").val(entityData.fieldId);
        			$("#cmbFieldSearch").trigger('change');
        		}  
        		if (entityData.publisherProductId!=null){
        			$("#cmbPublisherProductSearch").val(entityData.publisherProductId);
        			$("#cmbPublisherProductSearch").trigger('change');
        		}  
        		if (entityData.lessonId!=null){
        			$("#cmbLessonSearch").val(entityData.lessonId);
        			$("#cmbLessonSearch").trigger('change');
        		}  
    		});
        }

        function fillCmbPublihserProductSearch() {
            var publisherId = $("#cmbPublisherSearch").select2("val");
            if (publisherId == -1 ) {
                $('#cmbPublisherProductSearch').find('option:not(:first)').remove();
            }
            else if (publisherId!=null) {
                fillCombo("cmbPublisherProductSearch", restUrlPublisherProduct + "/getAllMulti/" + publisherId, {}, "id", "productName", "...", -1, refreshcombo);
            }
        }

        function stylingMultiCheckBox() {
//            $("a[tabindex='0']").addClass('checkbox checkbox-primary');
        }

    </script>
</head>
<body>
<%@ include file="../homePage/Header.jsp" %>
<%@ include file="../homePage/TopMenu.jsp" %>

<div class="col-lg-12" id="content">
    <div class="col-lg-12 right-panel">
        <div id="dirPath" class="row">
            <ol class="breadcrumb" style="background-color: #faf2cc">
                <li class="breadcrumb-item"><a href="#">Home</a></li>
                <li class="breadcrumb-item"><a href="#">Library</a></li>
                <li class="breadcrumb-item active">Data</li>
            </ol>
        </div>
    </div>
    <div class="col-lg-2 pull-right right-panel">
        <div id="category-filter" class="row">
            <div class="panel-group">
                <div class="panel panel-warning">
                    <div class="panel-heading " onclick="collapsePanel()" data-toggle="collapse" href="#collapseCat">
                        <h4 class="panel-title">
                            <a>دسته بندی</a>
                            <i id="catIcon" class="fa fa-chevron-down pull-left"></i>
                        </h4>
                    </div>
                    <div id="collapseCat" class="panel-collapse collapse">
                        <div class="checkbox checkbox-primary">
                            <input id="checkbox2" type="checkbox" checked="">
                            <label for="checkbox2">
                                Primary
                            </label>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="price-filter" class="row">
            <div class="panel-group">
                <div class="panel panel-warning">
                    <div class="panel-heading">
                        <h4 class="panel-title">قیمت</h4>
                    </div>
                    <div class="text-center">
                        <input style="width: 90% ; direction: ltr" id="ex2" type="text" class="span2" value=""
                               data-slider-min="10" data-slider-max="1000" data-slider-step="5"
                               data-slider-value="[250,450]"/>
                    </div>
                </div>
            </div>
        </div>
        <div id="book-type-filter" class="row">
            <div class="panel-group">
                <div class="panel panel-warning">
                    <div class="panel-heading " onclick="collapsePanel()" data-toggle="collapse" href="#collapseCat">
                        <h4 class="panel-title">
                            <a>دسته بندی</a>
                            <i id="typeIcon" class="fa fa-chevron-down pull-left"></i>
                        </h4>
                    </div>
                    <div id="collapseType" class="panel-collapse collapse">
                        <div>hasan</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-lg-10 ">

        <div id="searchTools" class="col-lg-12 form-group">
            <div class="box box-success">
                <div class="box-header with-border">
                    <div class="col-lg-10 pull-right">ابزار جستجوی سریع</div>
                    <div class="col-lg-2">
                        <a class="btn btn-success btn-dropbox" onclick="fillTable()"><i class="fa fa-search"><span class="text-icon">اعمال فیلتر</span></i></a>
                    </div>
                </div>
                <div class="box-body">
                    <div class="col-md-2 pull-right">
                        <label>نوع کتاب</label>
                        <select id="cmb‌‌BookTypeSearch" class="form-control select2" multiple="multiple"  data-placeholder="انتخاب فیلتر">
                        </select>
                    </div>
                    <div class="col-md-2 pull-right">
                        <label>انتشارات</label>
                        <select id="cmbPublisherSearch" class="form-control select2" multiple="multiple"  data-placeholder="انتخاب فیلتر"
                                onchange="fillCmbPublihserProductSearch()">
                        </select>
                    </div>
                    <div class="col-md-2 pull-right">
                        <label>محصول</label>
                        <select id="cmbPublisherProductSearch" class="form-control select2" multiple="multiple"  data-placeholder="انتخاب فیلتر">
                        </select>
                    </div>
                    <div class="col-md-2 pull-right">
                        <label>رشته</label>
                        <select id="cmbFieldSearch" class="form-control select2" multiple="multiple"  data-placeholder="انتخاب فیلتر">
                        </select>
                    </div>
                    <div class="col-md-2 pull-right">
                        <label>مقطع</label>
                        <select id="cmbGradeSearch" class="form-control select2" multiple="multiple"  data-placeholder="انتخاب فیلتر">
                        </select>
                    </div>
                    <div class="col-md-2 pull-right">
                        <label>درس</label>
                        <select id="cmbLessonSearch" class="form-control select2" multiple="multiple"  data-placeholder="انتخاب فیلتر">
                        </select>
                    </div>
                </div>
            </div>

        </div>
        <div id="inlineSearch" class="row"></div>
        <div id="sortTools" class="row"></div>

        <div class="col-lg-12">
            <div id="entityBody" class="entityBody">
                <script id="GridRowTemplate" type="text/html">
                    <div class="col-lg-3">
                        <div class="artifact-item">
                            <a href="#" onClick="goToArtifactPage(${id})">
                                <img src="<c:url value='/rest/attachment/front/getFile/${mainPictureCode}'/>"/>
                            </a>
                            <div class="artifact-details">
                                <div class="row lead">
                                    <div id="stars" class="starrr"></div>
                                    <!-- 								    	You gave a rating of <span id="count">0</span>  -->
                                </div>
                                <div>
                                    <h5>${name}</h5>
                                </div>
                                <div>
                                    <h5><span>انتشارات :</span>${publisherName} </h5>
                                </div>
                                <hr class="separator"/>
                                <a class="pull-left">
                                    <i class="fa fa-shopping-cart fa-lg shop-icon"></i></a>
                                <div>
                                    <h5> ${price} تومان </h5>
                                </div>
                            </div>
                        </div>
                    </div>
                </script>
            </div>
        </div>
        <div id="page-selection" style="direction:ltr;" class="pull-right"></div>
    </div>

</div>

<%@ include file="../homePage/Footer.jsp" %>
</body>
</html>