(function ($) {
	
	function extractProperties(input){
		var props = new Array();
		var stringTemp = input;
		while (stringTemp.indexOf("{") > -1){
		  var prop = stringTemp.substring(stringTemp.indexOf("{") + 1, stringTemp.indexOf("}"));
		  stringTemp = stringTemp.replace("{" + prop + "}", "");
		  props.push(prop);
		}
		return props;
	}
	
	function create(target, opts) {
		var _settings = $(target).data('autoCompleteOptions') || $.extend({}, $.fn.autoComplete.defaults, $.fn.autoComplete.parseOptions(target));

		$(target).autocomplete({ 
	 		position: { my : "right top", at: "right bottom" },
	        source: function(req, resp) {
				var jsonReq = { search : req.term , resultCount: _settings.resultCount };
				$.extend(jsonReq, _settings.data);
				$.getJSON(_settings.url, jsonReq, function(data) {
	            	resp($.map( data, function(entity) {
	            			var label = _settings.label;
	            			if (label.indexOf("{") < 0){
	            				label = "{" + label + "}";
	            			}
	            			var props = extractProperties(label);
	            			for (var i = 0; i < props.length; i++){
	            				label = label.replace("{" + props[i] + "}", entity[props[i]]);
	            			}
							return {
								label: label,
								data : entity
							};
						}));
		            });
				},  
			select: function(event, ui) {
				$(event.target).val(ui.item.label);
				if (_settings.keyTarget) {
	 				$("#" + _settings.keyTarget).val(ui.item.data[_settings.key]);
	 			}
				if (_settings.onSelect) {
	 				_settings.onSelect(ui.item.data);
	 			}
				return false;
			},
			minLength: _settings.minLength  
	     });
	}
	
	$.fn.autoComplete = function(options, params) {
		if (typeof options == 'string') {
			var method = $.fn.autoComplete.methods[options];
			if(method) {
				return (method(this, params));
			}
		}
		options = options || {};
		return this.each(function() {
			var state = $(this).data('autoCompleteOptions');
			if(state) {
				$.extend(state, options);
				create(this);
			}
			else {
				$(this).data('autoCompleteOptions', $.extend({}, $.fn.autoComplete.defaults, $.fn.autoComplete.parseOptions(this)));
				create(this);
			}
		});
	};
	
	$.fn.autoComplete.methods = {
		options: function(jq) {
			return $(jq[0]).data('autoCompleteOptions');
		},
		setOptions: function(jq, params) {
			var _options = $.fn.autoComplete.methods.options(jq);
			$.extend(_options, params);
		},
		clear: function(jq) {
			$(jq).val('');
			var _settings = $.fn.autoComplete.methods.options(jq);
			if (_settings.keyTarget) {
 				$("#" + _settings.keyTarget).val(ui.item.data[_settings.key]);
 			}
		},
		reset: function(jq) {
			var _options = $.fn.autoComplete.methods.options(jq);
			create(jq, _options);
		}
	};
	
	$.fn.autoComplete.parseOptions = function(target) {
		return $.parser.parseOptions(target, [
            'url', 'key', 'label', 'keyTarget'
	    ]);
	};
	
	$.fn.autoComplete.defaults = {
		url: 			null,
		data: 			null,
		resultCount: 	10,
		keyTarget:		null,
		key: 			"id",
		label:			"title",
		minLength:		3,
		onSelect: 		null
	};
})(jQuery);
