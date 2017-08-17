<%@ page contentType="text/html; charset=UTF-8" language="java"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <%@ include file="/View/ScriptHeader/FrontEndHead.jsp" %>
    <%@ include file="/View/ScriptHeader/ValidationHead.jsp" %>
    <%@ include file="/View/ScriptHeader/SweetAlertHead.jsp" %>
    <link type="text/css" rel="stylesheet" href="../../NewTheme/css/frontEnd/login/login.css">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

    <title>ثبت نام</title>
</head>

<body>
<div class="register-box">
    <div class="register-logo">
        <a href="homePage/Index.jsp"><span> به<b id="site-title"> کُتُبز</b>بپیوندید</span></a>
    </div>

    <div class="register-box-body">
        <p class="login-box-msg">برای ثبت نام اطلاعات خود را وارد نمایید</p>

        <form id="registerForm" data-parsley-validate="">
            <div class="form-group has-feedback">
                <input id="firstName" type="text" class="form-control" required="" placeholder="نام">
                <span class="fa fa-user form-control-feedback"></span>
            </div>
            <div class="form-group has-feedback">
                <input id="lastName" type="text" class="form-control" required="" placeholder="نام خانوادگی">
                <span class="fa fa-user form-control-feedback"></span>
            </div>
            <div class="form-group has-feedback">
                <input id="email" type="email" class="form-control" data-parsley-trigger="change" required=""
                       type="email" placeholder="ایمیل">
                <span class="fa fa-envelope form-control-feedback"></span>
            </div>
            <div class="form-group has-feedback">
                <input id="userName" type="text" class="form-control" required="" placeholder="نام کاربری">
                <span class="fa fa-user form-control-feedback"></span>
            </div>
            <div class="form-group has-feedback">
                <input id="password" type="password" class="form-control" required="" placeholder="رمز عبور">
                <span class="fa fa-lock form-control-feedback"></span>
            </div>
            <div class="form-group has-feedback">
                <input id="confirmPassword" type="password" class="form-control" required=""
                       placeholder="تکرار رمز عبور">
                <span class="fa fa-sign-in form-control-feedback"></span>
            </div>
            <div class="form-group">
                <div id="accept-rules" class="checkbox icheckcol-xs-12 pull-right">
                    <label>
                        <input id="ruleCheck" type="checkbox"> <a href="#">شرایط و قوانین</a>
                        <span>استفاده از سرویس های سایت کُتُبز را مطالعه نموده و با کلیه موارد آن موافقم.</span>
                    </label>
                </div>
                <!-- /.col -->
                <div id="register-button" class="col-xs-12">
                    <button type="submit" class="btn btn-primary btn-block btn-flat" onclick="registerUser()">ثبت نام
                    </button>
                </div>
                <!-- /.col -->
            </div>
        </form>


        <span class="col-lg-12">قبلا در کُتُبز ثبت نام کرده اید ؟ <a href="login.jsp">ورود به کُتُبز</a></span><a
            href="login.html" class="text-center"></a>
    </div>
    <!-- /.form-box -->
</div>
<!-- /.register-box -->
</body>


<script type="text/javascript">
    var restUrl = "<c:url value = '/rest/security/user' />";

    $(function () {
        $('input').iCheck({
            checkboxClass: 'icheckbox_square-blue',
            radioClass: 'iradio_square-blue',
            increaseArea: '20%' // optional
        });

        $("#userName").focusout(function () {

            $.getJSON(restUrl + "/front/checkUsername/" + $("#userName").val() , function(res) {
                if(res)
                {
                    swal({
                        title: "کاربری با این نام کاربری وجود دارد",
                        showConfirmButton: true,
                        type: "error"
                    });
                }
            });
        });

    });

    function registerUser() {
        $('#registerForm').parsley().on('form:validate', function () {
            var ruleCheck = $('#ruleCheck').is(':checked');
            if (!ruleCheck) {
                swal({
                    title: "لطفا تیک مربوط به توافق نامه را فعال کنید",
                    showConfirmButton: true,
                    type: "error"
                });
            } else {
                var pass = $('#password').val();
                var confirmPass = $('#confirmPassword').val();
                if (pass.localeCompare(confirmPass) == 0) {
                    var data = {
                        firstName: $('#firstName').val(),
                        lastName: $('#lastName').val(),
                        email: $('#email').val(),
                        userName: $('#userName').val(),
                        passWord: pass
                    };
//            if (!$("#FormEdit").validationEngine('validate'))
//                return;
                    $.ajax({
                        type: "POST",
                        url: restUrl + "/front/register",
                        data: JSON.stringify(data),
                        contentType: "application/json;",
                        dataType: "json",
                        success: function (res) {
                            swal({
                                title: "عملیات  با موفقیت انجام شد",
                                timer: 500,
                                showConfirmButton: false,
                                type: "success"
                            });
                            window.location = "<c:url value ='/View/frontEnd/login.jsp'/>";
                        }
                    });
                } else {
                    swal({
                        title: "عدم تطابق رمز جدید و تکرار رمز",
                        showConfirmButton: true,
                        type: "error"
                    });
                }
            }
        });

    }
</script>
</html>