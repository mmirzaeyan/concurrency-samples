<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="codePlus" tagdir="/WEB-INF/tags" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">

    <%@ include file="/View/ScriptHeader/FrontEndHead.jsp" %>
    <%@ include file="/View/ScriptHeader/ImageSliderHead.jsp" %>
    <%@ include file="/View/ScriptHeader/SweetAlertHead.jsp" %>

    <style type="text/css">
        #horizental-menu {
            display: none !important;
        }

        p, span {
            font-family: "B Yekan";
        }
        /*book details*/
        .title {
            font-size: 20px;
            margin-bottom: 22px;
            clear: both;
        }
        #technical-details{
            margin-top: 30px;
        }

        .product_seo_title {
            font-size: 13px;
            margin-bottom: 40px;
            color: #999;
            display: block;
        }

        b.title {
            /*font: normal 16px yekan;*/
            color: #555;
            margin-bottom: 30px;
            clear: both;
            display: block;
            padding-right: 12px;
        }

        .spec-list {
            margin-bottom: 38px;
        }

        ul.spec-list li {
            margin-bottom: 10px;
        }

        .clearfix {
            display: block;
        }

        ul.spec-list span.technicalspecs-title {
            float: right;
            background: #f0f1f2;
            min-height: 36px;
            padding: 9px 21px;
            width: 22%;
            border-radius: 5px;
        }

        ul.spec-list span.technicalspecs-value {
            background: #f7f9fa;
            padding: 9px 21px;
            min-height: 36px;
            color: #777;
            float: left;
            border-radius: 5px;
        }

        /*user comment*/
        .direct-chat-name {
            margin: 10px 0;
            font-size: 16px;
            font-weight: normal !important;
        }
        .direct-chat-timestamp{
            margin: 10px 0;
            font-size: 14px;
            font-weight: normal !important;
        }
        .right .direct-chat-text {
            margin-right: 50px;
            margin-left: 0;
            line-height: 24px;
        }
        .direct-chat-msg{
            margin-top:10px;
        }
    </style>
    <script type="text/javascript">

        var restUrl = "<c:url value = '/rest/core/goods/products/book' />";
        var restUrlOrderItem = "<c:url value = '/rest/order/orderItem/front/addToBasket/' />";
        var restUrlPicture = "<c:url value = '/rest/core/goods/products/goodsPictures' />"
        var restUrlUserComments = "<c:url value = '/rest/core/goods/userComments' />"


        var artifactId = <%=request.getParameter("artifactId")%>;
        if (artifactId != null) {
            loadArtifact(artifactId);
            loadUserComments(artifactId);
        }

        function setInputByEntity(entity) {
            baseSetInputByEntity(entity);
            $(entity.field).each(function (i, e) {
                $('#chk' + e.id).prop('checked', 'checked');
            });
            $(entity.grade).each(function (i, e) {
                $('#chk' + e.id).prop('checked', 'checked');
            });
        }

        function loadGoodPictures(productId) {
            $.getJSON(restUrlPicture + "/front/getLimit/" + productId, function (entities) {
                if (entities) {
                    $('#artifactPicture').attr("src", "<c:url value='/rest/attachment/front/getFile/'/>" + entities[0].pictureCode);
                    for (i = 1; i <= (entities.length) - 1 && i <= 3; i++) {
                        $("#thumb-" + i).attr("src", "<c:url value='/rest/attachment/front/getFile/'/>" + entities[i].pictureCode);
                        $("#thumb-" + i).attr("href", "imageSlider.jsp?artifactId=" + entities[i].goodsId);
                    }
                }
            });
        }

        function loadArtifact(productId) {
            $.getJSON(restUrl + "/front/load/" + productId, function (entities) {
                if (entities) {
                    setInputByEntity(entities);
                    loadGoodPictures(productId);
                    loadTechnicalDetails(entities);
                }
            });
        }

        function addToShoppingCart() {
            $.ajax({
                type: "POST",
                url: restUrlOrderItem + artifactId,
                success: function (res) {
                    if (res)
                        swal("", "محصول مورد نظر با موفقیت به سبد خرید شما اضافه شد", "success");
                    return res.id
                }
            });
        }

        function loadTechnicalDetails(entities) {
            $('#detailsTemplate').tmpl(entities).prependTo('#detailsBody');
        }

        function loadUserComments(artifactId) {
            $('#CommentsBody :not(script)').remove();
            $.getJSON(restUrlUserComments + "/front/list/" + artifactId, null, function (entities) {
                if (entities.entityList)
                    $('#CommentsTemplate').tmpl(entities.entityList).prependTo('#CommentsBody');
                else
                    $('#CommentsTemplate').tmpl(entities).prependTo('#CommentsBody');
            });
        }

        function saveComments() {
            jsonData = {
                goodsId: artifactId,
                comments: $("#txtComment").val()
            };

            $.ajax({
                type: "POST",
                url: restUrlUserComments + "/save",
                data: JSON.stringify(jsonData),
                contentType: "application/json;",
                dataType: "json",
                success: function (res) {
                    swal({
                        title: "عملیات  با موفقیت انجام شد",
                        timer: 1500,
                        showConfirmButton: false,
                        type: "success"
                    });
                    $("#txtComment").val("");
                    loadUserComments(artifactId);
                }
            });

        }

    </script>
</head>
<body>
<%@ include file="../homePage/Header.jsp" %>
<%@ include file="../homePage/TopMenu.jsp" %>
<form action="artifact-form">
    <div id="artifactContainer">
        <div class="container-fluid">
            <div class="content-wrapper">
                <div class="item-container">
                    <div class="container" id="artifact">
                        <div class="col-md-12">
                            <div class="product col-md-3 pull-right">
                                <center>
                                    <img id="artifactPicture" data-bind="pictureCode" class="image-main" src=""
                                         alt=""></img>
                                </center>
                            </div>
                            <div class="container service1-items col-sm-2 col-md-2 ">
                                <center>
                                    <a class="service1-item">
                                        <img id="thumb-1" class="image-thumb dropdown-toggle"
                                             src="../../../NewTheme/images/blank-white-book.jpg"
                                             alt=""
                                             data-toggle="modal"
                                             href=""
                                             data-target="#addModal"></img>
                                    </a>
                                    <a class="service1-item">
                                        <img id="thumb-2" class="image-thumb dropdown-toggle"
                                             src="../../../NewTheme/images/blank-white-book.jpg"
                                             alt=""
                                             data-toggle="modal"
                                             href=""
                                             data-target="#addModal"></img>
                                    </a>
                                    <a class="service1-item">
                                        <img id="thumb-3" class="image-thumb dropdown-toggle"
                                             src="../../../NewTheme/images/blank-white-book.jpg"
                                             alt=""
                                             data-toggle="modal"
                                             href=""
                                             data-target="#addModal"></img>
                                    </a>
                                </center>
                            </div>
                            <div class="col-md-7">
                                <label class="product-title">نام محصول :</label>
                                <div class="product-title" data-bind="name"></div>
                                <hr>
                                <label class="product-title">توضیحات :</label>
                                <div class="product-desc" data-bind="description"></div>
                                <hr>
                                <label class="product-title">قیمت :</label>
                                <div class="product-price" data-bind="price"></div>
                                <hr>
                                <div class="btn-group cart">
                                    <a class="btn btn-success"> <i
                                            class="fa fa-shopping-cart"></i> <input type="button"
                                                                                    value="اضافه به سبد خرید"
                                                                                    onclick="addToShoppingCart()"
                                                                                    style="background: none; color: white; padding: 0; border: 0;"/>
                                    </a>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
                <div class="container-fluid">
                    <div class="col-md-12 product-info">
                        <ul id="myTab" class="nav nav-tabs nav_tabs nav-right-to-left">
                            <li class="active"><a href="#service-one" data-toggle="tab">مشخصات فنی</a></li>
                            <li><a href="#service-two" data-toggle="tab">نظرات کاربران</a></li>
                            <li><a href="#service-three" data-toggle="tab">پرسش و پاسخ</a></li>
                        </ul>

                        <div id="myTabContent" class="tab-content">
                            <div class="tab-pane fade in active" id="service-one">
                                <section id="detailsBody" class="container prod	uct-info">
                                    <script id="detailsTemplate" type="text/html">
                                        <div id="technical-details">
                                            <b class="title"><span> مشخصات فنی </span>
                                                <span class="product_seo_title">
                                                    <span>کتاب </span>${name} <span>اثر </span>${author}
                                                </span>
                                            </b>


                                            <b class="title">
                                                <i class="icon icon-caret-left-blue"></i>
                                                <span>مشخصات فيزيکي</span>
                                            </b>
                                            <ul class="spec-list row">
                                                <li class="clearfix col-lg-12">
                                                    <span class="technicalspecs-title col-lg-3">وزن</span>
                                                    <span class="technicalspecs-value col-lg-9" id="bookWeight">
                                                        ${bookWeight}
                                                    </span>
                                                </li>
                                                <li class="clearfix col-lg-12">
                                                    <span class="technicalspecs-title col-lg-3">قطع</span>
                                                    <span class="technicalspecs-value col-lg-9">
                                                        ${bookFormatTypeTopic}
                                                    </span>
                                                </li>
                                                <li class="clearfix col-lg-12">
                                                    <span class="technicalspecs-title col-lg-3"
                                                    >تعداد صفحات</span>
                                                    <span class="technicalspecs-value col-lg-9">
                                                        ${pagesCount}
                                                    </span>
                                                </li>
                                            </ul>
                                            <b class="title">
                                                <i class="icon icon-caret-left-blue"></i>
                                                <span>مشخصات فني</span>
                                            </b>
                                            <ul class="spec-list row">
                                                <li class="clearfix col-lg-12">
                                                    <span class="technicalspecs-title col-lg-3">نويسنده/نويسندگان</span>
                                                    <span class="technicalspecs-value col-lg-9">
                                                        ${author}
                                                    </span>
                                                </li>
                                                <li class="clearfix col-lg-12">
                                                    <span class="technicalspecs-title col-lg-3">مترجم/مترجمان</span>
                                                    <span class="technicalspecs-value col-lg-9">
                                                        ${translator}
                                                    </span>
                                                </li>
                                                <li class="clearfix col-lg-12">
                                                    <span class="technicalspecs-title col-lg-3">ناشر</span>
                                                    <span class="technicalspecs-value col-lg-9">
                                                        ${publisherName}
                                                    </span>
                                                </li>
                                                <li class="clearfix col-lg-12">
                                                    <span class="technicalspecs-title col-lg-3">نوبت چاپ</span>
                                                    <span class="technicalspecs-value col-lg-9">
                                                        ${publishEdition}
                                                    </span>
                                                </li>
                                                <li class="clearfix col-lg-12">
                                                    <span class="technicalspecs-title col-lg-3">تاريخ چاپ</span>
                                                    <span class="technicalspecs-value col-lg-9">
                                                        ${printYear}
                                                    </span>
                                                </li>

                                                <li class="clearfix col-lg-12">
                                                    <span class="technicalspecs-title col-lg-3">شابک</span>
                                                    <span class="technicalspecs-value col-lg-9">
                                                        ${isbn}
                                                    </span>
                                                </li>
                                                <li class="clearfix col-lg-12">
                                                    <span class="technicalspecs-title col-lg-3">ساير توضيحات</span>
                                                    <span class="technicalspecs-value col-lg-9">
                                                        ${description}
                                                    </span>
                                                </li>
                                            </ul>


                                        </div>
                                    </script>

                                </section>
                            </div>
                            <div class="tab-pane fade" id="service-two">
                                <section id="CommentsBody" class="entityBody container">
                                    <script id="CommentsTemplate" type="text/html">
                                        <div class="direct-chat-msg right">
                                            <div class="direct-chat-info clearfix">
                                                <span class="direct-chat-name pull-right">${userNameAndFamily}</span>
                                                <span class="direct-chat-timestamp pull-left">23 Jan 2:05 pm</span>
                                            </div>
                                            <!-- /.direct-chat-info -->
                                            <img class="direct-chat-img" src="../../../NewTheme/images/frontEnd/userComments/user.png" alt="Message User Image" ><!-- /.direct-chat-img -->
                                            <div class="direct-chat-text col-md-9 pull-right">
                                                ${comments}
                                            </div>
                                            <!-- /.direct-chat-text -->
                                        </div>
                                    </script>
                                </section>
                                <sec:authorize access="hasRole('ROLE_USER')">
                                    <div class="direct-chat-msg right">
                                        <div class="col-lg-12">
                                            <label>نظر شما : </label>
                                        </div>
                                        <div class="col-md-9 pull-right">
                                        <textarea class="form-control" id="txtComment" style="margin-top: 30px ;margin-right:80px;" rows="10"
                                                  cols="100"></textarea>
                                        </div>

                                    </div>


                                    <div class="row" align="left">
                                        <a class="btn btn-success btn-dropbox" onclick="saveComments()"><i
                                                class="fa fa-save"><span class="text-icon">ثبت نظر</span></i></a>
                                    </div>
                                </sec:authorize>
                            </div>
                            <div class="tab-pane fade" id="service-three"></div>
                        </div>
                        <hr>
                    </div>
                </div>
            </div>
        </div>
    </div>
</form>
<!--------------------------- Image Slider Content ---------------------------------->
<div class="modal fade" id="addModal">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <%@ include file="imageSlider.jsp" %>
        </div>
    </div>
</div>
<!--------------------------- Image Slider Content ---------------------------------->
</body>
</html>