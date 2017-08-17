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
		var pageSize = 10;
		var pageNo = 1;
		var order = 'e.id desc';
		var resultNum = 0;
		var BaseInformationHeaderId=-1;
		var FirstDataUserBaseInfo='<?xml version="1.0" encoding="utf-8"?><tree id="0">'
				+ '<item  text="اطلاعات پایه" id="-1" open="1" im0="iconText.gif" im1="tombs_open.gif" im2="tombs.gif"   >';
		var XMLDataUserBaseInfo=FirstDataUserBaseInfo;
		var restUrl = "<c:url value = '/rest/security/userBaseInformation' />";
		var userId =<%=request.getParameter("userId")%>;
		var chkUserBaseInfos = [];
		$(function() {
			chkUserBaseInfos=[];
			Loader(true);
			$.get(restUrl + "/getAllChecked/" + userId, function(data) {
				chkUserBaseInfos = data;
			});
			Loader(false);
			setTooltip();
		});
		function init() {
			clearAll();
			initTree();
		}
		function initTree() {
			Loader(true);
			configtreeUserBaseInfo();
			$.ajax({
				type : "GET",
				url : "<c:url value = '/rest/core/baseInformation/getAllTreeNodes' />",
				data : "headersId=28,105,114,260,38,71",	 
				success : function(UserBaseInfoData) {
					XMLDataUserBaseInfo=XMLDataUserBaseInfo+UserBaseInfoData+"</item> </tree>";
		    		treeUserBaseInfo.loadXMLString(XMLDataUserBaseInfo);
		    		setCheckedUserBaseInfoTree();
		    		Loader(false);	
				}
			});
		}
		function clearAll() {
			$('input[type=checkbox]').removeAttr("checked");
		}
		function saveEntity() {
			jsonData = {
				baseInformationList:getAllCheckedUserBaseInfo(),
				userId : userId
			};
			//save checked
			Loader(true);
			$.ajax({
				type : "POST",
				url : restUrl + "/save",
				data : JSON.stringify(jsonData),
				contentType : "application/json;",
				dataType : "json",
				success : function(res) {
					showMessage(" ثبت با موفقیت انجام پذیرفت ");
					Loader(false);
				},
				error : function(e) {
					showMessage(" خطا در ثبت اطلاعات ");
					Loader(false);
				}
			});
		}

		function checkAll(elem) {
			// for checked or unchecked all of list elem
			if ($('#' + elem + 'Container input[type=checkbox]').attr("checked") != "checked")
				$('#' + elem + 'Container input[type=checkbox]').attr("checked", "checked");
			else
				$('#' + elem + 'Container input[type=checkbox]').removeAttr("checked");
		}

		function setTooltip() {
			$('.TooltipCustom').removeData('qtip').qtip({
				position : {
					my : 'top right',
					at : 'left bottom'
				},
				style : {
					classes : 'ui-tooltip-shadow ui-tooltip-bootstrap'
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
			//treeUserBaseInfo.setOnCheckHandler(toncheckUserBaseInfo);
			treeUserBaseInfo.attachEvent('onCheck', function(id, state){
				if(getTreeAttrValueByItemId('access', id ,XMLDataUserBaseInfo) == 'false'){
			    	showMessage('شما به این گره دسترسی ندارید');
			    	treeUserBaseInfo.setCheck(id, 0);
			    	removeFromBaseInformation(id.substring(1));
			    	state = 0;
			    }
		 	});
			
		}
		function findParents(id) {
			if (id > 0) {
				var parentId = tree.getParentId(id);
				parentsText = tree.getItemText(parentId) + "/" + parentsText;
				findParents(parentId);
			}
		}
		function setCheckedUserBaseInfoTree() {
			nodes = treeUserBaseInfo.getAllItemsWithKids();
			nodes = nodes + "," + treeUserBaseInfo.getAllChildless();
			var array = nodes.split(',');
			for ( var i = 0; i < array.length; i++) {
				if (array[i].substring(0, 1) !== 't')
					setCheckNodeIfUserHaveThisTreeUserBaseInfo(array[i]);
			}
		}
		function setCheckNodeIfUserHaveThisTreeUserBaseInfo(id) {
			$.each(chkUserBaseInfos, function(i, entityItem) {
				if (entityItem == id.substring( 1))
					treeUserBaseInfo.setCheck(id, 1);
			});
		}
	
		function  getAllCheckedUserBaseInfo(){
			var checkedList=[];
			nodes = treeUserBaseInfo.getAllChecked();
			var array = nodes.split(',');
			for ( var i = 0; i < array.length; i++) {
				if (array[i].substring(0, 1) == 'b')
					checkedList.push(array[i].substring(1) );
			}
			return checkedList;
		}
		
		//--------------------- END Power section ----------------------------------
	</script>
</head>
<body onload="pageLoad()">
	<form id="FormMain">
		<div dir="rtl">
			<center>
				<div class="search_form" id="search_form1" style="width: 100%; background-color: #f9f9f9;">
						<div style="display: inline-block; width: 99%; padding: 3px;" align="center">
							<div>
								<fieldset style="width: 668px;">
									<legend style="color: blue;">اطلاعات پایه </legend>
									<div id="treeboxUserBaseInfo" style="width:98%; height:320px;background-color:#f5f5f5;border :1px solid Silver; overflow: scroll;"></div>
								</fieldset>
							</div>
							<input id="BtnSaveEntity" type="button" value='<spring:message code="UI.General.Save" />' onclick="saveEntity()" class="actionBtn" />
						</div>
				</div>
			</center>
		</div>
	</form>
</body>
</html>
