$(function () { 
	initComboUtility();
	initCalendarUtility();
	initKeyUtility();
	initTooltipUtility();
});

function initBaharan(){
	//initComboUtility();
	initCalendarUtility();
	initKeyUtility();
	initTooltipUtility();
}
function initBaharanUI(){}

function Loader(isFade) {
    if (isFade) {
	    $('#progressBackgroundFilter').fadeIn();
	    $('#loadingbox').fadeIn();
	    $('#Loader').fadeIn();
	    if ($('#FormMain').length > 0)
	    	$("#FormMain").mask("در حــال اجـــرای عملیات......");
	    else
	        $("body").mask("در حــال اجـــرای عملیات......");
	}
	else {
		$('#progressBackgroundFilter').fadeOut(1000);
		$('#loadingbox').fadeOut(1000);
		$('#Loader').fadeOut(1000);
	    if ($('#FormMain').length > 0)
	    	$("#FormMain").unmask();
	    else
	    	$("body").unmask();
	}
}

function goToLoginPage() {
	window.parent.location = coreUrl.projectUrl;
}

function pageLoad() {
    pageNo = 0;
    showElements(new Array('table_content'));
    init();
}

//Will Change This solution in future using jquery selector by class
var ids = new Array('table_content', 'edit_form', 'search_form', 'wait', 'parentTitle','batch_form');
function showElements(showIds) {
    for (var i = 0; i < ids.length; i++) {
        if ($('#' + ids[i]))
            $('#' + ids[i]).css('display', 'none');
    }

    for (i = 0; i < showIds.length; i++) {
        if ($('#' + showIds[i]))
            $('#' + showIds[i]).css('display', 'block');
    }
}

function openWindow(winId, title, url, w, h, isMaximize, isModal) {
	if(winId == 0)
		winId = new Date().getTime();
	window.parent.openWindow(winId+new Date().getTime(), title, url, w, h, isMaximize, isModal ? isModal : false);
}

function closeWindow(winId) {
	window.parent.closeWindow(winId);
}

function showMessage(msg, delay) {
    if (parent != this)
        parent.showMessage(msg, delay);
}

function showFilter() {
    showElements(new Array('search_form'));
}

function delFilter() {
    clearFilter();
    init();
}

function getAuthenticatedUser() {
	var url = coreUrl.projectUrl + "rest/security/user/authenitacedUser";
	var authenticatedUser = {};
	$.ajax({
		type:			"GET",
		url: 			url,
		contentType:	"application/json;",
		dataType:		"json",
		async:			false,
		success:		function (entities) {
			authenticatedUser = entities;
		}
    });
	return authenticatedUser;
}


function viewFancyBoxInline(url, width, height, cancleCallback) {
	$.fancybox({
		fitToView:	false,
		width: 		width,
		height:		height,
		autoSize: 	false,
		closeClick: false,
		openEffect:	'none',
		closeEffect:'none',
		type: 		'inline',
		href:		url
	});
}


function viewFancyBox(url, width, height, beforeCloseAction,afterCloseFunction) {
	$.fancybox({
		fitToView:	false,
		width:		width,
		height:		height,
		autoSize:	false,
		closeClick:	false,
		beforeClose:function() {
						if(beforeCloseAction !=null && typeof beforeCloseAction=='function')
							beforeCloseAction();
					},
		afterClose : function() {
						if(afterCloseFunction !=null && typeof afterCloseFunction=='function')
							afterCloseFunction();
				},
		openEffect: 'none',
		closeEffect:'none',
		type: 		'iframe',
		href:		url,
		onCancel:	function() {
						if(cancleCallback !=null && typeof cancleCallback=='function')
							cancleCallback();
					}
		
		
	});
}



function setSeperateItemInGrid(gridId) {
 	$('#' + gridId + ' .money ').each(function() {
 	 	 $(this).html(toMoneyFormat($(this).html()));
 	 	 $(this).val(toMoneyFormat($(this).val()));
	});
}

function getTreeAttrValueByItemId(attrName, itemId, xmlData) {
	var  xmlDoc = $.parseXML(xmlData);
	var attrValue = $(xmlDoc).find('item').filter(	function(index) {
														return $(this).attr("id") == itemId;
													}).attr(attrName);
    return attrValue;
}

function checkStrength(password) {
	//initial strength
    var strength = 0;
    //if the password length is less than 6, return message.
    if(password.length == 0)
    	return '';
    if (password.length < 6) { 
		$('#result').attr('strongth', 'veryWeak');
		return 'خيلي ضعيف';
	}
    
    //length is ok, lets continue.
	
	//if length is 8 characters or more, increase strength value
	if (password.length > 7)
		strength += 1;
	
	//if password contains both lower and uppercase characters, increase strength value
	if (password.match(/([a-z].*[A-Z])|([A-Z].*[a-z])/))
		strength += 1;
	
	//if it has numbers and characters, increase strength value
	if (password.match(/([a-zA-Z])/) && password.match(/([0-9])/))
		strength += 1;
	
	//if it has one special character, increase strength value
    if (password.match(/([!,%,&,@,#,$,^,*,?,_,~])/))
    	strength += 1;
	
	//if it has two special characters, increase strength value
    if (password.match(/(.*[!,%,&,@,#,$,^,*,?,_,~].*[!,%,&,@,#,$,^,*,?,_,~])/))
		strength += 1;
	
	//now we have calculated strength value, we can return messages
	
	//if value is less than 2
	if (strength < 2) {
		$('#result').attr('strongth', 'weak');
		return 'ضعيف';			
	}
	else if (strength == 2) {
		$('#result').attr('strongth', 'good');
		return 'متوسط';		
	}
	else {
		$('#result').attr('strongth', 'strong');
		return 'قوي';
	}
}