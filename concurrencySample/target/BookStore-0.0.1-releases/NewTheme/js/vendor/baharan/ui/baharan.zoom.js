(function ($) {
	
	function create(target, opts) {
		var _settings = $(target).data('zoomOptions') || $.extend({}, $.fn.zoom.defaults, $.fn.zoom.parseOptions(target));

		$(target).bind('click', function(i, e) {
			var options = $(this).attr('data-zoom');
			if (!_settings.src) {
				_settings.src = $(target).attr("src");
			}
			$.fancybox({
				fitToView: 	false,
				width: 		_settings.width,
				height:		_settings.height,
				autoSize: 	false,
				closeClick: false,
				openEffect:	'none',
				closeEffect:'none',
				type: 		'inline',
				href:		_settings.src
			});
		});
		
	}
	
	$.fn.zoom = function(options, params) {
		if (typeof options == 'string') {
			var method = $.fn.zoom.methods[options];
			if(method) {
				return (method(this, params));
			}
		}
		options = options || {};
		return this.each(function() {
			var state = $(this).data('zoomOptions');
			if(state) {
				$.extend(state, options);
				create(this);
			}
			else {
				$(this).data('zoomOptions', $.extend({}, $.fn.zoom.defaults, $.fn.zoom.parseOptions(this)));
				create(this);
			}
		});
	};
	
	$.fn.zoom.methods = {
		options: function(jq) {
			return $(jq[0]).data('zoomOptions');
		},
		setOptions: function(jq, params) {
			var _options = $.fn.zoom.methods.options(jq);
			$.extend(_options, params);
		},
		clear: function(jq) {
			clearFn(jq);
		},
		reset: function(jq) {
			var _options = $.fn.zoom.methods.options(jq);
			create(jq, _options);
		}
	};
	
	$.fn.zoom.parseOptions = function(target) {
		return $.parser.parseOptions(target, [
            'src',
	    ]);
	};
	
	$.fn.zoom.defaults = {
		src: null,
		width: '100%',
		height: '100%'
	};
})(jQuery);
