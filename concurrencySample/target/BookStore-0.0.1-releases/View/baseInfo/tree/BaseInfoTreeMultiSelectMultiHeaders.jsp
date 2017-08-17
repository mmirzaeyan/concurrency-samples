<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<META http-equiv="Content-Type" content="text/html;charset=UTF-8">
	<%@ include file="/View/ScriptHeader/Head.jsp"%>
	<%@ include file="/View/ScriptHeader/TreeHead.jsp"%>
	<%@ include file="/View/ScriptHeader/Tooltip.jsp"%>
	<script language="javascript" type="text/javascript">
		var FirstData = '<?xml version="1.0" encoding="utf-8"?><tree id="0">';
		var XMLData = FirstData;
		var FirstDataUserBaseInfo='<?xml version="1.0" encoding="utf-8"?><tree id="0">'
								+ '<item  text="اطلاعات پایه" id="-1" open="1" im0="iconText.gif" im1="tombs_open.gif" im2="tombs.gif"   >';
		var XMLDataUserBaseInfo=FirstDataUserBaseInfo;
		var restUrl = "<c:url value = '/rest/core/authorization' />";
		var headersId = '<%=request.getParameter("headersId")%>' ;
		$(function() {
			
		});
		function init() {
			initTree();
		}
		function initTree() {
			Loader(true);
			configtreeUserBaseInfo();
			$.ajax({
				type : "GET",
				url : "<c:url value = '/rest/core/baseInformation/getlistAllHeadersTreeNodes/"+headersId+"' />",
				success : function(UserBaseInfoData) {
					XMLDataUserBaseInfo=XMLDataUserBaseInfo+UserBaseInfoData+"</item> </tree>";
		    		treeUserBaseInfo.loadXMLString(XMLDataUserBaseInfo);
		    		Loader(false);	
				}
			});
		}
		function configtreeUserBaseInfo() {
			treeUserBaseInfo = new dhtmlXTreeObject("treeboxUserBaseInfo", "100%", "100%", 0);
	 		treeUserBaseInfo.setSkin('dhx_skyblue');
			treeUserBaseInfo.setImagePath("<c:url value = '/Scripts/MyJQuery/dhtmlxTree/imgs_rtl/' />");
			treeUserBaseInfo.enableHighlighting(true);
			treeUserBaseInfo.enableThreeStateCheckboxes(true);
			treeUserBaseInfo.enableCheckBoxes(1);
		}
		
		function  getAllCheckedUserBaseInfo(){
			var checkedList=[];
			nodes = treeUserBaseInfo.getAllChecked();
			var array = nodes.split(',');
			for ( var i = 0; i < array.length; i++) {
				if (array[i].substring(0, 1) == 'b')
					checkedList.push({id:array[i].substring(1),topic:treeUserBaseInfo.getItemText(array[i])} );
			}
			return checkedList;
		}
		
		function selectList(){
			var selectedArray=getAllCheckedUserBaseInfo();
			if(selectedArray.length == 0){
				showMessage('موردی انتخاب نشده است.');
				return ;
			}else{
			   if('<%=request.getParameter("func")%>' !='null'){
					window.parent.<%=request.getParameter("func")%>(selectedArray);
			   }
			   else{
					window.parent.setBaseInformationList(selectedArray);
				}
			}
			
    	}
	</script>
</head>
<body onload="pageLoad()">
	<form id="FormMain" >
		<span id="confirm"></span>
		<fieldset dir="rtl" style="margin: 10px;">
		<legend style="font-size: 12px;">لطفا برای انتخاب، بروی آیتم مورد نظر دوبار کلیک کنید</legend>
	    	<table style="width:100%;height:100%;" dir="rtl">
<!-- 	    		<tr> -->
<!-- 			    	<td align="right" style="padding-right: 10px"> -->
<!-- 			    		عنوان: -->
<!-- 			    		<input type="text" id="txtSearchTree" style="direction:rtl;width:42%;" maxlength="20" class="text ui-autocomplete-input" autocomplete="off" role="textbox" aria-autocomplete="list" aria-haspopup="true"/> -->
<%-- 				    	<input type="button" id="search" style="width: 70px;" onclick="searchBaseInformation()" value='<spring:message code="UI.General.Search"/>'/> --%>
<%-- 				    	<input type="button" id="clear" style="width: 70px;" onclick="clearAllFilters()" value='<spring:message code="UI.General.Clear"/>'/> --%>
<!-- 			    	</td> -->
<!-- 			    </tr> -->
			    <tr>
			    	<td align="center">
			    		<div id="treeboxUserBaseInfo" style="width:98%; height:487px;background-color:#f5f5f5;border :1px solid Silver;overflow:scroll;" ></div>
			    	</td>
			    </tr>
				<tr>
					<td align="right">
						<input type="button" value='<spring:message code="UI.General.Select"  />' onclick="selectList()" class="actionBtn" />	
					</td>
				</tr>
	    	</table>
    	</fieldset>
	</form>
</body>
</html>
