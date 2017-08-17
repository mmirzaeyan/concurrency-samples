<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"  %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix ="baharan" tagdir="/WEB-INF/tags"  %>


<%-- <link rel="stylesheet" type="text/css" href="<c:url value = '/Content/Styles/generic.css'/>" /> --%>
<link rel="stylesheet" type="text/css" href="<c:url value = '/Content/PersianCalendar/calendar.css'/>" />
<link rel="stylesheet" type="text/css" href="<c:url value='/Content/Styles/dialog.css' />"  />



<!-- NEW -->
	<link rel="stylesheet" href="<c:url value="/NewTheme/css/vendor/bootstrap.min.css"/>">
	<link rel="stylesheet" href="<c:url value="/NewTheme/css/vendor/animate.css"/>">
	<link rel="stylesheet" href="<c:url value="/NewTheme/css/vendor/font-awesome.min.css"/>">
	<link rel="stylesheet" href="<c:url value="/NewTheme/css/vendor/weather-icons.min.css"/>">
	<link rel="stylesheet" href="<c:url value="/NewTheme/js/vendor/animsition/css/animsition.min.css"/>">
	<link rel="stylesheet" href="<c:url value="/NewTheme/js/vendor/toastr/toastr.min.css"/>">
	<link rel="stylesheet" href="<c:url value="/NewTheme/js/vendor/chosen/chosen.css"/>">
	<!-- project main css files -->
	<link rel="stylesheet" href="<c:url value="/NewTheme/css/main.css"/>">
	<link rel="stylesheet" href="<c:url value="/NewTheme/css/custom.css"/>">
	<!--/ stylesheets -->

<script type="text/javascript" src="<c:url value = '/Scripts/jquery-1.7.1.min.js'/>"></script>
<script type="text/javascript" src="<c:url value = '/Scripts/MyJQuery/Template/jquery.tmpl.js'/>"></script>

<script type="text/javascript" src="<c:url value = '/Scripts/AppJs/FarsiType.js'/>"> </script>

<script type="text/javascript" src="<c:url value = '/Scripts/AppJs/core.configuration.js.jsp'/>"> </script>
<script type="text/javascript" src="<c:url value = '/Scripts/AppJs/core/arrayUtility.js'/>"> </script>
<script type="text/javascript" src="<c:url value = '/Scripts/AppJs/core/baharanConfirm.js'/>"> </script>
<script type="text/javascript" src="<c:url value = '/Scripts/AppJs/core/calendarUtility.js'/>"> </script>
<script type="text/javascript" src="<c:url value = '/Scripts/AppJs/core/comboUtility.js'/>"> </script>
<script type="text/javascript" src="<c:url value = '/Scripts/AppJs/core/errorConfig.js'/>"> </script>
<script type="text/javascript" src="<c:url value = '/Scripts/AppJs/core/formUtility.js'/>"> </script>
<script type="text/javascript" src="<c:url value = '/Scripts/AppJs/core/gridUtility.js'/>"> </script>
<script type="text/javascript" src="<c:url value = '/Scripts/AppJs/core/keyUtility.js'/>"> </script>
<script type="text/javascript" src="<c:url value = '/Scripts/AppJs/core/tooltipUtility.js'/>"> </script>
<script type="text/javascript" src="<c:url value = '/Scripts/AppJs/core/generalUtility.js'/>"> </script>
<script type="text/javascript" src="<c:url value = '/Scripts/AppJs/core/floatingHeaderUtility.js'/>"> </script>


<script type="text/javascript" src="<c:url value = '/Scripts/MyJQuery/jquery.loadmask.js'/>"> </script>
<script type="text/javascript" src="<c:url value = '/Scripts/AppJs/PersianCalendar.js'/>"> </script>

<script type="text/javascript" src="<c:url value = '/Scripts/Validator/jquery.validationEngine.js'/>"> </script>
<script type="text/javascript" src="<c:url value = '/Scripts/Validator/jquery.validationEngine-en.js'/>"> </script>
<link rel="stylesheet" type="text/css" href="<c:url value = '/Scripts/Validator/validationEngine.jquery.css'/>" />
<script type="text/javascript" src="<c:url value = '/Scripts/money-separator.js'/>"> </script>


<!-- JqueryUi -->
<script type="text/javascript" src="<c:url value = '/Scripts/MyJQuery/baharanJqueryUi/jquery-ui-1.10.4.min.js'/>"> </script>
<link rel="stylesheet" type="text/css" href="<c:url value = '/Scripts/MyJQuery/baharanJqueryUi/jquery-ui-1.10.4.custom.css'/>" />
<link rel="stylesheet" type="text/css" href="<c:url value = '/Scripts/MyJQuery/baharanJqueryUi/jquery-ui-baharan.css'/>" />




<!-- DateHead  -->
<link rel="stylesheet" type="text/css" href="<c:url value = '/Scripts/MyJQuery/PersiaCalender/CalenderCss.css'/>" />
<script type="text/javascript" src="<c:url value = '/Scripts/MyJQuery/PersiaCalender/calendar.js'/>"> </script>
<script type="text/javascript" src="<c:url value = '/Scripts/MyJQuery/PersiaCalender/calendar.all.js'/>"> </script>
<script type="text/javascript" src="<c:url value = '/Scripts/MyJQuery/PersiaCalender/jquery.ui.datepicker-cc.js'/>"> </script>
<script type="text/javascript" src="<c:url value = '/Scripts/MyJQuery/PersiaCalender/jquery.ui.datepicker-cc-ar.js'/>"> </script>
<script type="text/javascript" src="<c:url value = '/Scripts/MyJQuery/PersiaCalender/jquery.ui.datepicker-cc-fa.js'/>"> </script>


<!-- BaharanUi -->
<script type="text/javascript" src="<c:url value = '/Scripts/AppJs/baharanUI/easyloader.js'/>"></script>
<script type="text/javascript" src="<c:url value = '/Scripts/AppJs/baharanUI/jquery.parser.js'/>"></script>
<!-- DateHead  -->


<%-- <link rel="stylesheet" type="text/css" href="<c:url value = '/Content/Styles/genericCustom.css'/>" /> --%>

<!-- Plugins -->
<script type="text/javascript" src="<c:url value = '/Scripts/AppJs/baharanUI/baharan.grid.js'/>"></script>
<script type="text/javascript" src="<c:url value = '/Scripts/AppJs/baharanUI/baharan.form.js'/>"></script>
<script type="text/javascript" src="<c:url value = '/Scripts/AppJs/baharanUI/baharan.zoom.js'/>"></script>
<script type="text/javascript" src="<c:url value = '/Scripts/AppJs/baharanUI/baharan.fillCombo.js'/>"></script>
<script type="text/javascript" src="<c:url value = '/Scripts/AppJs/baharanUI/baharan.comboSeries.js'/>"></script>
<script type="text/javascript" src="<c:url value = '/Scripts/AppJs/baharanUI/baharan.autoComplete.js'/>"></script>
<script type="text/javascript" src="<c:url value = '/Scripts/AppJs/baharanUI/baharan.configuration.js.jsp'/>"></script>



