var temp = 0;
var confirmHeight, confirmWidth;
var restore = false;
function codePlusConfirm(title, message, funct, cancelFunc) {
		setDialogWithConfirm(funct, cancelFunc);
		var maskHeight = $(document).height(); 
		var maskWidth = $(window).width();
		if(temp == 0) {
			temp = 1;
			confirmHeight = $('#dialog-box').height();
			confirmWidth = $('#dialog-box').width() / 2;
		}
		var dialogTop =  (maskHeight / 3) - (confirmHeight);
		var dialogLeft = (maskWidth / 2) - (confirmWidth);
		$('#dialog-overlay').css({ height: maskHeight, width: maskWidth }).show();
		$('#dialog-box').css({ top: dialogTop, left:dialogLeft }).show();
		var html = "<b>" + title + "</b><div style='border:1px dashed; padding:6px;'><label class='status'>" + message + "</label></div><br/>";
		$('#dialog-message').html(html);
}

function setDialogWithConfirm(funct, cancelFunc) {
	//added dialog eleman into body element
	if($('#confirm').val()!=undefined){
		var htmlConfirm='<div id="dialog-overlay"></div>';
			htmlConfirm+='<div id="dialog-box"><span id="closeConfirmButton">';
			htmlConfirm+='<img src="' +  + '" /></span>';
			htmlConfirm+='<div class="dialog-content"><div id="dialog-message" dir="rtl"></div>';
			htmlConfirm+='<span id="okConfirm" style="float:right" class="button">بله</span>';
			htmlConfirm+='<span id="cancelConfirm" style="float:right" class="button">خير</span></div></div>';
		$("#confirm").html(htmlConfirm);
		
		$('#okConfirm').die("click");
		$('#okConfirm').live("click", function(){
			$("#dialog-overlay, #dialog-box").hide();
			return funct();
		});
		$('#cancelConfirm').die("click");
		$('#cancelConfirm').live("click", function(){
			$("#dialog-overlay, #dialog-box").hide();
			if (cancelFunc)
				return cancelFunc();
			else
				return null;
		});
		
		// if user clicked on button, the overlay layer or the dialogbox, close the dialog
		$('#closeConfirmButton').click(function () {    
			$('#dialog-overlay, #dialog-box').hide();      
			return false;
		});
		// if user resize the window, call the same function again
		// to make sure the overlay fills the screen and dialogbox aligned to center   
		$(window).resize(function () {
			//only do it if the dialog box is not hidden
			if (!$('#dialog-box').is(':hidden'))
				confirmation();
		});
	}
}