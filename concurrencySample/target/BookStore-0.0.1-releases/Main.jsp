<%@page import="org.baharan.framework.common.utility.DateUtility"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

<meta name="description" content="">
<meta name="viewport" content="width=device-width,initial-scale=1">
<%@ include file="/NewTheme/html/Head.jsp"%>
</head>
<body id="minovate" class="appWrapper rtl  ">
	<div id="wrap" class="animsition">
		<%@ include file="/NewTheme/html/Header.jsp"%>
		<div id="controls">
			<%@ include file="/NewTheme/html/Rightbar.jsp"%>
			<%@ include file="/NewTheme/html/Leftbar.jsp"%>
		</div>
		<section id="content">
		<%@ include file="/NewTheme/html/Dashboard.jsp"%>
		<iframe id="mainFrame" width="100%" height="590px" style="border: none;"> </iframe> </section>
	</div>

	<div id="ModalPage" class="modal fade" aria-labelledby="myModalLabel" role="dialog" tabindex="-1" aria-hidden="true">
		<div class="modal-dialog" role="document" style="width: 100%">
			<div class="modal-content" style="margin-right: auto; margin-left: auto;">
				<div class="modal-header " style="direction: rtl; padding: 2px">
					<button class="close pull-left" aria-label="Close" onclick="$('#win_iframe_main').attr('src', null);$('#ModalPage').modal('hide')" style="margin-left: 10px;" type="button">
						<span aria-hidden="true">×</span>
					</button>
					<span class="modal-title"></span>
				</div>
				<div class="modal-body" style="overflow-y: auto;">
					<iframe id="win_iframe_main" frameborder="0" style="zoom: 0.60;" src=""> </iframe>
				</div>
			</div>
		</div>
	</div>
	<script type="text/javascript">
		var token = $("meta[name='_csrf']").attr("content");
		var header = $("meta[name='_csrf_header']").attr("content");
		$.ajaxSetup({
			"beforeSend" : function(xhr) {
				xhr.setRequestHeader(header, token);
			}
		});
		function logoutForm() {
			var theForm = document.forms['frmLogout'];
			theForm.submit();
		}
		$(function() {
		});
	</script>
	<%@ include file="/NewTheme/html/Scripts.jsp"%>
</body>
</html>
