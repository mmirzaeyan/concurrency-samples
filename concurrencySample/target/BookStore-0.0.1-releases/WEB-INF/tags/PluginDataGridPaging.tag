<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ attribute name="pageSize" required="true" rtexprvalue="true"%>
<%@ attribute name="gridId" required="true" rtexprvalue="true"%>
<style>.pagination{direction:rtl;} .pagination li {float: right!important;}</style>
<div id="paginate${gridId}" style="border-top: 2px dotted #dbe0e2; text-align: center;">
	<input type="hidden" size="1" value="${pageSize}" id="pageSize${gridId}" onblur="$('#${gridId}').grid('setPageSize', this.value)" name="pageSize"
		style="margin-left: 10px; height: 20px; font-family: tahoma">

	<ul class="pagination ">
		<li>
			<a id="pageNumber${gridId}" class="btn btn-default btn-sm bg-primary" style="cursor: unset; padding: 8px 12px;padding-top:7px;">
				<span>صفحه</span>
			</a>
		</li>
		<%-- <li>
			<a id="lastPage${gridId}">
				<<
			</a>
		</li> --%>
		<li>
			<a id="nextPage${gridId}" title="بعدی">
				«
			</a>
		</li>
		<li>
			<input id="gotoPage${gridId}" type="text" value="1" class="bg-darkgray number-only" onblur="$('#${gridId}').grid('showPage', parseInt(this.value - 1))"
				style="float: right; margin-right: -1px;  outline: 0 none; padding: 5px 1px 6px; text-align: center; width: 40px;" />
		</li>
		<li>
			<a id="previousPage${gridId}" title="قبلی">
				»
			</a>
		</li>
		<%--<li>
			<a id="firstPage${gridId}">
				>>
			</a>
		</li> --%>
		<li>
			<a id="resultNumber${gridId}" class="btn btn-default btn-sm bg-primary" style="cursor: unset; padding: 8px 12px;padding-top:7px;">
				<span>مورد</span>
			</a>
		</li>
	</ul>
</div>


<%-- <%@ tag language="java" pageEncoding="UTF-8"   %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="pageSize" required="true" rtexprvalue="true"  %>
<%@ attribute name="gridId" required="true" rtexprvalue="true"  %>

<div  style="width:100%; text-align:center;">
	<div id="pagination${gridId}"></div>
</div>
<div style="width:100%; text-align:center;">
	<input type="hidden" size="1" value="${pageSize}" id="pageSize${gridId}" onblur="$('#${gridId}').grid('setPageSize', this.value)" name="pageSize" style="margin-left:10px; height:20px; font-family:tahoma">
</div>  --%>