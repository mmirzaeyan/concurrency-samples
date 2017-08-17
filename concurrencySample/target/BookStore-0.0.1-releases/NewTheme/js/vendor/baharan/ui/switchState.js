(function($){
	function create(target,options){
		var _settings = options || $(target).data('switchStateOptions');
		var id=$('#id').val();
		$(target).on('click',function(){
			if(_settings.from&&_settings.to){
				$('#'+_settings.from).slideToggle(500);
				$('#'+_settings.to).slideToggle(500);
				if(_settings.switchMode && _settings.switchMode=='edit'){
					if(id && id >0){
						$('#'+_settings.formId).form('showSelected', id);
					}else{
						$('#'+_settings.formId).form('clear');
					}
				}else if(_settings.switchMode && _settings.switchMode =='grid'){
					$('#'+_settings.gridId).grid('fillTable');
				}
				if(_settings.callback){
					_settings.callback();
				}
			}
		});
	}
	function switching(target,params){
		var _settings = $(target).data('switchStateOptions');
		if(_settings.from&&_settings.to){
			$('#'+_settings.from).slideToggle(500);
			$('#'+_settings.to).slideToggle(500);
			if(params.switchMode && params.switchMode=='edit'){
				if(params.id && params.id >0){
					$('#'+_settings.formId).form('showSelected', params.id);
				}else{
					$('#'+_settings.formId).form('clear');
				}
			}else if(params.switchMode && params.switchMode =='grid'){
				$('#'+_settings.gridId).grid('fillTable');
			}
			if(params.callback){
				params.callback();
			}else if(_settings.callback){
				_settings.callback();
			}
		}
	}
	$.fn.switchState =function(options,params){
		if(typeof options == 'string'){
			var method=$.fn.switchState.methods[options];
			if(method){
				return (method(this,params));
			}
		}
		options = options || {};
		return this.each(function(){
			var state = $(this).data('switchStateOptions');
			if(state){
				$.extend(state, options);
				create(this);
			}
			else{
				var _options= $.extend({}, $.fn.switchState.defaults, $.fn.switchState.parseOptions(this));
				$(this).data('switchStateOptions',_options);
				create(this);
			}
		});
	};
	$.fn.switchState.methods = {
		options:function(jq){
			return $(jq[0]).data("switchStateOptions");
		},
		switching: function(jq,params){
			return switching(jq,params);
		},
	};
	$.fn.switchState.parseOptions = function(target){
		return $.parser.parseOptions(target,['from','to']);
	};
	$.fn.switchState.defaults={
		from:null,
		to:null,
		callback:null,
		effect:'blind',
		switchMode:null,
		formId:'FormMain',
		gridId:'grid'
	};
})(jQuery);