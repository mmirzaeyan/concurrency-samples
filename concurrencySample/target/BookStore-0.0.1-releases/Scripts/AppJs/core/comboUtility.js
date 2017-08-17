function initComboUtility(){
	loadComboBaseInformation();
	fillEnumCombo();
	initMultiCombo();
}

function fillCombo(controlId, jsonUrl, jsonData, itemKey, itemValue, firstItemText, selectedValue, callBackFunction) {
    $.getJSON(jsonUrl, jsonData, function (entities) {
        var ddlSelectedProduct = $("#" + controlId);
        // clear all previous options 
        $("#" + controlId + " > option").remove();
        if (firstItemText)
            ddlSelectedProduct.append($("<option />").val(-1).text(firstItemText));
        // populate the items
        if(entities != null) {
        	if(entities.entityList)
            	entityList=entities.entityList;
            else
            	entityList=entities;
            
            $.each(entityList, function (i, entityItem) {
            	if(selectedValue != null && entityItem[itemKey] == selectedValue)
            		ddlSelectedProduct.append($("<option selected='selected' />").val(entityItem[itemKey]).text(entityItem[itemValue]));
            	else
            		ddlSelectedProduct.append($("<option />").val(entityItem[itemKey]).text(entityItem[itemValue]));
            });
            ddlSelectedProduct.attr('selectedIndex', 0);
            chosen(ddlSelectedProduct);
            if(callBackFunction != null && typeof callBackFunction == 'function')	
            	callBackFunction();
       	}
    });
}

function fillComboStringList(controlId, jsonUrl, jsonData, firstItemText, selectedValue, callBackFunction) {
    $.getJSON(jsonUrl, jsonData, function (entities) {
        var ddlSelectedProduct = $("#" + controlId);
        // clear all previous options 
        $("#" + controlId + " > option").remove();
        if (firstItemText)
            ddlSelectedProduct.append($("<option />").val(-1).text(firstItemText));
        // populate the items
        $.each(entities, function (i, entityItem) {
        	if(selectedValue != null && entityItem == selectedValue)
        		ddlSelectedProduct.append($("<option selected='selected' />").val(entityItem).text(entityItem));
        	else
        		ddlSelectedProduct.append($("<option />").val(entityItem).text(entityItem));
        });
        ddlSelectedProduct.attr('selectedIndex', 0);
        chosen(ddlSelectedProduct);
        if(callBackFunction != null && typeof callBackFunction == 'function')	
        	callBackFunction();
    });
}

function fillComboSync(controlId, jsonUrl, jsonData, itemKey, itemValue, firstItemText, selectedValue, callBackFunction) {
	$.ajax({
		type:			"GET",
		url: 			jsonUrl,
		data:			jsonData,
		contentType:	"application/json;",
		dataType:		"json",
		async:			false,
		success:		function(entities) {
							var ddlSelectedProduct = $("#" + controlId);
					        $("#" + controlId + " > option").remove();
					        if (firstItemText)
					            ddlSelectedProduct.append($("<option />").val(-1).text(firstItemText));
					        // populate the items
					        if(entities != null) {
					        	if(entities.entityList)
					            	entityList = entities.entityList;
					            else
					            	entityList = entities;
					            
					            $.each(entityList, function (i, entityItem) {
					            	if(selectedValue != null && entityItem[itemKey] == selectedValue)
					            		ddlSelectedProduct.append($("<option selected='selected' />").val(entityItem[itemKey]).text(entityItem[itemValue]));
					            	else
					            		ddlSelectedProduct.append($("<option />").val(entityItem[itemKey]).text(entityItem[itemValue]));
					            });
					            ddlSelectedProduct.attr('selectedIndex', 0);
					            chosen(ddlSelectedProduct);
					            if(callBackFunction != null && typeof callBackFunction == 'function')	
					            	callBackFunction();
					        }
		}
    });
}

function advancedFillCombo(controlId, jsonUrl, jsonData, itemKey, values, additionalAttr, firstItemText, separateLabel, seprateItem, selectedValue, callBackFunction) {
    $.getJSON(jsonUrl, jsonData, function (entities) {
        var ddlSelectedProduct = $("#" + controlId);
        // clear all previous options 
        $("#" + controlId + " > option").remove();
        if (firstItemText)
            ddlSelectedProduct.append($("<option />").val(-1).text(firstItemText));
        // populate the items
        if(entities != null) {
        	if(entities.entityList)
            	entityList = entities.entityList;
            else
            	entityList = entities;
        	if (separateLabel == undefined || separateLabel == null) separateLabel = " ";
        	if (seprateItem == undefined || seprateItem == null) seprateItem = " - ";
        	$.each(entityList, function (index, element) {
        		var cmbValue = '';
        		if (typeof values == 'string') {
					cmbValue = element[values]; 
				}
        		else if (typeof values == 'object') {
        			$.each(values, function(i, e) {
        			if (element[e["value"]] != null) {
        				if (e["label"] != null)
							cmbValue += e["label"] + separateLabel + element[e["value"]] + seprateItem;
						else
							cmbValue += element[e["value"]] + seprateItem;
        				}
        			});
        			cmbValue = cmbValue.substr(0 , cmbValue.length - (seprateItem.length));
        		}
        		var additionalData = '';
        		if (additionalAttr) {	
        			if (typeof additionalAttr == 'string') {
        				additionalData = additionalAttr + '="' + element[additionalAttr] + '" ';
        			} 
        			else if (typeof additionalAttr == 'object') {
        				$.each(additionalAttr, function(i, e) { additionalData += e + '="' + element[e] + '" '; });
        			}
        		}
        		if(selectedValue != null && element[itemKey] == selectedValue)
        			ddlSelectedProduct.append($("<option selected='selected' " + additionalData + "/>").val(element[itemKey]).text(cmbValue));
        		else
        			ddlSelectedProduct.append($("<option " + additionalData + "/>").val(element[itemKey]).text(cmbValue));
        	});
            if(callBackFunction != null && typeof callBackFunction == 'function')	
            	callBackFunction();
       	}
        chosen(ddlSelectedProduct);
    });
}

function fillSomeCombo(controlCssClass, jsonUrl, jsonData, itemKey, itemValue, firstItemText, selectedValue, callBackFunction) {
	$.ajax({
		type:		"GET",
		url: 		jsonUrl,
		data:		jsonData,
		contentType:"application/json;",
		dataType:	"json",
		async:		false,
		success:	function(entities) {
    	$("." + controlCssClass + " > option").remove();
    	$("." + controlCssClass).each(function() {
	        var ddlSelectedProduct = $(this);
	        if (firstItemText)
	            ddlSelectedProduct.append($("<option />").val(-1).text(firstItemText));
	        if(entities.entityList)
	        	entityList = entities.entityList;
	        else
	        	entityList = entities;
	        $.each(entityList, function (i, entityItem) {
	        	if(selectedValue != null && entityItem[itemKey] == selectedValue)
	        		ddlSelectedProduct.append($("<option selected='selected' />").val(entityItem[itemKey]).text(entityItem[itemValue]));
	        	else
	        		ddlSelectedProduct.append($("<option />").val(entityItem[itemKey]).text(entityItem[itemValue]));
	        });
	        ddlSelectedProduct.attr('selectedIndex', 0);
	        chosen(this);
    	});
    	
        if(callBackFunction != null && typeof callBackFunction == 'function')	
        	callBackFunction();
		}
    });
}

function chosen(combo) {
	if (typeof $(combo).chosen == 'function' && $(combo).hasClass('filterMode')) {
		$(combo).chosen({ no_results_text: "هیچ مقداری یافت نشد", filterMode: "", width: $(combo).width()+"px" }); 
	}
}


function fillComboYear(controlId, selectedYear, startYear, endYear, isPersian) {
    var ddlSelectedProduct = $("#" + controlId);
	var year;
	if(startYear == 0 || startYear == null)
		startYear = 1300;
	if(endYear == 0 || endYear == null)
		endYear = 2050;
	if(selectedYear == 0 || selectedYear == null)
		if (isPersian == null)
			selectedYear = getPersianYear();
		else
			selectedYear = getTodayGregorian()[0];

	if(startYear <= endYear)
		for(year = startYear; year <= endYear; year++) {
			if(year == selectedYear)
				ddlSelectedProduct.append($("<option selected='selected' />").val(year).text(year));
			else
				ddlSelectedProduct.append($("<option />").val(year).text(year));
		}
}

function fillEnumCombo() {
	$('[class*=enumCombo]').each(function(index, element) {
		var rulesParsing = $(this).attr('class');
		var getRules = /enumCombo\[(.*)\]/.exec(rulesParsing);
		var callBackFunctionName = $(this).attr('data-callback');
		if (callBackFunctionName)
			var callBack = new Function('return ' + callBackFunctionName + '()');
		else
			var callBack = null;
		jsonData = { classFullName : getRules[1] };
    	fillCombo($(element).attr('id'), coreUrl.enumKeyValueHandler , jsonData, "index", "persianTitle", "...", null, callBack);
	});
}


function loadComboBaseInformation() {
	$('[class*=BaseInformation]').each(function(index, element) {
		var rulesParsing = $(this).attr('class');
		var getRules = /BaseInformation\[(.*)\]/.exec(rulesParsing);
		var basenformationId = getRules[1];
		var callBackFunctionName = $(this).attr('data-callback');
		if (callBackFunctionName)
			var callBack = new Function('return ' + callBackFunctionName + '()');
		else
			var callBack = null;
    	fillComboSync($(element).attr('id'), coreUrl.baseInformation + basenformationId, {}, "id", "topic", "...", null, callBack);
	});
}

function initMultiCombo(){
	$('[class*=multiCombo]').each(function(index, element) {
		if ($(element).attr('multi')!=1){
			$(element).multiselect('rebuild');
			$(element).attr('multi','1');
		}
		
	});
}

function getSelectedFromMultiple(comboId){
	var selected=$('#'+comboId +' option:selected');
	var array=[]
	$(selected).each(function(){
		array.push($(this).attr('value'));
	});
	var commaSepratedSelected = array.join(', ');
	return commaSepratedSelected;
	    
}
