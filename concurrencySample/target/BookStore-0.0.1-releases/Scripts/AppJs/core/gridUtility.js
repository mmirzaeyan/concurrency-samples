function nextPage() {
	var res = resultNum / pageSize;
	if (res > pageNo - 1) {
		pageNo++;
		init();
	}
}

function prevPage() {
	if (pageNo > 0) {
		pageNo--;
		init();
	}
}

function firstPage() {
	pageNo = 0;
	init();
}

function lastPage() {
	pageNo = Math.ceil(resultNum / pageSize - 1);
	init();
}

function showPage(pNo) {
	var res = Math.floor(resultNum / pageSize);
	if (res > pNo - 1 && pNo >= 0) {
		pageNo = pNo;
		init();
	} else {
		showMessage('حداکثر صفحه مجاز: ' + (res + 1));
		$('#txtGoto').val(pageNo + 1);
	}
}

function clearGrid(gridId) {
	$('#' + gridId + ' tbody :not(script)').remove();
	createNavigation(0, 0, 0);
	$('#txtGoto').val('1');
	pageNo = 0;
}

function orderAsc(fieldName) {
	order = fieldName + ' asc';
	orderOfCertificate = fieldName + ' asc';
	init();
}

function orderDesc(fieldName) {
	order = fieldName + ' desc';
	orderOfCertificate = fieldName + ' desc';
	init();
}

function backPage() {
	if (window.event != null)
		history.back();
	else
		back();
}

function refreshForm() {
	if (currentId != -1)
		showCurrent(currentId);
}

function createNavigation(resultNum, current, pageSize) {
	var template = '<A class="noborder" href="javascript:{}" onclick="showPage(pageNo)" >num &nbsp;</A>';
	var pageCount = Math.floor(resultNum / pageSize);
	if (pageCount * pageSize < resultNum)
		pageCount++;
	if (current > pageCount)
		current = pageCount;

	var start = Math.max(1, current - 3);
	var end = Math.min(pageCount, start + 9);
	if (end - start < 10)
		start = Math.max(1, end - 9);

	if (current + 1 < pageCount) {
		$('#nextIcon, #lastIcon').css('display', 'block');
		$('#nextIcon-dis, #lastIcon-dis').hide();
	} else {
		$('#nextIcon, #lastIcon').css('display', 'none'); // hideElement('nextIcon');
		$('#nextIcon-dis, #lastIcon-dis').show();
	}
	if (current == 0) {
		$('#prevIcon, #firstIcon').css('display', 'none'); // hideElement('prevIcon');
		$('#prevIcon-dis, #firstIcon-dis').show();
	} else {
		$('#prevIcon, #firstIcon').css('display', 'block'); // showElement('prevIcon');
		$('#prevIcon-dis, #firstIcon-dis').hide();
	}

	if (isNaN(pageCount))
		pageCount = 1;

	if (resultNum == 0 && current == 0 && pageSize == 0) // yani darim
															// navigation ro
															// reset mikonim
		pageCount = 1;

	var childs = '';
	childs += pageCount.toString() + '&nbsp;';
	childs += '/';
	childs += '&nbsp;<input type="text" id="txtGoto" value="'
			+ (pageNo + 1)
			+ '" onblur="showPage(parseInt(this.value - 1))" class="bg-darkgray number-only" style="width: 30px; height: 20px; text-align: center; margin: 0px; padding: 0px;" />';
	$('#navigateNums').html(childs);
	$('#resultNum').html(resultNum);
}

function selectedRowId(parentId) {
	var selected = null;
	var inputs = document.getElementById(parentId).getElementsByTagName('input');
	for (i = 0; i < inputs.length; i++) {
		if (inputs[i].id && inputs[i].id.indexOf('selectedItem') == 0 && inputs[i].checked) {
			selected = inputs[i].id.substring(14);
			break;
		}
	}
	return selected;
}

var tmp;
function normLight(id) {
	$('#' + id).css('backgroundColor', tmp);
}

function highLight(id) {
	tmp = $('#' + id).css('backgroundColor');
	$('#' + id).css('backgroundColor', '#ADEBAB');
}

var isSearchState = false;
function search() {
	isSearchState = true;
	pageNo = 0;
	init();
}

function tmplRowIndex(tmplId, pageNumber, pageSize) {
	i = 0;
	$('#' + tmplId).find('.tmplRowIndex').each(function() {
		i++;
		var rIndex;
		if (pageNumber != null && pageSize != null)
			rIndex = (pageNumber * pageSize) + i;
		else
			rIndex = i;
		$(this).append(rIndex);
	});
}

// dar sorati ke result QueryResult<Object>
function loadGridByEntityList(templateId, destinationId, entities, callBackFunction) {
	Loader(true);
	pageSize = $('#pageSize').val();
	if (pageSize < 5) {
		pageSize = 5;
		$('#pageSize').val(5);
	}
	if (pageSize > 50) {
		pageSize = 50;
		$('#pageSize').val(50);
	}
	resultNum = entities.totalRecords;
	showElements(new Array('table_content'));
	$('#' + destinationId + ' :not(script)').remove();
	if (entities.entityList) {
		$('#' + templateId).tmpl(entities.entityList).prependTo('#' + destinationId);
		tmplRowIndex(destinationId, entities.pageNumber, $('#pageSize').val());
	} else {
		$('#' + templateId).tmpl(entities).prependTo('#' + destinationId);
		tmplRowIndex(destinationId, 0, $('#pageSize').val());
	}

	if (entities.totalRecords == 0) {
		if (isSearchState)
			showMessage('موردی یافت نشد');
	}
	$('table.grid tbody tr:not([th]):odd').addClass('oddRow');
	$('table.grid tbody tr:not([th]):even').addClass('evenRow');

	createNavigation(entities.totalRecords, pageNo, pageSize);
	setSeperateItemInGrid(destinationId);
	initBaharan();
	if (callBackFunction != null && typeof callBackFunction == 'function')
		callBackFunction();
	Loader(false);
}

function loadGrid(templateId, destinationId, url, jsonData, callBackFunction) {
	Loader(true);
	pageSize = $('#pageSize').val();
	if (pageSize < 5) {
		pageSize = 5;
		$('#pageSize').val(5);
	}
	if (pageSize > 50) {
		pageSize = 50;
		$('#pageSize').val(50);
	}
	jsonData.pageSize = pageSize;
	$.getJSON(url, jsonData, function(entities) {
		resultNum = entities.totalRecords;
		showElements(new Array('table_content'));
		$('#' + destinationId + ' :not(script)').remove();
		if (entities.entityList) {
			$('#' + templateId).tmpl(entities.entityList).prependTo('#' + destinationId);
			tmplRowIndex(destinationId, entities.pageNumber, $('#pageSize').val());
		} else {
			$('#' + templateId).tmpl(entities).prependTo('#' + destinationId);
			tmplRowIndex(destinationId, 0, $('#pageSize').val());
		}

		if (entities.totalRecords == 0) {
			if (isSearchState)
				showMessage('موردی یافت نشد');
		}
		$('table.grid tbody tr:not([th]):odd').addClass('oddRow');
		$('table.grid tbody tr:not([th]):even').addClass('evenRow');

		createNavigation(entities.totalRecords, pageNo, pageSize);
		setSeperateItemInGrid(destinationId);
		initBaharan();
		if (callBackFunction != null && typeof callBackFunction == 'function')
			callBackFunction();
		Loader(false);
	});
}
// dar sorati ke result QueryResult<Object>
function loadGridWithCallBackFunction(templateId, destinationId, url, jsonData, callBackFunction) {
	Loader(true);
	pageSize = $('#pageSize').val();
	if (pageSize < 5) {
		pageSize = 5;
		$('#pageSize').val(5);
	}
	if (pageSize > 50) {
		pageSize = 50;
		$('#pageSize').val(50);
	}
	jsonData.pageSize = pageSize;
	$.getJSON(url, jsonData, function(entities) {
		resultNum = entities.totalRecords;
		showElements(new Array('table_content'));
		$('#' + destinationId + ' :not(script)').remove();
		if (entities.entityList) {
			$('#' + templateId).tmpl(entities.entityList).prependTo('#' + destinationId);
			tmplRowIndex(destinationId, entities.pageNumber, $('#pageSize').val());
		} else {
			$('#' + templateId).tmpl(entities).prependTo('#' + destinationId);
			tmplRowIndex(destinationId, 0, $('#pageSize').val());
		}
		if (entities.totalRecords == 0) {
			if (isSearchState)
				showMessage('موردی یافت نشد');
		}
		$('table.grid tbody tr:not([th]):odd').addClass('oddRow');
		$('table.grid tbody tr:not([th]):even').css('backgroundColor', '#DFEBF4');
		createNavigation(entities.totalRecords, pageNo, pageSize);
		setSeperateItemInGrid(destinationId);
		initBaharan();
		Loader(false);
		if (callBackFunction != null && typeof callBackFunction == 'function')
			callBackFunction();
		floatingHeader();
	});
}

function loadMultiGrid(templateId, destinationId, url, jsonData, tableContentId, gridClassName) {
	Loader(true);
	pageSize = $('#pageSize').val();
	if (pageSize < 5) {
		pageSize = 5;
		$('#pageSize').val(5);
	}
	if (pageSize > 50) {
		pageSize = 50;
		$('#pageSize').val(50);
	}
	$.getJSON(url, jsonData, function(entities) {
		resultNum = entities.totalRecords;
		showElements(new Array(tableContentId));
		$('#' + destinationId + ' :not(script)').remove();
		$('#' + templateId).tmpl(entities.entityList).prependTo('#' + destinationId);
		tmplRowIndex(destinationId, entities.pageNumber, $('#pageSize').val());
		if (entities.totalRecords == 0) {
			if (isSearchState)
				showMessage('موردی یافت نشد');
		}
		$('table.' + gridClassName + ' tbody tr:not([th]):odd').addClass('oddRow');
		$('table.' + gridClassName + ' tbody tr:not([th]):even').css('backgroundColor', '#DFEBF4');
		createNavigation(entities.totalRecords, pageNo, pageSize);
		setSeperateItemInGrid(destinationId);
		initBaharan();
		Loader(false);
		floatingHeader();
	});
}

// dar sorati ke result List<Object>
function loadGridWithoutPaging(templateId, destinationId, url, jsonData) {
	$('#' + destinationId + ' :not(script)').remove();
	Loader(true);
	$.getJSON(url, jsonData, function(entities) {
		if (entities.entityList)
			$('#' + templateId).tmpl(entities.entityList).prependTo('#' + destinationId);
		else
			$('#' + templateId).tmpl(entities).prependTo('#' + destinationId);
		tmplRowIndex(destinationId, null, null);
		$('table.grid tbody tr:not([th]):odd').addClass('oddRow');
		$('table.grid tbody tr:not([th]):even').css('backgroundColor', '#DFEBF4');
		setSeperateItemInGrid(destinationId);
		initBaharan();
		Loader(false);
	});
}

function loadGridWithoutPagingWithCallBackFunction(templateId, destinationId, url, jsonData, callBack) {
	Loader(true);
	$.getJSON(url, jsonData, function(entities) {
		$('#' + destinationId + ' :not(script)').remove();
		if (entities.entityList)
			$('#' + templateId).tmpl(entities.entityList).prependTo('#' + destinationId);
		else
			$('#' + templateId).tmpl(entities).prependTo('#' + destinationId);
		tmplRowIndex(destinationId, null, null);
		$('table.grid tbody tr:not([th]):odd').addClass('oddRow');
		$('table.grid tbody tr:not([th]):even').css('backgroundColor', '#DFEBF4');
		Loader(false);
		setSeperateItemInGrid(destinationId);
		initBaharan();
		callBack();
		floatingHeader();
	});
}

function loadGridWithoutPagingByEntityList(templateId, destinationId, entities, callBackFunction) {
	$('#' + destinationId + ' :not(script)').remove();
	if (entities.entityList)
		$('#' + templateId).tmpl(entities.entityList).prependTo('#' + destinationId);
	else
		$('#' + templateId).tmpl(entities).prependTo('#' + destinationId);
	tmplRowIndex(destinationId, null, null);
	$('table.grid tbody tr:not([th]):odd').addClass('oddRow');
	$('table.grid tbody tr:not([th]):even').css('backgroundColor', '#DFEBF4');
	setSeperateItemInGrid(destinationId);
	initBaharan();
	if (callBackFunction != null && typeof callBackFunction == 'function')
		callBackFunction();
	floatingHeader();
}


