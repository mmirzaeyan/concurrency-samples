function initCalendarUtility(){
	if (typeof $('[class*=persianCalender]').datepicker == 'function'){
		setCalenderClass();
	}
	
	if(typeof getDatePersian == 'function'){
		$(".defaultDate").val(getToday());
	}

	$('[class*=persianCalender]').live("keydown", 	function(e){
		var keycode;
		if (window.event)
			keycode = window.event.keyCode;
		else if (e)
			keycode = e.which;

		if (keycode == 8 || keycode == 46)
			$(this).val('');
	});
}

function setCalenderClass() {
	$(document).find("[class*=persianCalender][type=text]").each(function(index, element) {
		var rulesParsing = $(this).attr('class');
		var getRules = /persianCalender\[(.*)\]/.exec(rulesParsing);
		if (!getRules) {
			$(this).datepicker({ dateFormat: 'yy/mm/dd', showButtonPanel: true, changeMonth: true, changeYear: true, duration: "slow", yearRange: "1357:1404", showAnim: "show" });
			return;
		}
		var str = getRules[1];
		var rules = str.split(/\[|,|\]/);
		
		$(this).datepicker({dateFormat: 'yy/mm/dd', showButtonPanel: true, changeMonth: true, changeYear: true, duration: "slow", showAnim: "show"});
		var option;
		
		for (var i = 0; i < rules.length; i++) {
			option = rules[i].split('=');
			switch (option[0]) {
				case "maxDate":
					if (option[1] == "0")
						$(this).datepicker('option', 'maxDate', "+0");
					else if (option[1].length == 4)
						$(this).datepicker('option', 'maxDate', option[1] + "/01/01");
					else
						$(this).datepicker('option', 'maxDate', option[1]);
					break;
				case "minDate":
					if (option[1] == "0")
						$(this).datepicker('option', 'minDate', "+0");
					else if (option[1].length == 4)
						$(this).datepicker('option', 'minDate', option[1] + "/01/01");
					else
						$(this).datepicker('option', 'minDate', option[1]);
					break;
				default:
					break;
			}
		}
	});
}