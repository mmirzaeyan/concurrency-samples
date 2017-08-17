<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">


<%@ taglib prefix="codePlus" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <%@ include file="/View/ScriptHeader/AdminFrameHead.jsp" %>
    <%@ include file="/View/ScriptHeader/FrontEndHead.jsp" %>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

    <script language="javascript" type="text/javascript">
        var restUrlUser = "<c:url value = '/rest/security/user' />";

        $(function () {
            fillUserDetail();
        });

        function fillUserDetail() {
            userEntity = getAuthenticatedUser();
            $('#userFirstName').val(userEntity.firstName);
            $('#userLastName').val(userEntity.lastName);
//            $('#userNationalCode').attr('value' ,user );
            $('#userEmail').val(userEntity.email);
//            $('#userPhone').attr('value' ,user );
//            $('#userMobile').attr('value' ,user );
//            $('#userLocation').attr('value' ,user );
        }

        function updateUserDetail() {
            var data = {
                id: user.id,
                firstName: $('#userFirstName').val(),
                lastName: $('#userLastName').val(),
                email: $('#userEmail').val()
            };

            $.ajax({
                type: "POST",
                url: restUrlUser + "/updateProfile",
                data: JSON.stringify(data),
                contentType: "application/json;",
                dataType: "json",
                success: function (res) {
                    swal({
                        title: "عملیات  با موفقیت انجام شد",
                        timer: 1500,
                        showConfirmButton: false,
                        type: "success"
                    });

                    $("#closeModal").click();
                }
            });
        }

    </script>
    <style type="text/css">
        .form-group * {
            float: right;
        }

        #userProfileDetails label {
            text-align: left;
            color: #747373;
        }
    </style>
</head>
<body>

<div class="modal-header">
    <button type="button" id="closeModal" class="close" data-dismiss="modal" aria-label="Close">
        <span aria-hidden="true">×</span></button>
    <h4 class="modal-title">ویرایش اطلاعات حساب کاربری</h4>
</div>
<div class="modal-body">
    <form id="editProfileForm" class="form-horizontal">
        <div class="box-body" id="userProfileDetails">
            <div class="form-group">
                <label for="userFirstName" class="col-sm-3 control-label">نام</label>

                <div class="col-sm-9">
                    <input class="form-control" id="userFirstName" placeholder="نام" type="text">
                </div>
            </div>
            <div class="form-group">
                <label for="userLastName" class="col-sm-3 control-label">نام خانوادگی</label>

                <div class="col-sm-9">
                    <input class="form-control" id="userLastName" placeholder="نام خانوادگی" type="text">
                </div>
            </div>
            <div class="form-group">
                <label for="userLastName" class="col-sm-3 control-label">کد ملی </label>

                <div class="col-sm-9">
                    <input class="form-control" id="userNationalCode" placeholder="کد ملی" type="text">
                </div>
            </div>
            <div class="form-group">
                <label for="userPhone" class="col-sm-3 control-label">پست الکترونیکی</label>

                <div class="col-sm-9">
                    <input class="form-control" id="userEmail" placeholder="پست الکترونیکی" type="text">
                </div>
            </div>
            <div class="form-group">
                <label for="userPhone" class="col-sm-3 control-label">شماره تلفن ثابت</label>

                <div class="col-sm-9">
                    <input class="form-control" id="userPhone" placeholder="تلفن ثابت" type="text">
                </div>
            </div>
            <div class="form-group">
                <label for="userMobile" class="col-sm-3 control-label">شماره تلفن همراه</label>

                <div class="col-sm-9">
                    <input class="form-control" id="userMobile" placeholder="تلفن همراه" type="text">
                </div>
            </div>
            <div class="form-group">
                <label for="userLocation" class="col-sm-3 control-label">آدرس محل سکونت</label>
                <div class="col-md-9">
                        <textarea class="form-control" id="userLocation" rows="3"
                                  placeholder="تهران ، خیابان ..."></textarea>
                </div>
            </div>
        </div>
    </form>
</div>
<div class="modal-footer">
    <button type="button" class="btn btn-default pull-left" data-dismiss="modal">انصراف</button>
    <button type="button" class="btn btn-primary pull-left" onclick="updateUserDetail()">به روز رسانی</button>
</div>
</body>
</html>
