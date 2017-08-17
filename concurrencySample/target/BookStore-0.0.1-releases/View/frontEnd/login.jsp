<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <%@ include file="/View/ScriptHeader/FrontEndHead.jsp" %>
    <link type="text/css" rel="stylesheet" href="../../NewTheme/css/frontEnd/login/login.css">


    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>صفحه ورود</title>
</head>
<body>
<div class="login-box">
    <div class="login-logo">
        <a href="homePage/Index.jsp"><span> به<b id="site-title"> کُتُبز</b>خوش آمدید</span></a>
    </div>
    <!-- /.login-logo -->
    <div class="login-box-body">
        <p class="login-box-msg">برای ورود به سایت مشخصات خود را وارد کنید</p>

        <form id="loginForm" action="<c:url value='/perform_login' />" method="post">
            <div class="form-group has-feedback">
                <input id="j_username" name="j_username" class="form-control" placeholder="نام کاربری" type="text">
                <span class="fa fa-user form-control-feedback"></span>
            </div>
            <div class="form-group has-feedback">
                <input id="j_password" name="j_password" class="form-control" placeholder="رمز عبور"
                       type="password">
                <span class="fa fa-lock form-control-feedback"></span>
            </div>
            <div class="form-group">
                <div id="remember-me" class="checkbox icheck col-xs-6 pull-right">
                    <label>
                        <div class="icheckbox_square-blue" style="position: relative;" aria-checked="false"
                             aria-disabled="false">
                            <input style="position: absolute; top: -20%; left: -20%; display: block; width: 140%; height: 140%; margin: 0px; padding: 0px; background: rgb(255, 255, 255) none repeat scroll 0% 0%; border: 0px none; opacity: 0;" type="checkbox">
                            <ins class="iCheck-helper" style="position: absolute; top: -20%; left: -20%; display: block; width: 140%; height: 140%; margin: 0px; padding: 0px; background: rgb(255, 255, 255) none repeat scroll 0% 0%; border: 0px none; opacity: 0;"></ins>
                        </div>
                        مرا به خاطر بسپار
                    </label>
                </div>
                <!-- /.col -->
                <div id="login-button" class="col-xs-6 pull-left">
                    <button type="submit" class="btn btn-primary btn-block btn-flat">ورود به سایت</button>
                </div>
                <!-- /.col -->
            </div>
        </form>


        <a href="resetPassword.jsp" class="col-lg-12">رمز خود را فراموش کرده اید ؟</a>
        <a href="register.jsp" class="col-lg-12">ثبت نام در کُتُبز</a>

    </div>
    <!-- /.login-box-body -->
</div>

<!-- /.login-box -->


<script type="text/javascript">
    $(function () {
        $('input').iCheck({
            checkboxClass: 'icheckbox_square-blue',
            radioClass: 'iradio_square-blue',
            increaseArea: '20%' // optional
        });
    });
</script>
</body>
</html>