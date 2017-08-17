(function ($){
	function create(target, _opts){
		var _settings = _opts || $.data(target, 'comboOptions');
		if(_settings.firstItemValue && _settings.firstItemText){
			$(target).append($("<option />").val(_settings.firstItemValue).text(_settings.firstItemText));
		}
		for(var i = _settings.from ; i <= _settings.to ; i+=_settings.step){
			$(target).append($("<option />").val(i).text(i));
		}
		if(_settings.selected){
			$(target).val(_settings.selected);
		}
	}
	
	function clearFn(target){
		var _settings = $(target).data('comboOptions');
		if (_settings.selected)
			$(target).val(_settings.selected);
		else if (_settings.firstItemValue && _settings.firstItemText)
			$(target).val(_settings.firstItemValue);
		else
			$(target).val($(target).find("option:first").val());
	}
	
	$.fn.comboSeries = function(options, params){
		
		if (typeof options == 'string'){
			var method = $.fn.comboSeries.methods[options];
			if(method){
				return (method(this, params));
			}
		}
		options = options || {};
		return this.each(function(){
			var state = $(this).data('comboOptions');
			if(state){
				$.extend(state, options);
				create(this);
			}
			else{
				$(this).data('comboOptions', $.extend({}, $.fn.comboSeries.defaults, $.fn.comboSeries.parseOptions(this)) );
				create(this);
			}
		});
	};
	
	$.fn.comboSeries.methods = {
		options: function(jq){
			return $(jq[0]).data('comboOptions');
		},
		setOptions: function(jq, params){
			var _options = $.fn.comboSeries.methods.options(jq);
			$.extend(_options, params);
		},
		getSelectedValue: function(jq){
			return $(jq).val();
		},
		setValue: function(jq, params){
			$(jq).val(params);
		},
		clear: function(jq){
			clearFn(jq);
		},
		reset: function(jq){
			$(jq).html('');
			var _options = $.fn.comboSeries.methods.options(jq);
			create(jq, _options);
		}
		
	};
	
	$.fn.comboSeries.parseOptions = function(target){
		return $.parser.parseOptions(target, [
            'firstItemText', 'firstItemValue'
	    ]);
	};
	
	$.fn.comboSeries.defaults = {
		from: 1357,
		to: 1404,
		firstItemText: '...',
		firstItemValue: -1,
		selected: null,
		step: 1
	};
})(jQuery);
