<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">


<%@ taglib prefix="codePlus" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <%@ include file="/View/ScriptHeader/AdminFrameHead.jsp" %>
    <%@ include file="/View/ScriptHeader/FrontEndHead.jsp" %>
    <%@ include file="/View/ScriptHeader/SweetAlertHead.jsp" %>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

    <script language="javascript" type="text/javascript">

        $(function () {
        });
        function goToUserProfile() {
            window.location = "<c:url value ='/View/frontEnd/userDashbord/Index.jsp'/>";
        }

        function changePassword() {
            var confirmPassword = $('#confirmPassword').val();
            var newPassword = $('#newPassword').val();
            var oldPassword = $('#oldPassword').val();
            if(newPassword.localeCompare(confirmPassword) == 0){
                var data = {
                    newPassword: newPassword,
                    oldPassword: oldPassword
                };

                $.ajax({
                    type: "POST",
                    url: restUrlUser + "/changePassword",
                    data: JSON.stringify(data),
                    contentType: "application/json;",
                    dataType: "json",
                    success: function (res) {
                        if(res != 0){
                            swal({
                                title: "عملیات  با موفقیت انجام شد",
                                timer: 1500,
                                showConfirmButton: false,
                                type: "success"
                            });
                        }else {
                            swal({
                                title: "کلمه عبور قبلی اشتباه است",
                                showConfirmButton: true,
                                type: "error"
                            });
                        }

                        $("#closeModal").click();
                    }
                });
            }else{
                swal({
                    title: "عدم تطابق رمز جدید و تکرار رمز",
                    showConfirmButton: true,
                    type: "error"
                });
            }


        }
    </script>
    <style type="text/css">
        .password-box {
            padding: 0;
            margin-top: 30px;
        }

        .form-group * {
            float: right;
        }

        .change-pass-header {
            height: 100px;
            background-color: #efeac6;
        }

        #key-logo {
            margin: 10px;
        }

        .change-pass-body {
            height: auto;
            background-color: #e6e2c6;
            padding: 50px 10px;
        }

        #changePassword label {
            text-align: left;
            color: #585757;
        }
    </style>
</head>
<body>
<jsp:include page='/View/frontEnd/homePage/Header.jsp' />
<jsp:include page='/View/frontEnd/homePage/TopMenu.jsp'/>

<div class="row" id="holder">
    <div class="col-md-8 col-md-offset-2 text-center password-box">
        <div class="col-lg-12 change-pass-header">
            <div id="key-logo" class="col-lg-12">
                <i class="fa fa-key fa-3x" aria-hidden="true"></i>
            </div>
            <div class="col-lg-12" style="font-size: 24px">تغییر رمز عبور</div>
        </div>
        <div class="col-lg-12 change-pass-body">
            <div class="col-lg-8 col-lg-offset-2">
                <form id="editProfileForm" class="form-horizontal">
                    <div class="box-body" id="changePassword">
                        <div class="form-group">
                            <label for="oldPassword" class="col-sm-3 control-label">کلمه عبور قدیم</label>

                            <div class="col-sm-9">
                                <input class="form-control" id="oldPassword" type="password">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="newPassword" class="col-sm-3 control-label">کلمه عبور جدید</label>

                            <div class="col-sm-9">
                                <input class="form-control" id="newPassword" type="password">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="confirmPassword" class="col-sm-3 control-label">تکرار کلمه عبور </label>

                            <div class="col-sm-9">
                                <input class="form-control" id="confirmPassword" type="password">
                            </div>
                        </div>
                    </div>
                </form>
                <div class="col-lg-4">
                    <a class="btn btn-block btn-social btn-tumblr" data-toggle="modal" href="editProfile.jsp"
                       onclick="goToUserProfile()"
                       data-target="#editUserModal">
                        <i class="fa fa-arrow-left fa-flip-horizontal"></i>
                        <span class="pull-right">بازگشت</span>
                    </a>
                </div>
                <div class="col-lg-4">
                    <a class="btn btn-block btn-social btn-github" onclick="changePassword()">
                        <i class="fa fa-lock fa-flip-horizontal"></i>
                        <span class="pull-right">تغییر رمز</span>
                    </a>
                </div>
            </div>

        </div>
    </div>
</div>


</body>
</html>
