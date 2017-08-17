<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="baharan" tagdir="/WEB-INF/tags"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<META http-equiv="Content-Type" content="text/html;charset=UTF-8">
<%@ include file="/View/ScriptHeader/Head.jsp"%>
<%@ include file="/View/ScriptHeader/FancyDialog.jsp"%>
<%@ include file="/View/ScriptHeader/baharanJqueryUi.jsp"%>
<%@ include file="/View/ScriptHeader/Tooltip.jsp"%>
<script language="javascript" type="text/javascript">
	var parentId = <%=request.getParameter("headerId")%> ;
	var restUrl = '<c:url value = "/rest/core/baseInformation" />';
	$(function() {
	});
	function init() {
	}
	function closeFancybox(message){
		$("#grid").grid("fillTable");
		$.fancybox.close();
	}
	function showCurrent(id) {
		$.getJSON(restUrl+"/loadBaseInfoViewModel/"+id, function (entity) {
    		if('<%=request.getParameter("func")%>' !='null')
          		window.parent.<%=request.getParameter("func")%>(entity);
         	else
           		window.parent.setBaseInfo(entity);
    	});
  }
</script>
</head>
<body onload="pageLoad()">
	<form id="FormMain">
		<span id="confirm"></span>
		<div class="table_content" id="table_content" style="width: 100%">
			<fieldset>
				<table width="100%" cellpadding="2px" id="searchBox">
					<tr style="">
						<td align="left" width="200px;">
							<spring:message code="UI.BaseInformation.Topic" />
							&nbsp;:
						</td>
						<td align="right" >
							<input type="text" id="txtTopic" data-search="topic" style="width: 90%" class="text searchs" />
						</td>
						<td align="left">وضعیت :</td>
						<td align="right">
							<select id="cmbStatus" data-search="status" style="width: 205px">
								<option value="-1" selected="selected">جستجو در همه رکوردها</option>
								<option value="0">جستجو فقط در رکوردهای غیرفعال</option>
								<option value="1">جستجو فقط در رکوردهای فعال</option>
							</select>
						</td>
						<td>
							<input type="button" value="<spring:message code="UI.General.Search" />"  class="search actionBtn" />
							<input type="button"  value="<spring:message code="UI.General.Clear" />" class="clear actionBtn" />
						</td>
					</tr>
				</table>
			</fieldset>

			<!--  *********** -->
			<!--  RESULT GRID -->
			<!--  *********** -->
			<table width="100%" cellpadding="0">
				<tr>
					<td align="center" width="100%">
						<table id="grid" class="grid" data-component="grid"
							data-options="url:'<c:url value = '/rest/core/baseInformation/list/searchGrid?masterInformationId=-1&parentId=' />'+parentId,createSearchOptions: true" width="100%" align="center"
						>
							<!--  Grid Header -->
							<thead>
								<tr class="grid_header">
									<th nowrap="nowrap">
										&nbsp;
										<spring:message code="UI.General.Select" />
									</th>
									<th nowrap="nowrap" style="width: 10px;">
										&nbsp;
										<spring:message code="UI.General.Row" />
									</th>
									<th nowrap="nowrap">
										&nbsp;
										<spring:message code="UI.BaseInformation.Topic" />
										<a class="orderLink" order="e.topic " type="asc"> &#8595;</a>
										<a class="orderLink" order="e.topic " type="desc"> &#8593;</a>
									</th>
									<th nowrap="nowrap">
										&nbsp;
										<spring:message code="UI.BaseInformation.SecondTopic" />
										<a class="orderLink" order="e.secondTopic" type="asc"> &#8595;</a>
										<a class="orderLink" order="e.secondTopic" type="desc"> &#8593;</a>
									</th>
									<th>
										<spring:message code="UI.BaseInformation.description" />
									</th>
									<th>وضعیت</th>
								</tr>
							</thead>

							<!--  Grid Row JQuery Template -->

							<tbody id="entityBody" class="entityBody">
								<script id="GridRowTemplate" type="text/html">
                            <tr id="pattern${id}"  class="oddRow"
                                    onclick="$('#selectedItemId'+${id}).attr('checked','checked');"
                                    onmouseover="highLight(this.id)"
                                    onmouseout="normLight(this.id)"
									ondblclick="showCurrent(${id})"
								>
                                <td align="center" width="30px">
                                    <span><input type="radio" name="selectedItem" id="selectedItemId${id}" /></span>
                                </td>
								<td align="center">
                                     <span class="tmplRowIndex"></span>
                                </td>
								<td align="center" >
            						<span>${topic}</span>
        						</td>
								<td align="center" >
            						<span>${secondTopic}</span>
        						</td>
								<td align="right" >
									${description}
								</td>
								<td align="center"  width="30px">
									{{if active==true}}
										<span style="color:green" >
											فعال
										</span>
									{{else}}
										<span style="color:red" >
											غیرفعال
										</span>
									{{/if}}
								</td>
                            </tr>
						</script>
							</tbody>
						</table>
					</td>
				</tr>
				<tr>
					<!--navigation:begin-->
					<td align="left" width="100%">
						<baharan:PluginDataGridPaging gridId="grid" pageSize="10" />
					</td>
					<!--navigation:end-->
				</tr>
			</table>
		</div>
	</form>
</body>
</html>