<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8" isELIgnored="true"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "spring" uri = "http://www.springframework.org/tags" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head > 
    <title></title>
    <META http-equiv="Content-Type" content="text/html;charset=UTF-8">
    <%@ include file="/View/ScriptHeader/Head.jsp" %>
     
    <script language="javascript" type="text/javascript">
        var pageSize = 10;
        var pageNo = 0;
        var order = 'e.topic desc';
        var resultNum = 0;
        var restUrl="<c:url value = '/rest/core/baseInformation/baseInformationHeader' />";
		var subSystemType = '<%=request.getParameter("subSystemType")%>';
        $(function(){
            $("#txtBaseInformationHeaderTitle").focus();
        	$('#txtBaseInformationHeaderTitle').keypress(function(event){
            	var keycode = (event.keyCode ? event.keyCode : event.which);
            	if(keycode == '13')
                	fillTable();
            });
            
        });
        function init() {
            fillTable();
        }
        function clearEntity(){
        	$("#txtBaseInformationHeaderTitle").val("");	
            }
        function fillTable() {
            jsonData = {subSystemType:subSystemType,title:$("#txtBaseInformationHeaderTitle").val() ,searchFilter: '', order: order, pageNumber: pageNo, pageSize: pageSize };
        	loadGrid('GridRowTemplate', 'entityBody', restUrl+"/list/grid", jsonData);  
        }
        function rowDoubleClick(id,topic){
        	if('<%=request.getParameter("func")%>' !='null'){
         		 window.parent.<%=request.getParameter("func")%>(id,topic);}
            else
            	window.parent.setBaseInformationHeader(id,topic);
        }
    </script>
</head>
<body onload="pageLoad()">
    <form id="FormMain" >
    	<div>
			<input type="text" id="txtBaseInformationHeaderTitle" class="text" style="width: 370px"/>
			<input type="button" onclick="fillTable()" value="جستجو" />
			<input type="button" onclick="clearEntity()" value="پاک کردن" />
		</div>
		<div class="table_content" id="table_content" style="width:100%">
	        <table width="100%" cellpadding="0" cellspacing="0">
	            <tr>
	                <td align="center" width="100%">
	                    <table class="grid" width="100%" align="center">
	                        <thead>
	                            <tr class="grid_header">
	                                <th nowrap="nowrap">
	                                     ردیف
	                                </th>
	                                <th nowrap="nowrap">
	                                     <spring:message code="UI.BaseInformation.Topic" />
	                                      <a class="orderLink" href="javascript:{orderAsc('e.topic')}"> &#8595;</a>
	                                      <a  class="orderLink" href="javascript:{orderDesc('e.topic')}"> &#8593;</a>
	                                </th>
	                                <th nowrap="nowrap">
	                                     <spring:message code="UI.BaseInformation.SecondTopic" />
	                                      <a class="orderLink" href="javascript:{orderAsc('e.secondTopic')}"> &#8595;</a>
	                                      <a  class="orderLink" href="javascript:{orderDesc('e.secondTopic')}"> &#8593;</a>
	                                </th>
	                            </tr>
	                        </thead>
	                        <tbody id="entityBody">
								<script id="GridRowTemplate" type="text/html">
    										<tr id="pattern${id}"  class="oddRow"
            									onmouseover="highLight(this.id)" 
            									onmouseout="normLight(this.id)" 
            									ondblclick="rowDoubleClick(${id},'${topic}')">
												 <td align="center" width="50px">
													<span class="tmplRowIndex"></span>
												 </td>	
       											 <td align="right" >
            										<span>${topic}</span>
        										 </td>
												 <td align="right" >
            										<span>${secondTopic}</span>
        										 </td>
    										</tr>
										</script>
	                        </tbody>
	                    </table>
	                </td>
	            </tr>
	            <tr>
	                <!--navigation:begin-->
	                <td align="left" style="width: 100%; height: 25px; background: #B9CCEB;">
	                    <table cellpadding="0" cellspacing="0">
	                        <tr>
	                            <td>
	                                <table>
	                                    <tr>
	                                        <td nowrap="nowrap">
	                                            <input type="text" name="pageSize" onblur="pageSize = $('#pageSize').val();init();"
	                                                id="pageSize" value="10" size="1" />
	                                        </td>
	                                        <td>
	                                            <a href="#" onclick="pageSize = $('#pageSize').val();init();returnValue=false;">
	                                                 <img src="<c:url value='/Content/images/refresh.gif' />" /></a>
	                                        </td>
	                                    </tr>
	                                </table>
	                            </td>
	                            <td style="padding-right: 50px;">
	                                <spring:message code="UI.General.ResultNum" /> <span id="resultNum" style="font-weight: bold; color: #f00;">
	                                </span>
	                            </td>
	                            <td style="padding-left: 5px; padding-right: 50px;">
	                                <table>
	                                    <tr>
	                                        <td>
	                                            <spring:message code="UI.General.Page" />
	                                        </td>
	                                        <td>
	                                            <a title="" id="nextIcon" class="noborder" href="#" onclick="nextPage()" align="left">
	                                                <img src="<c:url value='/Content/images/next.gif' />" />
                                                </a>
	                                        </td>
	                                        <td id="navigateNums" nowrap="nowrap" align="left" dir="ltr">
	                                        </td>
	                                        <td>
	                                            <a title="" id="prevIcon" class="noborder" href="#" onclick="prevPage()">
	                                                 <img src="<c:url value='/Content/images/prev.gif' />" />
                                                </a>
	                                        </td>
	                                    </tr>
	                                </table>
	                            </td>
	                        </tr>
	                    </table>
	                </td>
	                <!--navigation:end-->
	            </tr>
	        </table>
		</div>
	</form>
</body>
</html>