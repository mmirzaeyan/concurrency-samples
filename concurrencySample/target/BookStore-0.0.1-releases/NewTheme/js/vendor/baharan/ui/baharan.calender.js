(function ($){
	function create(target, _opts){
		var _settings = _opts || $(target).data('calenderOptions');
		
		$(target).datepicker('destroy');
		$(target).prop('readonly', _settings.readonly);
		
		
		$(target).datepicker({dateFormat: 'yy/mm/dd',showButtonPanel: true ,changeMonth: true,changeYear: true,duration: "slow",showAnim: "show", regional: ''});

		if (_settings.lang)
			$(target).datepicker('option', $.datepicker.regional[ _settings.lang ] );
		
		if (_settings.maxDate)
			$(target).datepicker('option', 'maxDate', _settings.maxDate);
		
		if (_settings.minDate)
			$(target).datepicker('option', 'minDate', _settings.minDate);
	}
	
	$.fn.calender = function(options, params){
		if (typeof options == 'string'){
			var method = $.fn.calender.methods[options];
			if(method){
				return (method(this, params));
			}
		}
		options = options || {};
		return this.each(function(){
			var state = $(this).data('calenderOptions');
			if(state){
				$.extend(state, options);
				create(this);
			}
			else{
				$(this).data('calenderOptions', $.extend({}, $.fn.calender.defaults, $.fn.calender.parseOptions(this)) );
				create(this);
			}
		});
	};
	
	$.fn.calender.methods = {
		options: function(jq){
			return $(jq[0]).data('calenderOptions');
		},
		setOptions: function(jq, params){
			var _options = $.fn.calender.methods.options(jq);
			$.extend(_options, params);
		},
		getValue: function(jq){
			return $(jq).val();
		},
		setValue: function(jq, params){
			$(jq).val(params);
		},
		clear: function(jq){
			$(jq).val('');
		},
		reset: function(jq){
			$(jq).datepicker('destroy');
			var _options = $.fn.calender.methods.options(jq);
			create(jq, _options);
		}
		
	};
	
	$.fn.calender.parseOptions = function(target){
		return $.parser.parseOptions(target);
	};
	
	$.fn.calender.defaults = {
		lang: 'fa',
		maxDate: null,
		minDate: null,
		readonly: true
	};
})(jQuery);
