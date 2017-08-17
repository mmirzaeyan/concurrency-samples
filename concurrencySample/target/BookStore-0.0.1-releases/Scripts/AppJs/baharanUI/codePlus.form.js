(function($) {

	function setEntity(form) {
		var formId = "";
		var entity = {};
		if (form)
			formId = '#' + form;

		$(formId + ' [data-bind]').each(function(index, element) {
			var _name = $(element).attr('data-bind');
			var _type = $(element).prop('type');
			switch (_type) {
			case 'text':
			case 'textarea':
			default:
				entity[_name] = removeMoneyFormat(element);
				break;
			case 'radio':
				if ($(element).prop('checked')) {
					entity[_name] = $(element).val();
				}
				break;
			case 'checkbox':
				if ($(formId + ' [data-bind=' + _name + ']').length == 1) {
					entity[_name] = $(element).prop('checked');
				} else {
					entity[_name] = new Array();
					$.each($(formId + ' [data-bind=' + _name + ']'), function(index, element) {
						if ($(element).prop('checked')) {
							entity[_name].push($(element).val());
						}
					});
				}
				break;
			}
		});
		return entity;
	}

	function setInput(entity, form) {
		var formId = "";
		if (form)
			formId = '#' + form;

		if (!entity)
			return;

		$(formId + ' [data-bind]').each(function(index, element) {
			var _name = $(element).attr('data-bind');
			var _type = $(element).prop('type');
			switch (_type) {
			case 'text':
			case 'textarea':
			case 'hidden':
			case 'number':
				if ($(element).hasClass("moneySeprator")) {
					$(element).val(toMoneyFormat(entity[_name]));
				} else if (entity[_name] != null) {
					$(element).val(entity[_name].toString());
				}
				break;
			case 'select-one':	
				if ($(element).hasClass("filterMode") && typeof $(element).chosen =='function') {
					$(element).val(entity[_name]).trigger("chosen:updated");
				} else {
					if (entity[_name]!=null)
							$(element).val(entity[_name].toString());	
				}
				break;
			case 'radio':
				if (entity[_name] != null && $(element).val() == entity[_name].toString()) {
					$(element).prop('checked', true);
				}
				break;
			case 'checkbox':
				if ($(formId + ' [data-bind=' + _name + ']').length == 1) {
					$(element).prop('checked', entity[_name]);
				} else {
					if ($.inArray($(element).val(), entity[_name]) != -1) {
						$(element).prop('checked', true);
					} else {
						$(element).prop('checked', false);
					}
				}
				break;
			default:
				if (entity[_name] != null) {
					$(element).html(entity[_name]);
				}
				break;
			}
		});
		return entity;
	}

	function clearForm(form, target) {
		var formId = "";
		if (form)
			formId = '#' + form;

		$(formId + ' [data-bind]').each(function(index, element) {
			var _type = $(element).prop('type');
			switch (_type) {
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
				if ($(element).attr('data-default') == 'checked')
					$(element).prop('checked', true);
				else
					$(element).prop('checked', false);
				break;
			}
		});
		$(formId).validationEngine('hide');

		if (target) {
			var _settings = $(target).data('formOptions') || $.extend({}, $.fn.form.defaults, $.fn.form.parseOptions(target));
			if (_settings.onClearComplete)	{
				_settings.onClearComplete();
			}
		}
		
	}

	function save(target) {
		var _settings = $(target).data('formOptions') || $.extend({}, $.fn.form.defaults, $.fn.form.parseOptions(target));
		if (_settings.validate) {
			if (typeof (_settings.validate) == "boolean" && $.validationEngine) {
				if (!$(target).validationEngine('validate'))
					return;
			} else if (typeof (_settings.validate) == "function") {
				var res = _settings.validate();
				if (!res)
					return;
			}
		}
		var entity = setEntity($(target).attr('id'));
		if (_settings.beforeSave) {
			var result = _settings.beforeSave(entity);
			if (typeof result == 'boolean' && !result) {
				return false;
			} else {
				entity = result;
			}
		}
		Loader(true);
		req = $.ajax({
			url : createUrl(target) + createSaveUrl(target),
			type : 'POST',
			dataType : 'json',
			async: _settings.async, 
			contentType : 'application/json',
			data : JSON.stringify(entity),
			success : function(res) {
				if (_settings.onSaveComplete) {
					_settings.onSaveComplete(res);
				} else {
					if (res > 0) {
						showMessage(_settings.msg.SaveSuccess);
						$('#id').val(res);
					} else {
						showMessage(_settings.msg.SaveError);
					}
				}
				$(target).validationEngine('hide');
				Loader(false);
			}
		}).promise();

		req.fail(function() {
			if (_settings.onSaveError) {
				_settings.onSaveError();
			}
			Loader(false);
		});
	}

	function load(target, id) {
		if (id < 0)
			return;
		var _settings = $(target).data('formOptions') || $.extend({}, $.fn.form.defaults, $.fn.form.parseOptions(target));
		clearForm($(target).attr('id'), target);
		if (_settings.beforeLoad)
			_settings.beforeLoad();
		Loader(true);
		req = $.ajax({
			url : createUrl(target) + createLoadUrl(target) + "/" + id,
			type : 'GET',
			dataType : 'json',
			contentType : 'application/json',
			success : function(res) {
				if (_settings.onLoadComplete) {
					_settings.onLoadComplete(res);
				} else {
					if (res)
						setInput(res, $(target).attr('id'));
				}
				Loader(false);
			}
		}).promise();

		req.fail(function() {
			if (_settings.onLoadError) {
				_settings.onLoadError();
			}
			Loader(false);
		});
	}

	function deleteEntity(target, id) {
		var _settings = $(target).data('formOptions') || $.extend({}, $.fn.form.defaults, $.fn.form.parseOptions(target));
		if (confirm(_settings.msg.DeleteConfirm)) {
			if (_settings.beforeDelete){
				var _result = _settings.beforeDelete(id);
				if (typeof _result == 'boolean' && !_result){
					return false;
				}
			}
			Loader(true);
			req = $.ajax({
				type : "DELETE",
				url : createUrl(target) + createDeleteUrl(target) + "/" + id,
				contentType : "application/json",
				success : function(res) {
					if (_settings.onDeleteComplete) {
						_settings.onDeleteComplete(res);
					} else {
						if (!res) {
							showMessage(_settings.msg.DeleteError);
							if ($(target).find('[data-component=grid]')) { // برای
																			// ریست
																			// کردن
																			// گرید
																			// داخل
																			// فرم
																			// بعد
																			// از
																			// حذف
								$(target).find('[data-component=grid]').each(function() {
									$(this).grid('fillTable');
								});
							}
						}
					}
					Loader(false);
				}
			}).promise();
			req.fail(function() {
				if (_settings.onDeleteError) {
					_settings.onDeleteError();
				}
				Loader(false);
			});
		};

	}

	function toMoneyFormat(number) {
		number += '';
		temp = '';
		// seprate numebrs and strings
		for ( var i = 0; i <= (number.length - 1); i++) {
			if ((number[i] >= '0' && number[i] <= '9') || number[i] == ',' || number[i] == '.')
				temp += number[i];
		}
		// remove the existing ,+
		try {
			var regex = /,/g;
			temp = temp.replace(regex, '');
		} catch (e) {
		}
		// force it to be a string
		temp += '';
		// split it into 2 parts (for numbers with decimals, ex: 125.05125)
		var x = temp.split('.');
		var p1 = x[0];
		var p2 = x.length > 1 ? '.' + x[1] : '';
		// match groups of 3 numbers (0-9) and add , between them
		regex = /(\d+)(\d{3})/;
		while (regex.test(p1)) {
			p1 = p1.replace(regex, '$1' + ',' + '$2');
		}
		// join the 2 parts and return the formatted number
		return p1 + p2;
	}

	function removeMoneyFormat(element) {
		try {
			if($(element).hasClass("moneySeprator")){
				return $(element).val().replace(new RegExp(',', 'g'), '');
			}else{
				return $(element).val();
			}
		} catch (e) {
			return $(element).val();
		}
	}

	function showCurrentGridId(target, id) {
		$(target).form('clear');
		if (typeof showElements == 'function')
			showElements(new Array('edit_form'));
		$(target).form('load', id);
	}

	function findGridElement(target) {
		var id = getSelectedId(target);
		if (id > 0) {
			showCurrentGridId(target, id);
		}
	}
	function getSelectedId(target) {
		if ($('[data-component=grid]').find('[name=selectedItem]:checked').attr('id')) {
			return $('[data-component=grid]').find('[name=selectedItem]:checked').attr('id').substring(14);
		} else {
			showMessage($.fn.form.methods.options(target).msg.NotFoundData);
		}

	}
	function deleteGridElement(target) {
		var id = getSelectedId(target);
		if (id > 0) {
			$(target).form('deleteEntity', id);
		}
	}

	function createFunctions(targetId) {
		$('#' + targetId + ' .saveForm').each(function(index, element) {
			$(this).attr('onclick', '$(\'#' + targetId + '\').form(\'save\')');
		});
		$('#' + targetId + ' .clearForm').each(function(index, element) {
			$(this).attr('onclick', '$(\'#' + targetId + '\').form(\'clear\')');
		});
		$('.showSelected').attr('onclick', '$(\'#' + targetId + '\').form(\'findGridElement\')');
		$('.deleteSelected').attr('onclick', '$(\'#' + targetId + '\').form(\'deleteSelected\')');
	}

	function createUrl(target) {
		var _options = $.extend({}, $.fn.form.defaults, $.fn.form.parseOptions(target));
		return _options.url;
	}
	function createSaveUrl(target) {
		var _options = $.extend({}, $.fn.form.defaults, $.fn.form.parseOptions(target));
		return _options.saveUrl;
	}
	function createLoadUrl(target) {
		var _options = $.extend({}, $.fn.form.defaults, $.fn.form.parseOptions(target));
		return _options.loadUrl;
	}
	function createDeleteUrl(target) {
		var _options = $.extend({}, $.fn.form.defaults, $.fn.form.parseOptions(target));
		return _options.deleteUrl;
	}

	$.fn.form = function(options, params) {
		if (typeof options == 'string') {
			var method = $.fn.form.methods[options];
			if (method) {
				return (method(this, params));
			}
		}
		options = options || {};
		return this.each(function() {
			var state = $(this).data('formOptions');
			if (state) {
				$.extend(state.options, options);
			} else {
				$(this).data('formOptions', $.extend({}, $.fn.form.defaults, $.fn.form.parseOptions(this)));
				createFunctions($(this).attr('id'));
			}
		});
	};

	$.fn.form.methods = {
		options : function(jq) {
			return $(jq[0]).data('formOptions');
		},
		clear : function(jq) {
			clearForm($(jq[0]).attr('id'), jq);
		},
		save : function(jq) {
			save(jq);
		},
		load : function(jq, params) {
			load(jq, params);
		},
		deleteEntity : function(jq, params) {
			deleteEntity(jq, params);
		},
		getEntity : function(jq) {
			return setEntity($(jq[0]).attr('id'));
		},
		setEntity : function(jq, params) {
			setInput(params, $(jq[0]).attr('id'));
		},
		findGridElement : function(target) {
			findGridElement(target);
		},
		deleteSelected : function(target) {
			deleteGridElement(target);
		},
		showSelected : function(target, params) {
			showCurrentGridId(target, params);
		},
		getSelectedId : function(target) {
			return getSelectedId(target);
		},
		disabled : function(target) {
			$(target).find('[data-bind]').each(function() {
				$(this).prop('disabled', true);
			});
		},
		enable : function(target) {
			$(target).find('[data-bind]').each(function() {
				$(this).prop('disabled', false);
			});
		}
	};

	$.fn.form.parseOptions = function(target) {
		return $.parser.parseOptions(target, [ 'url', 'saveUrl', 'loadUrl', 'deleteUrl' ]);
	};

	$.fn.form.defaults = {
		url : null,
		saveUrl : '/save',
		loadUrl : '/load',
		deleteUrl : '/delete',
		beforeSave : null,
		beforeLoad : null,
		beforeDelete : null,
		onSaveComplete : null,
		onLoadComplete : null,
		onDeleteComplete : null,
		onClearComplete: null,
		onSaveError : null,
		onLoadError : null,
		onDeleteError : null,
		validate : true,
		async: true,
		msg : {
			NotFoundData : "موردی یافت نشد",
			SaveSuccess : 'ثبت اطلاعات با موفقیت انجام شد',
			SaveError : 'ثبت اطلاعات با خطا مواجه شد',
			DeleteError : 'حذف اطلاعات با خطا مواجه شد',
			DeleteConfirm : 'آیا از حذف اطلاعات اطمینان دارید؟'
		}
	};
})(jQuery);
