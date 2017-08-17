function initTooltipUtility(){
	if (typeof $(this).qtip == 'function') {
		$(document).find('[data-qtip*=qtip]').each(function(index, element) {
			$(element).removeData();
			var rulesParsing = $(element).attr('data-qtip');
			var getRules = /qtip\[(.*)\]/.exec(rulesParsing);
			if (!getRules) {
				$(element).qtip({});
			}
			else {
				var str = getRules[1];
				var rules = str.split(/\[|,|\]/);
				var userMy = 'top left', userAt = 'bottom right', userClasses = '', userContent;
				for (var i = 0; i < rules.length; i++) {
					rules[i] = rules[i].replace(' ', '');
					if (rules[i] === '') {
						delete rules[i];
					}
				}
				for (var i = 0; i < rules.length; i++) {
					switch (rules[i]) {
					case 'at':
						userAt = rules[i + 1];
						break;
					case 'my':
						userMy = rules[i + 1];
						break;
					case 'cssClass':
						userClasses = rules[i + 1];
						break;
					case 'content':
						userContent = rules[i + 1];
						break;
					}
				}
				$(element).qtip({
					position : {
						my : userMy,
						at : userAt
					},
					style : {
						classes : userClasses
					},
					content : (userContent || {attr : 'title'})
				});
			}
		});
	}
}