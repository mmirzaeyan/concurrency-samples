<%@page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script>
if ($.fn.fillCombo){
    $.fn.fillCombo.defaults.baseInformationRestUrl = "<c:url value='/rest/core/baseInformation/list/' />";
}
</script>
