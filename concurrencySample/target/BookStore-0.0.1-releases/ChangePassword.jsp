<%@page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<html>
<head>

<title>ForceChanegPassword Page</title>
<META http-equiv="Content-Type" content="text/html;charset=UTF-8">
<%@ include file="/View/ScriptHeader/Head.jsp"%>
<script type="text/javascript">
	var token = $("meta[name='_csrf']").attr("content");
	var header = $("meta[name='_csrf_header']").attr("content");
	$.ajaxSetup({
		"beforeSend" : function(xhr) {
			xhr.setRequestHeader(header, token);
		}
	});
	var restUrl = "<c:url value = '/rest/security/user' />";
	function logoutForm(){
		var theForm = document.forms['frmLogout'];
		theForm.submit();
	}
	function checkStrength(password) {

		//initial strength
		var strength = 0;
		//if the password length is less than 6, return message.
		if (password.length == 0)
			return '';
		if (password.length < 6) {
			$('#result').attr('strongth', 'veryWeak');
			return 'خيلي ضعيف';
		}

		//length is ok, lets continue.
		//if length is 8 characters or more, increase strength value
		if (password.length > 7)
			strength += 1;

		//if password contains both lower and uppercase characters, increase strength value
		if (password.match(/([a-z].*[A-Z])|([A-Z].*[a-z])/))
			strength += 1;

		//if it has numbers and characters, increase strength value
		if (password.match(/([a-zA-Z])/) && password.match(/([0-9])/))
			strength += 1;

		//if it has one special character, increase strength value
		if (password.match(/([!,%,&,@,#,$,^,*,?,_,~])/))
			strength += 1;

		//if it has two special characters, increase strength value
		if (password.match(/(.*[!,%,&,@,#,$,^,*,?,_,~].*[!,%,&,@,#,$,^,*,?,_,~])/))
			strength += 1;

		//now we have calculated strength value, we can return messages
		//if value is less than 2
		if (strength < 2) {
			$('#result').attr('strongth', 'weak');
			return 'ضعيف';
		} else if (strength == 2) {
			$('#result').attr('strongth', 'good');
			return 'متوسط';
		} else {
			$('#result').attr('strongth', 'strong');
			return 'قوي';
		}
	}
	$(function() {
		$("#FormMain").validationEngine('attach');
		$('#txtNewPassWord').keyup(function() {
			$('#result').html(checkStrength($('#txtNewPassWord').val()));
		});
	});

	function saveEntity() {
		if (!$("#FormMain").validationEngine('validate'))
			return;
		if ($("#txtNewPassWord").val() != $("#txtRepeatPassWord").val()) {
			alert('<spring:message code="UI.User.Security.Fancy.pasAndRepeatNotEqual" />');
			return;
		}
		var newPassword = $("#txtNewPassWord").val();
		var oldPassword = $("#txtOldPassWord").val();
		if (newPassword.length < 6) {
			alert('<spring:message code="UI.User.Security.Fancy.MinimumSixCharacter" />');
			return;
		}
		var JsonData = {
			newPassword : newPassword,
			oldPassword : oldPassword
		};
		$.ajax({
			url : restUrl + "/changePassword/" + $("#result").attr("strongth"),
			type : 'POST',
			dataType : 'json',
			contentType : 'application/json; charset=utf-8',
			data : JSON.stringify(JsonData),
			success : function(res) {
				if (res == 1) {
					alert('<spring:message code="UI.User.Security.Fancy.SaveSuccessfull" />');
					logoutForm();
				} else if (res == -1)
					alert('<spring:message code="UI.User.Security.Fancy.NotCorrectPassword" />');
				else if (res == -2)
					alert('<spring:message code="UI.User.Security.Fancy.MinimumPasswordLength" />');
				else if (res == -3)
					alert('<spring:message code="UI.User.Security.Fancy.diffrentWithLastPassword" />');
				else if (res == -4)
					alert('<spring:message code="UI.User.Security.Fancy.NotPermissionPassword" />');
				else if (res == -5)
					alert('<spring:message code="UI.General.NotCorrectStrongPassword" />');
			},
			error : function(msg) {
				alert('<spring:message code="UI.DataEntrySystem.FancyBox.AcssError" />');
				return;
			}
		});
	}
	function load() {
	}
	function clearEntity() {
		$("#txtOldPassWord").val('');
		$("#txtNewPassWord").val('');
		$("#txtRepeatPassWord").val('');
	}
</script>
</head>
<body onload="load();">
	<form id="FormMain">
		<div align="center">
			<br />
			<br />
			<br />
			<br />
			<br />
			<table border="0" cellpadding="0" cellspacing="0" dir="rtl" style="width: 70%;">
				<tr>
					<td style="background: url(Content/Login/P_RightTop.jpg) no-repeat right bottom; width: 20px; height: 13px">&nbsp;</td>
					<td style="background: url(Content/Login/P_RepeatTop.jpg) repeat-x 50% bottom; width: 97%; height: 13px"></td>
					<td style="background: url(Content/Login/P_LeftTop.jpg) no-repeat left bottom; width: 24px; height: 13px">&nbsp;</td>
				</tr>
				<tr>
					<td style="background: url(Content/Login/P_RepeatRight.jpg) repeat-y right 50%; width: 20px; height: 37px">&nbsp;</td>
					<td style="text-align: center; width: 100%">
						<table style="font-size: 12pt; font-family: Times New Roman; width: 100%" dir="rtl">
							<tr>
								<td colspan="6" style="text-align: center;">
									<table>
										<tr>
											<td>
												<table width="344px" border="0" cellspacing="0" cellpadding="0" align="center">
													<tr>
														<td height="74" style="background: url(Content/Login/Up.gif) no-repeat center bottom; width: 363px; text-align: left;">
															<br />
															<br />
															<br />
															<br />
															<br />
														</td>
													</tr>
													<tr>
														<td style="background: url(Content/Login/Middle.gif) repeat-y center; height: 73px; width: 363px; text-align: center">
															<br />
															<br />
															<table align="center">
																<tr>
																	<td style="width: 78px; text-align: left">
																		<span style="font-size: 9pt; font-family: Tahoma">پسورد قبلي :</span>
																	</td>
																	<td style="width: 167px; font-size: 12pt; font-family: Times New Roman;">
																		<input dir="ltr" type='password' id='txtOldPassWord' class=" text validate[required,length[5,20]]">
																	</td>
																	<td style="width: 18px; font-size: 12pt; font-family: Times New Roman;"></td>
																</tr>
																<tr style="font-size: 12pt; color: #000000; font-family: Times New Roman">
																	<td style="width: 78px; text-align: left">
																		<span style="font-size: 9pt; font-family: Tahoma">پسورد جديد :</span>
																	</td>
																	<td style="width: 167px">
																		<input dir="ltr" type='password' id='txtNewPassWord' class=" text validate[required,length[5,20]]" />
																	</td>
																	<td style="width: 18px"></td>
																</tr>
																<tr style="font-size: 12pt; color: #000000; font-family: Times New Roman">
																	<td style="width: 78px; text-align: left">
																		<span style="font-size: 9pt; font-family: Tahoma"> تکرار پسورد :</span>
																	</td>
																	<td style="width: 167px">
																		<input dir="ltr" type='password' id='txtRepeatPassWord' class=" text validate[required,length[5,20]]" />
																	</td>
																	<td style="width: 18px"></td>
																</tr>
																<tr style="font-size: 12pt; font-family: Times New Roman">
																	<td style="width: 78px"></td>
																	<td style="width: 167px"></td>
																	<td style="width: 18px"></td>
																</tr>
																<tr style="font-size: 12pt; font-family: Times New Roman">
																	<td style="width: 78px"></td>
																	<td style="width: 167px; text-align: center;">
																		<input type="button" value="اعمال تغيير" onclick="saveEntity()" style="font-size: 9pt; font-family: tahoma" />
																		<input type="button" value="انصراف" onclick="logoutForm()" style="font-size: 9pt; font-family: tahoma" />
																		
																		<span id="result" style="color: red;"></span>
																	</td>
																	<td style="width: 18px"></td>
																</tr>
																<tr style="font-size: 12pt; font-family: Times New Roman">
																	<td style="width: 78px"></td>
																	<td style="width: 167px"></td>
																	<td style="width: 18px"></td>
																</tr>
																<tr style="font-size: 12pt; font-family: Times New Roman">
																	<td colspan="3" style="text-align: right">
																		<br />
																	</td>
																</tr>
															</table>
														</td>
													</tr>
													<tr>
														<td style="background: url(Content/Login/Down.gif) no-repeat center top; width: 363px; height: 23px;"></td>
													</tr>
												</table>
											</td>
											<td>
												<table>
													<tr>
														<td width="80%">
															<ul style="margin: 0px 5px 5px 0;">
																<li style="margin-bottom: 0.5em;">
																	<span style="font-family: Tahoma; font-size: 10pt">کاربر محترم شما به سامانه يکپارچه و جامع وارد شده ايد.</span>
																</li>
																<li style="margin-bottom: 0.5em;">
																	<span style="font-family: Tahoma; font-size: 10pt"> سيستم متعهد به رعايت حقوق شخصي کاربران است.</span>
																</li>
																<li style="margin-bottom: 0.5em;">
																	<span style="font-family: Tahoma; font-size: 10pt"> طبقه بندي داده هايي که برنامه کاربردي به آن دسترسي دارد،براساس حساس ترين داده هاي مورد دستيابي است.</span>
																</li>
																<li style="margin-bottom: 0.5em;">
																	<span style="font-family: Tahoma; font-size: 10pt">اعلان ردگيري و بازبيني فعاليت هاي کاربر وجود دارد.</span>
																</li>
																<li style="margin-bottom: 0.5em;">
																	<span style="font-family: Tahoma; font-size: 10pt">مسئوليت کاربر در قبال اطلاعات حساس مورد دستيابي است.</span>
																</li>
															</ul>
														</td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>
					<td style="background: url(Content/Login/P_RepeatLeft.jpg) repeat-y left 50%; width: 24px; height: 37px">&nbsp;</td>
				</tr>
				<tr>
					<td style="background: url(Content/Login/P_RightBtm.jpg) no-repeat right top; width: 20px">&nbsp;</td>
					<td style="background: url(Content/Login/P_RepeatBtm.jpg) repeat-x; width: 97%; height: 37px">&nbsp;</td>
					<td style="background: url(Content/Login/P_LeftBtm.jpg) no-repeat left top; width: 24px">&nbsp;</td>
				</tr>
			</table>
		</div>
	</form>
	<c:url var="logoutUrl" value="j_spring_security_logout"/>
	<form action="${logoutUrl}" method="post" name='frmLogout' >
	  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
	</form>
</body>
</html>