function initKeyUtility(){
	$(".moneySeprator").die();
	$('.moneySeprator').live("keyup", 	function(){
											$(this).val(toMoneyFormat($(this).val()));
										});
										
	$('.numberOnly').live("keypress", 	function(e){
											return checkChar(e, 1);
										});
}


function toMoneyFormat(number) {
		number += '';
	    if(number.length > 0) {
		    var sign = (parseFloat(number) >= 0) ? '' : '-';
			temp = '';
			//seprate numebrs and strings
			for(i=0 ; i <= (number.length - 1); i++) {
				if((number[i] >= '0' && number[i] <= '9') || number[i] == ',' || number[i] == '.')
					temp += number[i];
			}
			//remove the existing ,+
			try {
				var regex = /,/g;
				temp = temp.replace(regex,'');
			}
			catch(e) {}
			//force it to be a string
			temp += '';
			//split it into 2 parts  (for numbers with decimals, ex: 125.05125)
			var x = temp.split('.');
			var p1 = x[0];
			var p2 = x.length > 1 ? '.' + x[1] : '';
			//match groups of 3 numbers (0-9) and add , between them
			regex = /(\d+)(\d{3})/;
			while (regex.test(p1)) {
				p1 = p1.replace(regex, '$1' + ',' + '$2');
			}
			//join the 2 parts and return the formatted number
			return sign + p1 + p2;
		}
		else {
			return number;
		}

}

function removeMoneyFormat(number) {
	if(number.length > 0) {
		try {
			number = number.replace(new RegExp(',', 'g'), '');
			if(number.indexOf(".")!=-1) {
				return parseFloat(number);
			}
			else {
				return parseInt(number);
			}
		}
		catch (e) {
			console.log(e);
		}
	}
	else {
		return number;
	}
}




//tabdile adad b horoof
function NumberToText(Input) {
 var output = "";
 if(Input == "0")
 	return "صفر";
 if (Input != "") {
     temp = "";        
		i = Input.length - 1;//because index start with 0
		j = 0;
		part = 0;
     while (i >= 0) {
         temp = Input.charAt(i);
         if ((i != 0) && (j == 0) & (Input.charAt(i-1) == "1")) {//( 0xf8 & 0x3f); bitwise and --->0x38
             temp = Input.substring(i - 1, i + 1);
             temp = TwoDigitToText(temp);
             output = temp + output;
             if ((i != 0) & ((i - 1) != 0))
             	output = " و " + output;
             i = i - 2;
             j++;
         }
         else {
             temp = DigitToText(temp, j);
             if (temp != "") {
					output = temp + output;
                 if (i != 0)
						output = " و " + output;
             }
             i--;
         }
         if (j == 2) {
             part++;
             if (i != -1)
             	output = " " + PartsName(part) + " " + output;
             j = 0;
         }
         else
             j++;
     }
 }
 return output;
}

function PartsName(part) {
 var output = "";
 switch (part) {
     case 0:
         output = "";
         break;
     case 1:
         output = "هزار";
         break;
     case 2:
         output = "میلون";
         break;
     case 3:
         output = "میلیارد";
         break;
     default:
         break;
 }
 return output;
}

function DigitToText(Digit,  Order) {
 var output = "";
 if (Order == 0) {
 	switch (parseInt(Digit)) {
         case 0:
             output = "";
             break;
         case 1:
             output = "یک";
             break;
         case 2:
             output = "دو";
             break;
         case 3:
             output = "سه";
             break;
         case 4:
             output = "چهار";
             break;
         case 5:
             output = "پنج";
             break;
         case 6:
             output = "شش";
             break;
         case 7:
             output = "هفت";
             break;
         case 8:
             output = "هشت";
             break;
         case 9:
             output = "نه";
             break;
         default:
             output = "";
             break;
     }
 }
 
 if (Order == 1) {
     switch (parseInt(Digit)) {
         case 0:
             output = "";
             break;
         case 1:
             output = "";
             break;
         case 2:
             output = "بیست";
             break;
         case 3:
             output = "سی";
             break;
         case 4:
             output = "چهل";
             break;
         case 5:
             output = "پنجاه";
             break;
         case 6:
             output = "شصت";
             break;
         case 7:
             output = "هفتاد";
             break;
         case 8:
             output = "هشتاد";
             break;
         case 9:
             output = "نود";
             break;
         default:
             output = "";
             break;
     }
 }
 
 if (Order == 2) {
 	switch (parseInt(Digit)) {
         case 0:
             output = "";
             break;
         case 1:
             output = "صد";
             break;
         case 2:
             output = "دویست";
             break;
         case 3:
             output = "سیصد";
             break;
         case 4:
             output = "چهارصد";
             break;
         case 5:
             output = "پانصد";
             break;
         case 6:
             output = "ششصد";
             break;
         case 7:
             output = "هفتصد";
             break;
         case 8:
             output = "هشتصد";
             break;
         case 9:
             output = "نهصد";
             break;
         default:
             output = "";
             break;
     }
 }
 return output;
}

function TwoDigitToText(Digits) {
 var output = "";
 switch (parseInt(Digits)) {
     case 10:
         output = "ده";
         break;
     case 11:
         output = "یازده";
         break;
     case 12:
         output = "دوازده";
         break;
     case 13:
         output = "سیزده";
         break;
     case 14:
         output = "چهارده";
         break;
     case 15:
         output = "پانزده";
         break;
     case 16:
         output = "شانزده";
         break;
     case 17:
         output = "هفده";
         break;
     case 18:
         output = "هجده";
         break;
     case 19:
         output = "نوزده";
         break;
     default:
         output = "";
         break;
 }
 return output;
}

/// change Textbox Mode  for get number only... set keyup or live event for bind
function funDigitOnly(e) {
	if (document.all) {
		var k = window.event.keyCode;
		if (k < 48 | k > 57) {
			if (k == 13)
				window.event.keyCode = 13;
			else
				window.event.keyCode = 0;
		}
	}
	else {
		k = e.which;
		if (k < 48 | k > 57) {
			if(k != 13 && k != 0 && k != 8)
				return false;
		}
	}
}

function checkChar(e,type) {
	var keycode;
	if (window.event)
		keycode = window.event.keyCode;
	else if (e)
		keycode = e.which;
	if (keycode == 0 || keycode == 8 || keycode == 9 || keycode == 13 || keycode == 32)
		return true; //for space and enter

	if(type == 1) {//Only Number
		if (keycode < 48 || keycode > 57) return false;
		else return true;
	}
}


$(document).keydown(function(e) {
	var keycode;
	if (window.event) {
		keycode = window.event.keyCode;
	}
	else if (e) {
		keycode = e.which;
	}
	switch(keycode) {
		case 112: //F1
			showMessage("در حال حاضر راهنما فعال نمی باشد.");
			return false;
			break;
		case 113: //F2
			if ($('input[value*="ثبت"]:not(:hidden)').length > 0) {
				$('input[value*="ثبت"]:not(:hidden):first').click();
			}
			return false;
			break;
		case 114: //F3
			if ($('input[value*="بازگشت"]:not(:hidden)').length > 0) {
				$('input[value*="بازگشت"]:not(:hidden):first').click();
			}
			return false;
			break;
		case 115: //F4
			if ($('input[value*="جستجو"]:not(:hidden)').length > 0) {
				$('input[value*="جستجو"]:not(:hidden):first').click();
			}
			return false;
			break;
		case 116: //F5
			if ($('input[value*="چاپ"]:not(:hidden)').length > 0) {
				$('input[value*="چاپ"]:not(:hidden):first').click();
			}
			return false;
			break;
		case 118: //F7 Prev Page
			if ($('a[id*="prevIcon"]:not(:hidden)').length > 0) {
				$('a[id*="prevIcon"]:not(:hidden):first').click();
			}
			return false;
			break;
		case 119: //F8 Next Page
			if ($('a[id*="nextIcon"]:not(:hidden)').length > 0) {
				$('a[id*="nextIcon"]:not(:hidden):first').click();
			}
			return false;
			break;
		case 120: //F9 Delete
			if ($('img[src*="delete.gif"]:not(:hidden)').length == 1) {
				$('img[src*="delete.gif"]:not(:hidden):first').click();
			}
			return false;
			break;
	}
});
