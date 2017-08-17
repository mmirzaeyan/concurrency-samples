var lastWinId = '';
// /////////////////////////
function showMessage(text, delay) {
	Ext.MessageBox.show({
		msg : '<div style="direction:rtl;text-align:center;line-height:1.75em;">' + text + '<div>',
		width : text.length > 40 ? 450 : 300,
		buttons : Ext.MessageBox.OK,
		icon : Ext.MessageBox.INFO,
		cls : "msgClass",
		modal : true
	});
	$('.msgClass').css("z-index", "100000");
	$('.ext-el-mask').css("z-index", "90000");
	delayTimeout = 5;
	if (delay)
		delayTimeout = delay;

	setTimeout(function() {
		Ext.MessageBox.hide();
	}, delayTimeout * 1000);
}
function showErrorMessage(text) {
	Ext.MessageBox.show({
		msg : '<div style="direction:rtl;text-align:center;line-height:1.75em;">' + text + '<div>',
		width : text.length > 40 ? 400 : 300,
		buttons : Ext.MessageBox.OK,
		icon : Ext.MessageBox.ERROR,
		cls : "msgClass"
	});
}
function showConfirmMessage(text, command, frame) {
	if (command == 'delete')
		Ext.MessageBox.show({
			msg : '<div style="direction:rtl;text-align:center">' + text + '<div>',
			width : 300,
			buttons : Ext.MessageBox.YESNO,
			icon : Ext.MessageBox.QUESTION,
			cls : "msgClass",
			fn : function(btn) {
				window.frames[frame + 'Manager'].deleteConfirm(btn);
			}
		});
	if (command == 'move') {
		Ext.MessageBox.show({
			msg : '<div style="direction:rtl;text-align:center">' + text + '<div>',
			width : 300,
			buttons : Ext.MessageBox.YESNO,
			icon : Ext.MessageBox.QUESTION,
			cls : "msgClass",
			fn : function(btn) {
				window.frames[frame + 'Manager'].moveConfirm(btn);
			}
		});
	}
}
function hideMessage() {
}
function openWindow(winId, title, url, w, h, isMaximize, isModal) {
	if (winId != 'loginWin')
		lastWinId = winId;
	var desktop = MyDesktop.getDesktop();
	var win = desktop.getWindow(winId);
	var html = '';
	if (url.indexOf('text:') == 0) {
		html = url.substring(5);
	} else if (url.indexOf('http://') == 0 || url.indexOf('https://')==0) {
		url += (url.indexOf('?') >= 0 ? '&' : '?') + 'refreshId=' + new Date().getTime() + '&windowId=' + winId;
		html = '<iframe class="pageIframe"  src="' + url + '" width="100%" height="100%" frameborder="0" name="' + winId
				+ '"></iframe>';

	} else {
		url += (url.indexOf('?') >= 0 ? '&' : '?') + 'refreshId=' + new Date().getTime() + '&windowId=' + winId;
		html = '<iframe class="pageIframe"  src="/' + getContextName() + '/' + url
				+ '" width="100%" height="100%" frameborder="0" name="' + winId + '"></iframe>';
	}
	maximized = false;
	maximizable = true;

	if (isMaximize != null)
		maximized = isMaximize;
	if (!win) {
		win = desktop.createWindow({
			id : winId,
			title : ' فرم ' + title,
			width : w,
			height : h,
			maximized : maximized,
			maximizable : maximizable,
			closeAction : 'close',
			html : html,
			iconCls : 'bogus',
			plain : true,
			modal : isModal
		});
	}
	win.show();
}
/*function openWindow(windowId, windowTitle, url, width, height, isMaximize, isModal) {
	//windowId,windowTitle, url, width, height,isMaximize, isModal,remote
	if (url.indexOf('http://') == 0 || url.indexOf('https://') == 0) {
		url += (url.indexOf('?') >= 0 ? '&' : '?') + 'refreshId=' + new Date().getTime() + '&windowId=' + windowId;
	} else {
		url += (url.indexOf('?') >= 0 ? '&' : '?') + 'refreshId=' + new Date().getTime() + '&windowId=' + windowId;
	
	$('#win_iframe_main').attr("src", url);
	$('#win_iframe_main').attr("width", width);
	$('#win_iframe_main').attr("height", height);
	$('.modal-content').css("width", width);
	$('.modal-title').html(windowTitle);
	$('#ModalPage').modal('show');
}*/
function closeWindow(winId) {
	var desktop = MyDesktop.getDesktop();
	var win = desktop.getWindow(winId);
	if (win)
		win.close();
}
function callMethod(func) {
	$(".pageIframe").each(function() {
		eval('$(this)[0].contentWindow.' + func);
	});
}
function closeLastOpenedWin() {
	if (lastWinId && lastWinId.length > 1)
		closeWindow(lastWinId);
	lastWinId = '';
}
var today = '1390/06/16';
function switchWindow(winId, isInternal) {
	var desktop = MyDesktop.getDesktop();
	if (isInternal)
		var win = desktop.getWindow(winId);
	else
		var win = desktop.getWindow('win' + winId);
	if (win)
		win.show();
}
function init() {
	// setTimeout('changeBack()', 15 * 60 * 1000);
}
var i = 1;
function changeBack() {
	document.getElementById('bodyElm').style.backgroundImage = 'url(./images/wallpapers/desktop' + i + '.jpg)';
	i = i == 5 ? 1 : i + 1;
	setTimeout('changeBack()', 15 * 60 * 1000);
}