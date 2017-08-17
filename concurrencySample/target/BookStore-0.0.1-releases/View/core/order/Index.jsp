<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8" isELIgnored="true"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib prefix="sec"	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="codePlus" tagdir="/WEB-INF/tags"%>
<html xmlns="http://www.w3.org/1999/xhtml" lass="no-js" lang="">
<html>
<head>
<title></title>
<META http-equiv="Content-Type" content="text/html;charset=UTF-8">
    <%@ include file="/View/ScriptHeader/Head.jsp" %>
    <%@ include file="/View/ScriptHeader/FancyDialog.jsp"%>
    <%@ include file="/View/ScriptHeader/baharanJqueryUi.jsp"%>
    <%@ include file="/View/ScriptHeader/Tooltip.jsp"%>
	<script language="javascript" type="text/javascript">
    	var isFirstShow = true;
		var entitiesCache = {};
        var pageSize = 5;
        var pageNo = 0;
        var order = 'e.id asc';
        var resultNum = 0;
        var restUrl = "<c:url value = '/rest/order/order' />";
        
		$(function(){
			fillTable();
	    });
		//it works same as ready in jquery
        function init() {
			
		}
		
		function fillTable() {
			jsonData = {
				order : order,
				pageNumber : pageNo,
				pageSize : pageSize
			};
			loadGrid('GridRowTemplate', 'entityBody', restUrl + "/list/grid",jsonData);
		}
        
        
    </script>
</head>
<body>
	<span id="confirm"></span>
    <form id="FormMain" >
	    <div dir="rtl">
				<%@ include file="Grid.jsp" %>
		</div>
	</form>
</body>
</html>