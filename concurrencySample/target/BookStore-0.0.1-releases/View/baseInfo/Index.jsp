<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "spring" uri = "http://www.springframework.org/tags" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head > 
    <title></title>
    <META http-equiv="Content-Type" content="text/html;charset=UTF-8">
    <%@ include file="/View/ScriptHeader/Head.jsp" %>
    <%@ include file="/View/ScriptHeader/FancyDialog.jsp"%>
    <%@ include file="/View/ScriptHeader/baharanJqueryUi.jsp"%>
     
    <script language="javascript" type="text/javascript">
    	var subSystemType = '<%=request.getParameter("subSystemType")%>' !="null" ? '<%=request.getParameter("subSystemType")%>' : "common" ;
		$(function(){
				showTreeView();
			});
		function showGridView(){
			$("#iframeBaseInformation").attr("src","grid/Index.jsp?subSystemType="+subSystemType);
			$("#treeViewLabel").css("color","silver");
			$("#gridViewLabel").css("color","green");
			$("#treeViewLabel").css("box-shadow"," 0 0 6px 1px");
			$("#treeViewLabel").css("box-shadow","");
			}
		function showTreeView(){
			$("#iframeBaseInformation").attr("src","tree/BaseInformationTree.jsp?subSystemType="+subSystemType);
			$("#gridViewLabel").css("color","silver");
			$("#treeViewLabel").css("color","green");
			$("#treeViewLabel").css("box-shadow"," 0 0 6px 1px");
			$("#treeViewLabel").css("box-shadow","");
			}
	</script>
</head>
	<body>
		<div id="chooseViewTypeDIV" align="right" style="padding-top: 2px">
<!-- 			<span style="cursor: pointer;color: green;padding-right: 6px" id="treeViewLabel" onclick="showTreeView();" >   نمایش درختی </span>&nbsp; -->
<!-- 			<span style="cursor: pointer;color: green"  id="gridViewLabel" onclick="showGridView();" >نمایش جدولی </span> -->
		</div>
		<div style="padding-top: 2px">
			<iframe id="iframeBaseInformation" width="100%" height="520px" frameborder="0"  />
		</div>
</body>
</html>

