<%@ tag language="java" pageEncoding="UTF-8"   %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="pageSize" required="true" rtexprvalue="true"  %>
<!-- <table style="border-top: 2px dotted #dbe0e2;"> -->
<!-- 	<tr> -->
<!-- 		<td> -->
<!-- 			<table cellspacing="0" cellpadding="0" > -->
<!-- 				<tbody> -->
<!-- 					<tr> -->
<!-- 						<td> -->
<!-- 							<table> -->
<!-- 								<tbody> -->
<!-- 									<tr> -->
<!-- 										<td nowrap="nowrap"> -->
<%-- 											<input type="text" size="1" value="${pageSize}" id="pageSize" onblur="pageSize = $('#pageSize').val();init();" name="pageSize"> --%>
<!-- 										</td> -->
<!-- 										<td> -->
<!-- 											<a onclick="pageSize = $('#pageSize').val();init();returnValue=false;" href="#"> -->
<%-- 											<img src="<c:url value = '/Content/images/refresh.gif' />" /></a> --%>
<!-- 										</td> -->
<!-- 									</tr> -->
<!-- 								</tbody> -->
<!-- 							</table> -->
<!-- 						</td> -->
<!-- 						<td style="padding-right: 50px;"> -->
<!-- 							تعداد نتیجه <span style="font-weight: bold; color: #f00;" id="resultNum">0</span> -->
<!-- 						</td> -->
<!-- 						<td style="padding-left: 5px; padding-right: 50px;"> -->
<!-- 							<table> -->
<!-- 								<tbody> -->
<!-- 									<tr> -->
<!-- 										<td> -->
<!-- 											صفحه -->
<!-- 										</td> -->
<!-- 										<td> -->
<!-- 											<a align="left" onclick="nextPage()" href="#" class="noborder" id="nextIcon" title="" style="display: none;"> -->
<%-- 											<img src="<c:url value = '/Content/images/next.gif' />" /></a> --%>
<!-- 										</td> -->
<!-- 										<td nowrap="nowrap" align="left" dir="ltr" id="navigateNums"><font size="2" face="tahoma" color="red"><b>1</b>&nbsp;</font></td> -->
<!-- 										<td> -->
<!-- 											<a onclick="prevPage()" href="#" class="noborder" id="prevIcon" title="" style="display: none;"> -->
<%-- 											<img src="<c:url value = '/Content/images/prev.gif'/>" /></a> --%>
<!-- 										</td> -->
<!-- 									</tr> -->
<!-- 								</tbody> -->
<!-- 							</table> -->
<!-- 						</td> -->
<!-- 					</tr> -->
<!-- 				</tbody> -->
<!-- 			</table> -->
<!-- 		</td> -->
<!-- 	</tr> -->
<!-- </table> -->



<style>.pagination{direction:rtl;} .pagination li {float: right!important;}</style>
<div id="paginate${gridId}" style="border-top: 2px dotted #dbe0e2; text-align: center;">
	<input type="hidden" size="1" value="${pageSize}" id="pageSize" onblur="pageSize = $('#pageSize').val();init();" name="pageSize"
		style="margin-left: 10px; height: 20px; font-family: tahoma;">

	<ul class="pagination ">
		<li>
			<a id="pageNumber${gridId}" class="btn btn-default btn-sm bg-primary" style="cursor: unset; padding: 8px 12px;padding-top:7px;">
			<span id="navigateNums" align="left" dir="ltr"><font size="2" face="tahoma" ><b>1</b>&nbsp;</font></span>
			</a>
		</li>
		<li>
			<a id="nextPage" title="بعدی" style="cursor: pointer;" onclick="nextPage()">
				«
			</a>
		</li>
		<li>
			<input id="pageSize" size="1" type="text" value="${pageSize}" class="bg-darkgray number-only" onblur="pageSize = $('#pageSize').val();init();" name="pageSize"
				style="float: right; margin-right: -1px;  outline: 0 none; padding: 5px 1px 6px; text-align: center; width: 40px;" />
		</li>
		<li>
			<a id="previousPage" title="قبلی" style="cursor: pointer;" onclick="prevPage()">
				»
			</a>
		</li>
		<li>
			<span class="btn btn-default btn-sm bg-primary" style="cursor: unset; padding: 8px 12px;padding-top:7px;">تعداد کل رکوردها</span>
			<a id="resultNum" class="btn btn-default btn-sm bg-primary" style="cursor: unset; padding: 8px 12px;padding-top:7px;">
				<span>مورد</span>
			</a>
		</li>
	</ul>
</div>
