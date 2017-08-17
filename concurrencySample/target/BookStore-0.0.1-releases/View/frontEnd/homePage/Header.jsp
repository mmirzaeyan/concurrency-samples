<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<script language="javascript" type="text/javascript">
    var restUrlUser = "<c:url value = '/rest/security/user' />";

    $(function () {
        manageUser();
    });
    function getAuthenticatedUser() {
        var url = "<c:url value = '/rest/security/user/authenitacedUser' />";
        var authenticatedUser = {};
        $.ajax({
            type: "GET",
            url: url,
            contentType: "application/json;",
            dataType: "json",
            async: false,
            success: function (entities) {
                if (entities!=null)
                authenticatedUser = entities;
            }
        });
        return authenticatedUser;
    }
    function manageUser() {
        user = getAuthenticatedUser();
        if (user != null)
            $("#userName").html( user.firstName + " " + user.lastName + " " + "،" + " " +'خوش امدید ');
    }

    function goToBasketPage() {
        window.location = "<c:url value ='/View/frontEnd/cart/Index.jsp'/>";
    }

</script>
<!------------- header ---------------->
<div id="header">
    <div class="row">
        <div class="header">
            <div id="header-right" class="col-lg-8 pull-right">
                <div id="header-user" class="col-lg-12 pull-right">
                    <sec:authorize access="!hasRole('ROLE_USER')">
                        <span id="lock-icon" class="fa fa-lock user-icon"></span>
                        <span class="user-text-color">
                            <a  href="<c:url value ="/View/frontEnd/login.jsp"/>"> ورود</a>
                        </span>
                        <span id="register-icon" class="fa fa-user user-icon"></span>
                        <span class="user-text-color">
                            <a class="user-text-color" href="<c:url value ="/View/frontEnd/register.jsp"/>">ثبت نام</a>
                        </span>
                    </sec:authorize>
                    <sec:authorize access="hasRole('ROLE_USER')">
                        <span id="user-icon" class="fa fa-user user-icon"></span>
                        <a id="userName" class="user-text-color" title="پروفایل من" href="<c:url value ="/View/security/userDashbord/Index.jsp"/>"></a>
                        <span id="user-exit" class="user-text-color">
                            <span id="user-separator" >،</span><a class="user-text-color" href='<c:url value="/logout" />'>خروج </a>
                        </span>
                    </sec:authorize>
                </div>
                <div id="header-search" class="col-lg-12 pull-right">
                    <div class="col-lg-3 pull-right">
                        <a class="btn btn-block btn-social btn-success" onclick="goToBasketPage()">
                            <i class="fa fa-shopping-cart fa-flip-horizontal"></i>
                            <span class="pull-right">سبد خرید</span>
                            <sec:authorize access="hasRole('ROLE_USER')">
                                <div id="shop-count"></div>
                            </sec:authorize>
                        </a>
                    </div>
                    <div class="col-lg-7 pull-right">
                        <div class="input-group " id="searchBar">
                            <div class="input-group-btn">
                                <button type="button" class="btn btn-success">جستجو</button>
                            </div>
                            <!-- /btn-group -->
                            <input class="form-control" type="text" placeholder="عنوان کتاب ، نام مولف ، نام مترجم ...">
                        </div>
                    </div>
                </div>
            </div>
            <div id="header-logo" class="col-lg-4 text-center pull-left">
                <a href="/../../..">
                    <img src="../../../NewTheme/images/frontEnd/loading.png" title="فروشگاه اینترنتی کتبز | بررسی و خرید آنلاین کتاب">
                </a>
            </div>
        </div>
    </div>
    <%--<div id="searchBar" class="col-lg-5 col-md-5 pull-right text-center pagination" style="vertical-align: bottom">--%>
        <%--<div class="input-group " dir="ltr">--%>
                <%--<span class="input-group-btn ">--%>
                    <%--<button class="btn btn-default header" type="button" style="background: #d91f2b;) "><img--%>
                            <%--src="../../../NewTheme/images/frontEnd/homePage/magnifier.png" alt="جستجو"--%>
                            <%--style="width: 35px;"/></button>--%>
                <%--</span>--%>
            <%--<input name="search_param" type="text" class="form-control header"--%>
                   <%--placeholder="عنوان کتاب ، نام مولف ، نام مترجم ..." dir="rtl"/>--%>
            <%--<span class="input-group-btn search-panel">--%>
                    <%--<button type="button" class="btn btn-default dropdown-toggle header"--%>
                            <%--data-toggle="dropdown"><span id="search_concept">دسته بندی</span> <span--%>
                            <%--class="caret"></span>--%>
                    <%--</button>--%>
                    <%--<ul class="dropdown-menu" role="menu">--%>
                        <%--<li><a href="#">دسته بندی</a></li>--%>
                        <%--<li><a href="#">انتشارات</a></li>--%>
                        <%--<li><a href="#">کمک درسی </a></li>--%>
                        <%--<li><a href="#">درسی</a></li>--%>
                        <%--<li><a href="#">دانشگاهی</a></li>--%>
                    <%--</ul>--%>
                <%--</span>--%>

        <%--</div>--%>
    <%--</div>--%>


</div>
<!------------- header ---------------->