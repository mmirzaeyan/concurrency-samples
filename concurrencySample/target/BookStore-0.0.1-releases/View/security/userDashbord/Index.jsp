<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="codePlus" tagdir="/WEB-INF/tags" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">

    <%@ include file="/View/ScriptHeader/FrontEndHead.jsp" %>
    <%@ include file="/View/ScriptHeader/SweetAlertHead.jsp" %>

    <style type="text/css">
        .tbl-user-info{
            margin: 20px auto;
            width: 90%;
            min-width: 90%;
            font-size: 14px;
        }

        .tbl-user-info tbody tr{
            height: 40px;
        }

        .tbl-user-info th{
            color: #4b4e51;
            text-align: left !important;
            padding-left:5px!important;
        }

        .tbl-user-info td{
            color: #747373;
        }
    </style>
    <script type="text/javascript">

        var restUrlOrder = "<c:url value = '/rest/order/order' />";
        var restUrlUser = "<c:url value = '/rest/security/user' />";
        var pageSize = 5;
        var pageNo = 0;
        var order = 'e.id asc';

        $(function () {
            fillTable();
            loadUser();
        });

        function fillTable() {
            jsonData = {
                order: 'e.id asc',
                pageNumber: pageNo,
                pageSize: pageSize
            };
            $('#GridRowTemplate :not(script)').remove();
            $.getJSON(restUrlOrder + "/getUserOrders", null, function (entities) {
                if (entities.entityList)
                    $('#GridRowTemplate').tmpl(entities.entityList).prependTo('#entityBody');
                else
                    $('#GridRowTemplate').tmpl(entities).prependTo('#entityBody');
                tmplRowIndex('entityBody', null, null);
            });
        }

        function loadUser() {
            user = getAuthenticatedUser();
            $("#spnFullName").html(user.firstName + " " + user.lastName);
            $("#spnUserName").html(user.userName);
            $("#spnEmail").html(user.email);
        }

        function goToChangePassword(){
            window.location = "<c:url value ='/View/security/userDashbord/userChangePassword.jsp'/>";
        }

    </script>
</head>
<body>
<jsp:include page='/View/frontEnd/homePage/Header.jsp' />
<jsp:include page='/View/frontEnd/homePage/TopMenu.jsp'/>

<div class="modal fade" id="orderDetailModal" >
    <div class="modal-dialog modal-lg " >
        <div class="modal-content" >

        </div>
    </div>
</div>
<div class="modal fade" id="editUserModal" >
    <div class="modal-dialog modal-md " >
        <div class="modal-content" >

        </div>
    </div>
</div>
<section class="content">
    <div class="col-lg-12">
        <div class="box box-danger ">
            <div class="box-header with-border box-danger">
                <h3 class="box-title">اطلاعات کاربر</h3>
            </div>

            <div class="box-body table-responsive no-padding ">
                <table class="tbl-user-info">
                    <tr>
                        <th>نام و نام خانوادگی :</th>
                        <td><span id="spnFullName"></span>
                        <th>نام کاربری :</th>
                        <td><span id="spnUserName"></span></td>
                        <th>کد ملی :</th>
                        <td><span id="spnNationalCode"></span>001-294679-6</td>
                    </tr>
                    <tr>
                        <th>آدرس الکترونیک :</th>
                        <td><span id="spnEmail"></span></td>
                        <th>شماره تلفن ثابت :</th>
                        <td><span id="spnPhone"></span>021-33799937</td>
                        <th>شماره تلفن همراه :</th>
                        <td><span id="spnMobile"></span>09361673748</td>
                    </tr>
                    <tr>
                        <th>محل سکونت :</th>
                        <td colspan="4" style="width: 70%">تهران - خیابان پیروزی - خیابان شکوفه - میدان کلانتری - خیابان کرمان - کوچه سفید - کوچه نیلوفر - پلاک 1</td>
                    </tr>
                    <tr >
                        <th colspan="4"></th>
                        <td colspan="4">
                            <div class="col-lg-5">
                                <a class="btn btn-block btn-social btn-tumblr" data-toggle="modal" href="editProfile.jsp" data-target="#editUserModal" >
                                    <i class="fa fa-edit fa-flip-horizontal"></i>
                                    <span class="pull-right">ویرایش اطلاعات</span>
                                </a>
                            </div>
                            <div class="col-lg-5">
                                <a class="btn btn-block btn-social btn-github" onclick="goToChangePassword()">
                                    <i class="fa fa-lock fa-flip-horizontal"></i>
                                    <span class="pull-right">تغییر رمز</span>
                                </a>
                            </div>
                        </td>
                    </tr>

                </table>
            </div>
        </div>
    </div>
    <div class="col-lg-12">
        <div class="box box-danger ">
            <div class="box-header with-border box-danger">
                <h3 class="box-title">سفارشات من</h3>

            </div>
            <!-- /.box-header -->
            <div class="box-body table-responsive no-padding ">
                <table class="table table-hover">
                    <tr>
                        <th>ردیف</th>
                        <th>شماره سفارش</th>
                        <th>تاریخ</th>
                        <th>مبلغ کل</th>
                        <th>وضعیت</th>
                        <th> جزییات</th>
                    </tr>
                    <tbody id="entityBody" class="entityBody">
                    <script id="GridRowTemplate" type="text/html">
                        <tr>
                            <td><span class="tmplRowIndex"></span></td>
                            <td>${id}</td>
                            <td>${createdDateShamsi}</td>
                            <td>${price}</td>

                            {{if orderStatus==1}}
                            <td><span class="label label-success">${orderStatusPersianTitle}</span></td>
                            {{else}}
                            <td><span class="label label-warning">${orderStatusPersianTitle}</span></td>
                            {{/if}}
                            <td>
                                <i style="cursor: pointer;" class="fa fa-fw fa-search"  data-toggle="modal" href="OrderDetail.jsp?id=${id}" data-target="#orderDetailModal" ></i>
                            </td>
                        </tr>
                    </script>
                    </tbody>
                </table>
            </div>
            <!-- /.box-body -->
        </div>
        <!-- /.box -->
    </div>
</section>

</body>
</html>