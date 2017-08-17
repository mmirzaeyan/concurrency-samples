
function baseSetInputByEntity(entity,form) {
	var formId = "";
		if (form)
			formId = '#' + form;

		if (!entity)
			return;
		for (prop in entity) {
			var _name ="";
			element = $( formId + "[name=" + prop + "]," + formId + " [id=" + prop + "]," + formId + " [data-bind=" + prop + "]");

			var _type = $(element).prop('type');
			switch (_type) {
			case 'text':
			case 'textarea':
			case 'hidden':
			case 'number':
				if ($(element).hasClass("moneySeprator")) {
					$(element).val(toMoneyFormat(entity[prop]));
				}
				else {
					$(element).val(entity[prop]);
				}
				break;
			case 'select-one':	
				if ($(element).hasClass("filterMode") && typeof $(element).chosen =='function') {
					$(element).val(entity[prop]).trigger("chosen:updated");
				}
				else {
					$(element).val(entity[prop]);
				}
				break;
			case 'radio':
				if (entity[prop] != null && $(element).val() == entity[prop].toString()) {
					$(element).prop('checked', true);
				}
				break;
			case 'checkbox':
				if ($(formId + ' [data-bind=' + prop + ']').length == 1) {
					$(element).prop('checked', entity[prop]);
				}
				else {
					if ($.inArray($(element).val(), entity[prop]) != -1) {
						$(element).prop('checked', true);
					}
					else {
						$(element).prop('checked', false);
					}
				}
				break;
			default:
				if (entity[prop] != null) {
					$(element).html(entity[prop]);
				}
				break;
			}
		}
		return entity;
}

function baseSetEntityFromInput(entity,formId) {
	if(formId!=null && formId!="") {
	    for (prop in entity) {
	    	try {
		    	if($('#'+formId).find("[data-bind=" + prop + "]") != null && $('#'+formId).find("[data-bind=" + prop + "]").val() != null)
		    		entity[prop] = $('#'+formId).find("[data-bind=" + prop + "]").val();
	    	}
	    	catch(e) {
	    		alert(e);
	    	}
	    }
	}
	else {
		var classSep = "";
	    for (prop in entity) {
	    	try {
		    	if($("[name=" + prop + "], [id=" + prop + "], [data-bind=" + prop + "]") != null && $("[name=" + prop + "], [id=" + prop + "], [data-bind=" + prop + "]").val() !=null) {
			    	if( $("[name=" + prop + "], [id=" + prop + "], [data-bind=" + prop + "]").attr( 'class' ) != undefined && $("[name=" + prop + "], [id=" + prop + "], [data-bind=" + prop + "]").attr( 'class' )!= null)
			    		classSep = $("[name=" + prop + "], [id=" + prop + "], [data-bind=" + prop + "]").attr( 'class' );
				    if(classSep.search("moneySeprator") >= 0)
				    	entity[prop] = removeMoneyFormat($("[name=" + prop + "], [id=" + prop + "], [data-bind=" + prop + "]").val());
				    else
				    	entity[prop] = $("[name=" + prop + "], [id=" + prop + "], [data-bind=" + prop + "]").val();
		    	}
	    	}
	    	catch(e) {
	    		alert(e);
	    	}
	    	classSep = "";
	    }
	}
}

function getSearchFilter() {
	//$$,$$e.ozviat$$1$$1$$,$$
	txt = "$$,$$";
	$(".search").each(function() {
		var temp = $(this).attr("searchProperty");
		if (temp !== null) {
			temp2 = temp;
			if (typeof $(this).val() != 'undefined' && $(this).val() != null && $(this).val() != "" && $(this).val() != "-1" ) {
				temp2 += "$$"+ $(this).val();
			}
			else
				return true;
			temp3 = "";
			temp3 = $(".search2").filter("[searchProperty=\'" + temp + "\']");
			if (typeof temp3.val() != 'undefined') {
				if(temp3.val() != "")
					temp2 += "@@" + temp3.val() + "$$";
				else
					return true;
			}
			else
				temp2 += "$$";
			temp2 += $(".searchPattern").filter("[searchProperty=\'" + temp + "\']").val() + "$$,$$";
			
			if(temp2 != "$$$$$$,$$")
				txt += temp2;
		}
	});
	if(txt == "$$,$$") txt="";
	
	return txt;
}

function clearFilter() {
	$(".search").val("");
}
