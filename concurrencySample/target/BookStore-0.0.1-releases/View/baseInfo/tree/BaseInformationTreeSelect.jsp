<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="baharan" tagdir="/WEB-INF/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
<%@ include file="/View/ScriptHeader/Head.jsp"%>
<%@ include file="/View/ScriptHeader/TreeHead.jsp"%>

<script type="text/javascript">
	var restUrl = "<c:url value = '/rest/core/baseInformation' />";

	var tree;
	var treeRootId ='<%=request.getParameter("headerId")%>';
	var subSystemType = '<%=request.getParameter("subSystemType")%>' ;
	var imagePath = "<c:url value='/Scripts/MyJQuery/dhtmlxTree/imgs_rtl/' />";
	var superRootNode = {
		id : 0,
		text : 'tree super root node',
		item : []
	};
	
	 $(function() {
		configTree();
		$.getJSON(restUrl + "/getJsonHeader/" +subSystemType + "/" + treeRootId + "/false", function(dataSource) { 
			superRootNode.item.push(dataSource);
			tree.loadJSONObject(superRootNode);
		});
		$("#txtSearchTree").autocomplete({
			source : function(request, resp) {
				jsonReq = {
					searchTopic : request.term,
					resultCount : 10,
					isNeedMaster :true
				};
				$.getJSON(restUrl+"/autoComplete/"+treeRootId, jsonReq, function(data) { 
	               	resp( $.map( data, function( baseInfoViewModel ) {
						return {
								  label: baseInfoViewModel.topic,
								  value: baseInfoViewModel.id
								};
						}));
		         }); 
			},
			select : function(event, ui) {
				setAfterSearch(ui.item.value);
				$(event.target).val(ui.item.label);
				return false;
			},
			minLength : 3
		});
	}); 

	function configTree() {
		tree = new dhtmlXTreeObject('treebox', '100%', '100%', 0);
		tree.setImagePath(imagePath);
		tree.setXMLAutoLoading(restUrl + "/getJsonHeader/" + subSystemType + "/-1/false");
		tree.setDataMode("json");

		tree.attachEvent("onXLS", function() {
			Loader(true);
		});
		tree.attachEvent("onXLE", function() {
			Loader(false);
		});
		tree.attachEvent("onDblClick", function() {
			treeOnDoubleClick(tree.getSelectedItemId());
		});
	}
	
	function setAfterSearch(itemId) {
		$.getJSON(restUrl + "/getJsonHeader/" +subSystemType + "/" + treeRootId + "/true" + "?id="+ itemId, function(dataSource) {
			superRootNode.item = [];
			tree.deleteChildItems(0);
			superRootNode.item.push(dataSource);
			tree.loadJSONObject(superRootNode);
			tree.selectItem(itemId);
			tree.focusItem(itemId);
		});
	}
	
	function treeOnDoubleClick(itemId){
		if(itemId == treeRootId){
			showMessage(" این آیتم امکان انتخاب ندارد ");
			return;
		}
		$.getJSON(restUrl+"/load/"+itemId, function (BaseInformationEntity) {
			if('<%=request.getParameter("func")%>' != 'null')
              	window.parent.<%=request.getParameter("func")%>(BaseInformationEntity);
			else
           		window.parent.setBaseInfo(BaseInformationEntity);
		}); 
	}

</script>
</head>
<body dir="rtl">
	<div>
		<spring:message code="UI.General.Search" />
		<input type="text" id="txtSearchTree" style="direction: rtl; width: 78%;" class="text" maxlength="30" />
		<input type="button" id="clear" style="width: 70px;" onclick="$('#txtSearchTree').val('');" value='<spring:message code="UI.General.Clear"/>' />
	</div>
	<fieldset id="categoryContainer" style="height: 400px;">
		<legend style="font-size: 12px;">
			<!-- change -->
		</legend>
		<div id="treebox" style="width: 100%; height: 100%; background-color: #f5f5f5; border: 1px solid Silver; overflow: scroll; margin-top: 2px;"></div>
	</fieldset>
</body>
</html>