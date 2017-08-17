(function ($){
	function create(target, _opts){
		var _settings = $(target).data('fillCombo') || $.extend({}, $.fn.fillCombo.defaults, $.fn.fillCombo.parseOptions(target));
		_settings = checkBaseInformation(_settings);
		if(!_settings.entityList && _settings.url){
			Loader(true);
			$.ajax({
				type:"GET",
				ContentType : "application/json",
				dataType:"json",
				url: createUrl(target),
				data: createJsonData(target),
				async: _settings.async, 
				success: function (entities) {
					populateItems(target, entities, _settings);
					if(_settings.filterMode){
						var config = {
								'.chosen-select' : {},
								'.chosen-select-deselect' : {
									allow_single_deselect : true
								},
								'.chosen-select-no-single' : {
									disable_search_threshold : 10
								},
								'.chosen-select-no-results' : {
									no_results_text : 'Oops, nothing found!'
								},
								'.chosen-select-width' : {
									width : "95%"
								}
							};
						$(target).chosen({no_results_text: "هیچ مقداری یافت نشد"}); 
						$(target).chosen(config);
						$(".chosen-search input").css("color","black");
						$(".chosen-search input").css("font-family","tahoma");
					}
					Loader(false);
				}
			});
		}
		else{
			populateItems(target, _settings.entityList, _settings);
		}
	}
	
	function populateItems(target, entities, _settings){
		var _obj = $(target);
        // clear all previous options 
		_obj.fillCombo.methods.remove(target);
		if(_settings.relation){
			if (typeof _settings.relation == 'string'){
					$(_settings.relation).fillCombo.methods.remove(_settings.relation);
			}
			else if (typeof _settings.relation == 'object'){
				$.each(_settings.relation, function(i, e){
					$(e).fillCombo.methods.remove(e);
				});
			}
		}
		
        if(_settings.firstItemValue && _settings.firstItemText){
			_obj.append($("<option />").val(_settings.firstItemValue).text(_settings.firstItemText));
			if(_settings.relation){
				if (typeof _settings.relation == 'string'){
					if(_settings.firstItemValue && _settings.firstItemText){
						$(_settings.relation).append($("<option />").val(_settings.firstItemValue).text(_settings.firstItemText));
					}
				}
				else if (typeof _settings.relation == 'object'){
    				$.each(_settings.relation, function(i, e){
    					if(_settings.firstItemValue && _settings.firstItemText){
    						$(e).append($("<option />").val(_settings.firstItemValue).text(_settings.firstItemText));
    					}
					});
				}
			}
		}
        // populate the items
		if(entities != null){
        	if(entities.entityList)
            	entityList = entities.entityList;
            else
            	entityList = entities;
        	$(target).data('fillComboData', { entityList: entityList });
        	
        	if(_settings.relation){
				if (typeof _settings.relation == 'string'){
					$(_settings.relation).data('fillComboData', { entityList: entityList });
				}
				else if (typeof _settings.relation == 'object'){
    				$.each(_settings.relation, function(i, e){
    					$(e).data('fillComboData', { entityList: entityList });
					});
				}
			}
        	
        	$.each(entityList, function (index, element){
        		var cmbValue = '';
        		if (typeof _settings.values == 'string'){
					cmbValue = element[_settings.values];
				}
        		else if (typeof _settings.values == 'object'){
        			$.each(_settings.values, function(i, e){
        				if (element[e["value"]] != null) {
        					if (e["label"] != null)
								cmbValue += e["label"] + _settings.separateLabel + element[e["value"]] + _settings.separateItem;
							else
								cmbValue +=  element[e["value"]] + _settings.separateItem;
        				}
        			});
        			cmbValue = cmbValue.substr(0 , cmbValue.length - (_settings.separateItem.length));
        		}
        		var additionalData = '';
        		if (_settings.additionalAttr){
        			if (typeof _settings.additionalAttr == 'string'){
        				additionalData = _settings.additionalAttr + '="' + element[_settings.additionalAttr] + '" ';
        			}
        			else if (typeof _settings.additionalAttr == 'object'){
        				$.each(_settings.additionalAttr, function(i, e){
							additionalData += e + '="' + element[e] + '" ';
						});
					}
        		}
    			_obj.append($("<option " + additionalData + "/>").val(element[_settings.itemKey]).text(cmbValue));
    			if(_settings.relation){
    				if (typeof _settings.relation == 'string'){
    					$(_settings.relation).append($("<option " + additionalData + "/>").val(element[_settings.itemKey]).text(cmbValue));
    				}
    				else if (typeof _settings.relation == 'object'){
        				$.each(_settings.relation, function(i, e){
        					$(e).append($("<option " + additionalData + "/>").val(element[_settings.itemKey]).text(cmbValue));
						});
					}
    			}
        	});
        	if ( _settings.relation ) { // baraye inke vaghty chand cobom ba selected mokhtalef dashtim in kar konad
        		if (typeof _settings.relation == 'string'){
					$(_settings.relation).each(function(i, e){
						var __settings = $.extend({}, $.fn.fillCombo.defaults, $.fn.fillCombo.parseOptions(this));
						if(__settings.selected){
			        		$(this).val(__settings.selected);
			        	}
					});
				}
				else if (typeof _settings.relation == 'object'){
    				$.each(_settings.relation, function(i, e){
    					$(e).each(function(is, es){
    						var __settings = $.extend({}, $.fn.fillCombo.defaults, $.fn.fillCombo.parseOptions(this));
    						if(__settings.selected){
    			        		$(this).val(__settings.selected);
    			        	}
    					});
					});
				}
        	}
        	
        	if(_settings.selected){
        		_obj.val(_settings.selected);
        	}
        	
            if(_settings.onComplete){
            	_settings.onComplete();
            }
            
       	}
	}
	
	function clearFn(target){
		var _settings = $(target).data('fillCombo');
		if (_settings.selected)
			$(target).val(_settings.selected);
		else if (_settings.firstItemValue && _settings.firstItemText)
			$(target).val(_settings.firstItemValue);
		else
			$(target).val($(target).find("option:first").val());
	}
	function checkBaseInformation(settings){
		if (settings.baseInformation){
			settings.url = settings.baseInformationRestUrl + settings.baseInformation;
			settings.values = "topic";
		}
		return settings;
	}
	function createUrl(target){
		var _options = $.extend({}, $.fn.fillCombo.defaults, $.fn.fillCombo.parseOptions(target));
		_options = checkBaseInformation(_options);
		return _options.url;
	}
	function createJsonData(target){
		var _options = $.extend({}, $.fn.fillCombo.defaults, $.fn.fillCombo.parseOptions(target));
		return _options.jsonData;
	}
	
	$.fn.fillCombo = function(options, params){
		
		if (typeof options == 'string'){
			var method = $.fn.fillCombo.methods[options];
			if(method){
				return (method(this, params));
			}
		}
		options = options || {};
		return this.each(function(){
			var state = $(this).data('fillCombo');
			if(state){
				$.extend(state, options);
				create(this);
			}
			else{
				var _options = $.extend({}, $.fn.fillCombo.defaults, $.fn.fillCombo.parseOptions(this));
				$(this).data('fillCombo', _options);
				if(_options.relation){
					if (typeof _options.relation == 'string'){
						$(_options.relation).data('fillCombo', _options);
					}
					else if (typeof _options.relation == 'object'){
	    				$.each(_options.relation, function(i, e){
	    					$(e).data('fillCombo', _options);
						});
					}
				}
				if(_options.fillCombo){
					create(this);
				}
			}
		});
	};
	
	$.fn.fillCombo.methods = {
		options: function(jq){
			return $(jq[0]).data('fillCombo');
		},
		setOptions: function(jq, params){
			var _options = $.fn.fillCombo.methods.options(jq);
			$.extend(_options, params);
		},
		getData: function(jq){
			return $(jq[0]).data('fillComboData').entityList;
		},
		setValue: function(jq, params){
			$(jq).val(params);
		},
		getSelectedValue: function(jq){
			return $(jq).val();
		},
		clear: function(jq){
			clearFn(jq);
		},
		reset: function(jq){
			$.fn.fillCombo.methods.remove(jq);
			var _options = $.fn.fillCombo.methods.options(jq);
			create(jq, _options);
		},
		remove: function(jq){
			$(jq).html('');
		},
		getEntitySelected: function(jq){
			var val = $(jq).val();
			var data = $.fn.fillCombo.methods.getData(jq);
			for (var i = 0 ; i < data.length ; i++){
				if (val == data[i][$.fn.fillCombo.methods.options(jq).itemKey]){
					return data[i];
				}
			}
		}
	};
	
	$.fn.fillCombo.parseOptions = function(target){
		return $.parser.parseOptions(target, [
            'url', 'itemKey', 'values', 'firstItemText', 'firstItemValue', 'separateLabel', 'separateItem', 'baseInformation','filterMode','baseInformationRestUrl'
	    ]);
	};
	
	$.fn.fillCombo.defaults = {
		url: null,
		jsonData: {},
		async: true,
		itemKey: 'id',
		values: null,
		additionalAttr: null,
		firstItemText: '...',
		firstItemValue: -1,
		separateLabel: ' ',
		separateItem: ' - ',
		selected: null,
		onComplete: null,
		entityList: null,
		relation : null,
		fillCombo: true,
		baseInformation: null,
		filterMode:false,
		baseInformationRestUrl:"/amadProject/rest/core/baseInformation/list/"
	};
})(jQuery);
