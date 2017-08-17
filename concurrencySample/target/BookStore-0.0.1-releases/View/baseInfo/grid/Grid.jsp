<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<div class="table_content" id="table_content" style="width: 100%; margin-top: 0px">
	<div id="searchDIV" style="margin-top: 9px">
		<table border="0" style="width: 100%">
			<tr>
				<td align="left" style="padding-right: 20px;">
					<spring:message code="UI.BaseInformation.parentTopic" />
					&nbsp; :
				</td>
				<td align="right">
					<input id="txtSearchParentTopic" disabled="disabled" type="text" class="text" style="width: 260px" />
					<input type="button" id="btnSearchParentTopic" value='...' style="width: 30px; margin-right: -37px;" />
					<input type="hidden" value="-1" id="hiddenFieldSearchParentId" />
					<input type="hidden" value="-1" id="hiddenFieldSearchMasterInformationId" />
				</td>
				<td align="left" style="padding-right: 15px">
					<spring:message code="UI.BaseInformation.Topic" />
					&nbsp; :
				</td>
				<td align="right">
					<input id="txtSearchTopic" type="text" class="text persianOnly" style="width: 110px" dir="rtl" maxlength="40" />
				</td>
				<td align="left">وضعیت :</td>
				<td align="right">
					<select id="cmbStatus" style="width: 205px">
						<option value="-1" selected="selected">جستجو در همه رکوردها</option>
						<option value="0">جستجو فقط در رکوردهای غیرفعال</option>
						<option value="1">جستجو فقط در رکوردهای فعال</option>
					</select>
				</td>
				<td>
					<input type="button" onclick="fillTable()" value="<spring:message code="UI.General.search" />" />
					<input type="button" onclick="clearSearchFilter();" value="<spring:message code="UI.General.Clear" />" />
				</td>
			</tr>
		</table>
	</div>
	<div style="float: right; background-color: #DFE7FC; width: 100%; margin-top: 10px">
		<table width="100%" style="padding: 5px;">
			<tr>
				<td align="center" style="width: 5%">
					<a title='<spring:message code="UI.General.New" />' href="javascript:{}" onclick="showCurrent(-1,-1,'')">
						<img src="<c:url value = '/Content/images/add.gif' />" />
					</a>
				</td>
				<td align="center" style="width: 5%">
					<a title='<spring:message code="UI.General.Show" />' href="javascript:{}" onclick="pageNo=0;init()">
						<img src="<c:url value = '/Content/images/refresh.gif' />" />
					</a>
				</td>
				<td align="center" style="width: 90%">
					<div>
						<span style="color: red; float: right; padding-right: 9px">
							<spring:message code="UI.BaseInformation.CurrentPath" />
							: &nbsp;
						</span>
						<span id="navigationSpan" style="float: right; padding-bottom: 6px"></span>
					</div>
				</td>
			</tr>
		</table>
	</div>
	<table width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<td align="center" width="100%">
				<table class="grid" width="100%" align="center">
					<thead>
						<tr class="grid_header">
							<th nowrap="nowrap">
								<spring:message code="UI.General.Row" />
							</th>
							<th nowrap="nowrap">
								<spring:message code="UI.BaseInformation.Topic" />
								<a class="orderLink" href="javascript:{orderAsc('e.topic')}"> &#8595;</a>
								<a class="orderLink" href="javascript:{orderDesc('e.topic')}"> &#8593;</a>
							</th>
							<th nowrap="nowrap">
								<spring:message code="UI.BaseInformation.SecondTopic" />
								<a class="orderLink" href="javascript:{orderAsc('e.secondTopic')}"> &#8595;</a>
								<a class="orderLink" href="javascript:{orderDesc('e.secondTopic')}"> &#8593;</a>
							</th>
							<th nowrap="nowrap">
								<spring:message code="UI.BaseInformation.parentTopic" />
							</th>
							<th>
								<spring:message code="UI.BaseInformation.description" />
							</th>
							<th>وضعیت</th>
							<th>
								<spring:message code="UI.General.Edit" />
							</th>
							<th>
								<spring:message code="UI.General.Delete" />
							</th>
						</tr>
					</thead>
					<tbody id="entityBody">
						<script id="GridRowTemplate" type="text/html">
    							<tr id="pattern${id}"  class="oddRow"
            							onmouseover="highLight(this.id)" 
            							onmouseout="normLight(this.id)"
										ondblclick="showCurrent(${id},${parentId},'${parentTopic}')" >
        							<td align="center" width="30px">
           								 <span class="tmplRowIndex"></span>
       								</td>
        							<td align="center" >
            							<span onclick="navigateFrom(${id},'${topic}')" style="cursor:pointer;color:blue" >${topic}</span>
        							</td>
									<td align="center" >
            							<span>${secondTopic}</span>
        							 </td>
									<td align="center" >
										${getNavigationSpanLabel()}
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
									<td align="center"  width="30px">
										<img  src="<c:url value = '/Content/images/edit.png' />" style="cursor:pointer" onclick="showCurrent(${id})"/>
									</td>
									<td align="center"  width="30px">
										<img  src="<c:url value = '/Content/images/delete.gif' />" style="cursor:pointer" onclick="deleteBaseInfo(${id})"/>
									</td>		
    							</tr>
							</script>
					</tbody>
				</table>
			</td>
		</tr>
		<tr>
			<td align="left">
				
			</td>
		</tr>
	</table>
</div>
