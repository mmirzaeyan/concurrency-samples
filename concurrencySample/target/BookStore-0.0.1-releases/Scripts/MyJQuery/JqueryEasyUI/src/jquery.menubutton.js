/**
 * menubutton - jQuery EasyUI
 * 
 * Copyright (c) 2009-2013 www.jeasyui.com. All rights reserved.
 *
 * Licensed under the GPL or commercial licenses
 * To use it on other terms please contact us: info@jeasyui.com
 * http://www.gnu.org/licenses/gpl.txt
 * http://www.jeasyui.com/license_commercial.php
 * 
 * Dependencies:
 *   linkbutton
 *   menu
 */
(function($){
	
	function init(target){
		var opts = $.data(target, 'menubutton').options;
		var btn = $(target);
		btn.removeClass(opts.cls.btn1+' '+opts.cls.btn2).addClass('m-btn');
		btn.linkbutton($.extend({}, opts, {
			text: opts.text + '<span class="' + opts.cls.arrow + '">&nbsp;</span>'
		}));
		
		if (opts.menu){
			$(opts.menu).menu();
			var mopts = $(opts.menu).menu('options');
			var onShow = mopts.onShow;
			var onHide = mopts.onHide;
			$.extend(mopts, {
				onShow: function(){
					var mopts = $(this).menu('options');
					var btn = $(mopts.alignTo);
					var opts = btn.menubutton('options');
					btn.addClass((opts.plain==true) ? opts.cls.btn2 : opts.cls.btn1);
					onShow.call(this);
				},
				onHide: function(){
					var mopts = $(this).menu('options');
					var btn = $(mopts.alignTo);
					var opts = btn.menubutton('options');
					btn.removeClass((opts.plain==true) ? opts.cls.btn2 : opts.cls.btn1);
					onHide.call(this);
				}
			});
		}
		setDisabled(target, opts.disabled);
	}
	
	function setDisabled(target, disabled){
		var opts = $.data(target, 'menubutton').options;
		opts.disabled = disabled;
		
		var btn = $(target);
		var t = btn.find('.'+opts.cls.trigger);
		if (!t.length){t = btn}
		t.unbind('.menubutton');
		if (disabled){
			btn.linkbutton('disable');
		} else {
			btn.linkbutton('enable');
			
			var timeout = null;
			t.bind('click.menubutton', function(){
				showMenu(target);
				return false;
			}).bind('mouseenter.menubutton', function(){
				timeout = setTimeout(function(){
					showMenu(target);
				}, opts.duration);
				return false;
			}).bind('mouseleave.menubutton', function(){
				if (timeout){
					clearTimeout(timeout);
				}
			});
		}
	}
	
	function showMenu(target){
		var opts = $.data(target, 'menubutton').options;
		if (opts.disabled || !opts.menu){return}
		$('body>div.menu-top').menu('hide');
		var btn = $(target);
		var mm = $(opts.menu);
		if (mm.length){
			mm.menu('options').alignTo = btn;
			mm.menu('show', {alignTo:btn});
		}
		btn.blur();
	}
	
	$.fn.menubutton = function(options, param){
		if (typeof options == 'string'){
			var method = $.fn.menubutton.methods[options];
			if (method){
				return method(this, param);
			} else {
				return this.linkbutton(options, param);
			}
		}
		
		options = options || {};
		return this.each(function(){
			var state = $.data(this, 'menubutton');
			if (state){
				$.extend(state.options, options);
			} else {
				$.data(this, 'menubutton', {
					options: $.extend({}, $.fn.menubutton.defaults, $.fn.menubutton.parseOptions(this), options)
				});
				$(this).removeAttr('disabled');
			}
			
			init(this);
		});
	};
	
	$.fn.menubutton.methods = {
		options: function(jq){
			var bopts = jq.linkbutton('options');
			var mopts = $.data(jq[0], 'menubutton').options;
			mopts.toggle = bopts.toggle;
			mopts.selected = bopts.selected;
			return mopts;
		},
		enable: function(jq){
			return jq.each(function(){
				setDisabled(this, false);
			});
		},
		disable: function(jq){
			return jq.each(function(){
				setDisabled(this, true);
			});
		},
		destroy: function(jq){
			return jq.each(function(){
				var opts = $(this).menubutton('options');
				if (opts.menu){
					$(opts.menu).menu('destroy');
				}
				$(this).remove();
			});
		}
	};
	
	$.fn.menubutton.parseOptions = function(target){
		var t = $(target);
		return $.extend({}, $.fn.linkbutton.parseOptions(target), 
				$.parser.parseOptions(target, ['menu',{plain:'boolean',duration:'number'}]));
	};
	
	$.fn.menubutton.defaults = $.extend({}, $.fn.linkbutton.defaults, {
		plain: true,
		menu: null,
		duration: 100,
		cls: {
			btn1: 'm-btn-active',
			btn2: 'm-btn-plain-active',
			arrow: 'm-btn-downarrow',
			trigger: 'm-btn'
		}
	});
})(jQuery);
