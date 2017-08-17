(function ($){
	function setEntity(form) {
		var formId = "";
		var entity = {};
		if (form)
			formId = '#' + form;
			
		$(formId + ' [data-search]').each(function(index, element) {
			var _name = $(element).attr('data-search');
			var _type = $(element).prop('type');
			switch (_type){
				case 'text':
				case 'textarea':
				default:
					if ($(element).val())
						entity[_name] = $(element).val();
					else if ($(element).attr('data-default'))
						entity[_name] = $(element).attr('data-default');
					break;
				case 'radio':
					if ($(element).prop('checked')){
						entity[_name] = $(element).val();
					}
					break;
				case 'checkbox':
					if ($('[data-search=' + _name + ']').length == 1) {
						entity[_name] = $(element).prop('checked');
					}
					else {
						entity[_name] = new Array();
						$.each($('[data-search=' + _name + ']'), function(index, element){
							if($(element).prop('checked')){
								entity[_name].push($(element).val());
							}
						});
					}
					break;
			}
	    });
		return entity;
	}
	
	function getSearchEntity(jq) {
		var _options = $.fn.grid.methods.options(jq);
		var searchEntity = null;
		if(_options.searchBoxId) {
			searchEntity = setEntity(_options.searchBoxId);
		}
		else {
			searchEntity = setEntity('searchBox');
		}		
		
		searchEntity.order = _options.order;
		searchEntity.pageNumber = _options.pageNumber;
		searchEntity.pageSize = _options.pageSize;
		
		return searchEntity;
	}
	
	function fillTable(target){
		var _settings = $(target).data('gridOptions') || $.extend({}, $.fn.grid.defaults, $.fn.grid.parseOptions(target));
		var _entityList = null;
		var targetId = $(target).attr('id');
		if (_settings.createSearchOptions) {
			var searchEntity = null;
			if(_settings.searchBoxId) {
				searchEntity = setEntity(_settings.searchBoxId);
			}
			else {
				searchEntity = setEntity('searchBox');
			}
			if (_settings.paging) {
				searchEntity.pageSize = _settings.pageSize;
				searchEntity.pageNumber = _settings.pageNumber;
			}
			if(_settings.order)
				searchEntity.order = _settings.order;
			_settings.jsonData = searchEntity;
		}
		else {
			_settings.jsonData = createJsonData(target);
			if (_settings.paging){
				_settings.jsonData.pageSize = _settings.pageSize;
				_settings.jsonData.pageNumber = _settings.pageNumber;
			}
			if(_settings.order)
				_settings.jsonData.order = _settings.order;
		}
		if(_settings.beforeSearch){
			_settings.jsonData=_settings.beforeSearch(_settings.jsonData);
		}
		if (_settings.paging){
			pageSize = $('#pageSize' + targetId).val();
		    if (pageSize < 5) {
		        pageSize = 5;
		        $('#pageSize' + targetId).val(5);
		    }
		    if (pageSize > 50) {
		        pageSize = 50;
		        $('#pageSize' + targetId).val(50);
		    }
		    _settings.jsonData.pageSize = pageSize;
		}
		if (_settings.beforeInit){
			var result = _settings.beforeInit();
			if (!result){
				return false;
			}
		}
		if(!_settings.entityList && _settings.url){
			Loader(true);
			$.ajax({
				type: _settings.isPost ? "POST" : "GET",
				contentType : "application/json",
				dataType:"json",
				url: createUrl(target),
				data: _settings.isPost ? JSON.stringify(_settings.jsonData) : _settings.jsonData,
				async: _settings.async, 
				success: function (entities) {
					_entityList = entities;
			        fillGrid(target, entities, _settings);
			        Loader(false);
					$(target).data('entityList', _entityList);
					floatingHeader();
					return _entityList;
				}
			});
		}
		else{
			_entityList = _settings.entityList;
			fillGrid(target, _settings.entityList, _settings);
			$(target).data('entityList', _entityList);
			floatingHeader();
			return _entityList;
		}
	}

	function clearGrid(target){
		var _settings = $(target).data('gridOptions') || $.extend({}, $.fn.grid.defaults, $.fn.grid.parseOptions(target));

		var targetId = $(target).attr('id');
		$(target).find(_settings.destinationId + ' :not(script)').remove();
	    createNavigation(0, 0, 0, targetId);
	    
	    $('#txtGoto' + targetId).val('1');

	    var _options = $('#' + targetId).data('gridOptions');
	    _options.pageNumber = 0;
	    $('#' + targetId).data('gridOptions', _options);
	}

	function fillGrid(target, entities, _settings){
		$(target).find(_settings.destinationId + ' :not(script)').remove();
		var targetId = $(target).attr('id');
		if (_settings.paging){
			var tmpEntityList = '';
			var pageNo  = 0;
			if (entities.entityList){
				tmpEntityList = entities.entityList;
				pageNo = entities.pageNumber;
			}
			else
				tmpEntityList = entities;
			if (!_settings.templateId){
				$(target).find('script').tmpl(tmpEntityList).prependTo($(target).find(_settings.destinationId));
			}
			else {
				$('#' + templateId).tmpl(tmpEntityList).prependTo($(target).find(_settings.destinationId));
			}
			tmplRowIndex($(target).find(_settings.destinationId).attr('id'), pageNo, $('#pageSize' + targetId).val());
		}
		else{
			if (!_settings.templateId){
				$(target).find('script').tmpl(entities).prependTo($(target).find(_settings.destinationId));
			}
			else {
				$('#' + templateId).tmpl(entities).prependTo($(target).find(_settings.destinationId));
			}
			tmplRowIndex($(target).find(_settings.destinationId).attr('id'), 0, $('#pageSize' + targetId).val());
		}
        if (entities.totalRecords == 0) {
        	if(_settings.notFoundDataAlert){
        		showMessage(_settings.msg.NotFoundData);
        	}
        }
        $('table.grid tbody tr:not([th]):odd').addClass('oddRow');
        $('table.grid tbody tr:not([th]):even').addClass('evenRow');

		if (_settings.paging)
			createNavigation(entities.totalRecords, entities.pageNumber, entities.pageSize, $(target).attr('id'));

        setSeperateItemInGrid($(target).find(_settings.destinationId).attr('id'));
        
        if (_settings.tooltip)
        	setQtip();
        
        if (_settings.onComplete)
        	_settings.onComplete(entities);
	}
	
	function createNavigation(resultNum, current, pageSize, targetId) {
	    var template = '<A class="noborder" href="javascript:{}" onclick="$(\'#' + targetId + '\').grid(\'showPage\', pageNo)" >num &nbsp;</A>';
	    var pageCount = Math.floor(resultNum / pageSize);
	    if (pageCount * pageSize < resultNum)
	        pageCount++;
	    if (current > pageCount)
	        current = pageCount;

	    var start = Math.max(1, current - 3);
	    var end = Math.min(pageCount, start + 9);
	    if (end - start < 10)
	        start = Math.max(1, end - 9);

	    if (current + 1 < pageCount){
	        $('#nextIcon' + targetId + ', #lastIcon' + targetId).css('display', 'block');
	        $('#nextIcon-dis' + targetId + ', #lastIcon-dis' + targetId).hide();
	    }
	    else{
	        $('#nextIcon' + targetId + ', #lastIcon' + targetId).css('display', 'none'); // hideElement('nextIcon');
	        $('#nextIcon-dis' + targetId + ', #lastIcon-dis' + targetId).show();
	    }
	    if (current == 0){
	        $('#prevIcon' + targetId + ', #firstIcon' + targetId).css('display', 'none'); //hideElement('prevIcon');
	        $('#prevIcon-dis' + targetId + ', #firstIcon-dis' + targetId).show();
	    }
	    else{
	        $('#prevIcon' + targetId + ', #firstIcon' + targetId).css('display', 'block'); // showElement('prevIcon');
	        $('#prevIcon-dis' + targetId + ', #firstIcon-dis' + targetId).hide();
	    }
	    
	    if (isNaN(pageCount))
	    	pageCount = 1;
	    
	    
	    var _options = $('#' + targetId).data('gridOptions');
	    _options.pageCount = pageCount - 1;
	    $('#' + targetId).data('gridOptions', _options);
	    
	    if (resultNum == 0 &&  current == 0 && pageSize == 0) // yani darim navigation ro reset mikonim
	    	pageCount = 1;
	    
	    var childs = '';
	    childs += pageCount.toString() + '&nbsp;';
	    childs += '/';
	    childs += '&nbsp;<input type="text" id="txtGoto' + targetId + '" value="' + (current + 1) + '" onblur="$(\'#' + targetId + '\').grid(\'showPage\', parseInt(this.value - 1))" class="numberOnly" style="width: 30px; height: 20px; text-align: center; margin: 0px; padding: 0px;" />';
	    
	    $('#navigateNums' + targetId).html(childs);
	    $('#resultNum' + targetId).html(resultNum);
	}
	
	function tmplRowIndex(tmplId, pageNumber, pageSize) {
		i=0;
		$('#'+tmplId).find('.tmplRowIndex').each(function () {
			i++;
			var rIndex;
			if(pageNumber != null && pageSize != null)
				rIndex = (pageNumber * pageSize) + i;
			else
				rIndex = i;
		    $(this).append(rIndex);                    
		});
	}
	
	function setSeperateItemInGrid(gridId){
	 	$('#' + gridId + ' .money ').each(function(){
	 	 	 $(this).html(toMoneyFormat($(this).html()));
	 	 	 $(this).val(toMoneyFormat($(this).val()));
		});
	}
	
	function toMoneyFormat(number) {
		number += '';
	    if(number.length > 0) {
		    var sign = (parseFloat(number) >= 0) ? '' : '-';
			temp = '';
			//seprate numebrs and strings
			for(i=0 ; i <= (number.length - 1); i++) {
				if((number[i] >= '0' && number[i] <= '9') || number[i] == ',' || number[i] == '.')
					temp += number[i];
			}
			//remove the existing ,+
			try {
				var regex = /,/g;
				temp = temp.replace(regex,'');
			}
			catch(e) {}
			//force it to be a string
			temp += '';
			//split it into 2 parts  (for numbers with decimals, ex: 125.05125)
			var x = temp.split('.');
			var p1 = x[0];
			var p2 = x.length > 1 ? '.' + x[1] : '';
			//match groups of 3 numbers (0-9) and add , between them
			regex = /(\d+)(\d{3})/;
			while (regex.test(p1)) {
				p1 = p1.replace(regex, '$1' + ',' + '$2');
			}
			//join the 2 parts and return the formatted number
			return sign + p1 + p2;
		}
		else {
			return number;
		}
	}
	
	function showPage(target, pNo) {
		var _options = $(target).data('gridOptions');
	    if (_options.pageCount >= pNo && pNo >= 0) {
	    	$(target).grid({ pageNumber: pNo });
	    }
	    else{
	    	showMessage('حداکثر صفحه مجاز: ' + (_options.pageCount + 1));
	    	$('#txtGoto' + $(target).attr('id')).val(_options.pageNumber + 1);
	    }
	}
	
	function nextPage(target){
		var _settings = $(target).data('gridOptions');
		$(target).grid({ pageNumber: _settings.pageNumber + 1 });
	}
	
	function prevPage(target){
		var _settings = $(target).data('gridOptions');
		$(target).grid({ pageNumber: _settings.pageNumber - 1 });
	}

	function firstPage(target) {
		$(target).grid({ pageNumber: 0 });
	}
	
	function lastPage(target) {
		var _options = $(target).data('gridOptions');
		$(target).grid({ pageNumber: _options.pageCount});
	}
	
	function setPageSize(target, params){
		$(target).grid({ pageSize: params });
	}
	
	function setOrder(target, order){
		$(target).grid({ order: order });
	}
	
	function createFunctions(targetId){
        $('#' + targetId + ' [order]').each(function(index, element) {
            var order = $(this).attr('order');
			var type = $(this).attr('type');
			$(this).attr('href', 'javascript:{$(\'#' + targetId + '\').grid(\'setOrder\', \'' + order + ' ' + type + '\')}');
        });
        var _setting = $('#' + targetId).grid('options');
		
		/* if have more than one grid in a page
		 * to set correct events for buttons of eahc grid
		 * you should set 'searchBoxId' option of grids
		 */
		if(_setting.searchBoxId) {
			$('#' + _setting.searchBoxId+ ' .search:not([searchProperty])').attr('onClick', '$(\'#' + targetId + '\').grid(\'fillTable\');');
	        $('#' + _setting.searchBoxId+ ' .clearSearch').attr('onClick', '$(\'#' + targetId + '\').grid(\'clearSearch\');');
		}
        else if(_setting.mainGrid) {
        	$('.search:not([searchProperty])').attr('onClick', '$(\'#' + targetId + '\').grid(\'fillTable\');');
	        $('.clearSearch').attr('onClick', '$(\'#' + targetId + '\').grid(\'clearSearch\');');
        }
	}
	
	function clearForm(form){
		var formId = "";
		if (form)
			formId = '#' + form;
			
		$(formId + ' [data-search]').each(function(index, element) {
			var _type = $(element).prop('type');
			switch (_type){
				case 'text':
				case 'textarea':
				default:
					if ($(element).attr('data-default'))
						$(element).val($(element).attr('data-default'));
					else
						$(element).val('');
					
					break;
				case 'select':
					$(element).val($(element).find("option:first").val());
					break;
				case 'select-one':	
					if ($(element).hasClass("filterMode") && typeof $(element).chosen =='function') {
						$(element).val($(element).find("option:first").val()).trigger("chosen:updated");
					} else {
						$(element).val($(element).find("option:first").val());
					}
					break;
				case 'radio':
				case 'checkbox':
					$(element).prop('checked', false);
					break;
			}
	    });
	}
	
	function createJsonData(target){
		var _options = $.extend({}, $.fn.grid.defaults, $.fn.grid.parseOptions(target));
		return _options.jsonData;
	}
	function createUrl(target){
		var _options = $.extend({}, $.fn.grid.defaults, $.fn.grid.parseOptions(target));
		return _options.url;
	}
	
	function setQtip(){
		if (typeof $(document).qtip == 'function') {
			$(document).find('[data-qtip*=qtip]').each(function(index, element) {
				$(element).removeData();
				var rulesParsing = $(element).attr('data-qtip');
				var getRules = /qtip\[(.*)\]/.exec(rulesParsing);
				if (!getRules) {
					$(element).qtip({});
				} else {
					var str = getRules[1];
					var rules = str.split(/\[|,|\]/);
					var userMy = 'top left', userAt = 'bottom right', userClasses = '', userContent;
					for (var i = 0; i < rules.length; i++) {
						rules[i] = rules[i].replace(' ', '');
						if (rules[i] === '') {
							delete rules[i];
						}
					}
					for (var i = 0; i < rules.length; i++) {
						switch (rules[i]) {
						case 'at':
							userAt = rules[i + 1];
							break;
						case 'my':
							userMy = rules[i + 1];
							break;
						case 'cssClass':
							userClasses = rules[i + 1];
							break;
						case 'content':
							userContent = rules[i + 1];
							break;
						}
					}
					$(element).qtip({
						position : {
							my : userMy,
							at : userAt
						},
						style : {
							classes : userClasses
						},
						content : (userContent || {attr : 'title'})
					});
				}
			});
		}
	}
	
	$.fn.grid = function(options, params){
		if (typeof options == 'string'){
			var method = $.fn.grid.methods[options];
			if(method){
				return (method(this, params));
			}
		}
		options = options || {};
		return this.each(function(){
			var state = $(this).data('gridOptions');
			if(state){
				$.extend(state, options);
					fillTable(this);
			}
			else{
				var _options = $.extend({}, $.fn.grid.defaults, $.fn.grid.parseOptions(this));
				
				$(this).data('gridOptions', _options);
				if (_options.fillTable)
					fillTable(this);
				createFunctions($(this).attr('id'));
			}
		});
	};
	
	$.fn.grid.methods = {
		options: function(jq){
			return $(jq[0]).data('gridOptions');
		},
		setOptions: function(jq, params){
			var _options = $.fn.grid.methods.options(jq);
			$.extend(_options, params);
		},
		fillTable: function(jq){
			return fillTable(jq);
		},
		showPage: function(jq, params){
			showPage(jq, params);
		},
		nextPage: function(jq){
			nextPage(jq);
		},
		prevPage: function(jq){
			prevPage(jq);
		},
		clearSearch: function(jq) {
			var _options = $.fn.grid.methods.options(jq);
			if(_options.searchBoxId) {
				clearForm(_options.searchBoxId);
			}
			else {
				clearForm('searchBox');				
			}
		},
		setPageSize: function(jq, params){
			setPageSize(jq, params);
		},
		setOrder: function(jq, params){
			setOrder(jq, params);
		},
		clearTable: function(jq){
			clearGrid(jq);
		},
		firstPage: function(jq){
			firstPage(jq);
		},
		lastPage: function(jq){
			lastPage(jq);
		},
		clearGrid: function(jq){
			clearGrid(jq);
		},
		getGridData: function(jq){
			return $(jq).data('entityList');
		},
		getSearchEntity: function(jq) {
			return getSearchEntity(jq);
		}
	};
	
	$.fn.grid.parseOptions = function(target) {
		return $.parser.parseOptions(target, [
		   'url'
		]);
	};
	
	$.fn.grid.defaults = {
		url: null,
		isPost: false,
		jsonData: {},
		onComplete: null,
		beforeInit: null,
		entityList: null,
		beforeSearch:null,
		async: true,
		paging: true,
		fillTable: true,
		createSearchOptions: false,
		order: ' e.id desc',
		pageSize: 10,
		pageNumber: 0,
		pageCount: -1,
		notFoundDataAlert: true,
		mainGrid: true,
		tooltip: true,
		templateId: null,
		searchBoxId: null,
		destinationId: 'tbody.entityBody',
		msg: {
			NotFoundData: "موردی یافت نشد"
		}
	};
})(jQuery);
