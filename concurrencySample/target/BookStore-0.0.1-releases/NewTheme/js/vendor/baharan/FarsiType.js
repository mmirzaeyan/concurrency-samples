if (typeof HTMLElement!="undefined" && ! HTMLElement.prototype.insertAdjacentElement) {
	HTMLElement.prototype.insertAdjacentElement = function (where,parsedNode) {
		switch (where) {
			case 'beforeBegin':
				this.parentNode.insertBefore(parsedNode,this)
				break;
			case 'afterBegin':
				this.insertBefore(parsedNode,this.firstChild);
				break;
			case 'beforeEnd':
				this.appendChild(parsedNode);
				break;
			case 'afterEnd':
				if (this.nextSibling)
					this.parentNode.insertBefore(parsedNode,this.nextSibling);
				else
					this.parentNode.appendChild(parsedNode);
				break;
		}
	}

	HTMLElement.prototype.insertAdjacentHTML = function (where,htmlStr) {
		var r = this.ownerDocument.createRange();
		r.setStartBefore(this);
		var parsedHTML = r.createContextualFragment(htmlStr);
		this.insertAdjacentElement(where,parsedHTML)
	}

	HTMLElement.prototype.insertAdjacentText = function (where,txtStr) {
		var parsedText = document.createTextNode(txtStr)
		this.insertAdjacentElement(where,parsedText)
	}
}

var FarsiType = {
	// Farsi keyboard map based on Iran Popular Keyboard Layout
	farsiKey: [
		32,	33,	34,	35,	36,	37,	1548,	1711,
		41,	40,	215,	43,	1608,	45,	46,	47,
		48,	49,	50,	51,	52,	53,	54,	55,
		56,	57,	58,	1705,	44,	61,	46,	1567,
		64,	1616,	1584,	125,	1609,	1615,	1609,	1604,
		1570,	247,	1600,	1548,	47,	8217,	1583,	215,
		1563,	1614,	1569,	1613,	1601,	8216,	123,	1611,
		1618,	1573,	126,	1580,	1688,	1670,	94,	95,
		1662,	1588,	1584,	1586,	1740,	1579,	1576,	1604,
		1575,	1607,	1578,	1606,	1605,	1574,	1583,	1582,
		1581,	1590,	1602,	1587,	1601,	1593,	1585,	1589,
		1591,	1594,	1592,	60,	124,	62,	1617
	],
	Type: true,
	counter: 0,
	ShowChangeLangButton: 0,	// 0: Hidden / 1: Visible
	KeyBoardError: 0,			// 0: Disable FarsiType / 1: Show Error
	ChangeDir: 0,			// 0: No Action / 1: Do Rtl-Ltr / 2: Rtl-Ltr button
	UnSupportedAction: 1		//0: Disable FarsiType / 1: Low Support
}




FarsiType.init = function() {

	var Inputs = document.getElementsByClassName('persianOnly');
	for (var i=0; i<Inputs.length; i++) {
		if (Inputs[i].type.toLowerCase() == 'text' ) {
			FarsiType.counter++;
			new FarsiType.KeyObject(Inputs[i], FarsiType.counter);
		}
	}

	var Areas = document.getElementsByTagName('TEXTAREA');
	for (var i=0; i<Areas.length; i++) {
			FarsiType.counter++;
			if(!Areas[i].className.contains('everyCharcter'))
				new FarsiType.KeyObject(Areas[i], FarsiType.counter);
	}
	
	var Inputs = document.getElementsByClassName('englishOnly');
	for (var i=0; i<Inputs.length; i++) {
		if (Inputs[i].type.toLowerCase() == 'text' ) {
			FarsiType.counter++;
			new FarsiType.KeyObject(Inputs[i], FarsiType.counter);
		}
	}
	
	var Dis = document.getElementById('disableFarsiType')
	if (Dis != null) {
		FarsiType.enable_disable (Dis);
		Dis.onclick = new Function( "FarsiType.enable_disable (this);" )
	}
}

FarsiType.KeyObject = function(z,x) {

	GenerateStr = "";
	z.insertAdjacentHTML("afterEnd", GenerateStr);

	z.farsi = true;
	z.dir = "rtl";
	z.align = "right";
	
	var className=z.className;
	var enFlag=false;
	if (className.search('englishOnly')!=-1)
		enFlag=true;
	if (enFlag){
		z.farsi = false;
		z.dir = "ltr";
		z.align = "left";
	}
	

	z.style.textAlign = z.align;
	z.style.direction = z.dir;

	setSelectionRange = function(input, selectionStart, selectionEnd) {
		input.focus()
		input.setSelectionRange(selectionStart, selectionEnd)
	}

	ChangeDirection = function() {
		if (z.dir == "rtl") {
			z.dir = "ltr";
			z.align = "left";
			z.Direlm.value = "LTR";
			z.Direlm.title = "Change direction: Right to Left"
		} else {
			z.dir = "rtl";
			z.align = "right";
			z.Direlm.value = "RTL";
			z.Direlm.title = "Change direction: Left to Right"
		}
		z.style.textAlign = z.align;
		z.style.direction = z.dir;
		z.focus();
	}



	Convert = function(e) {

		if (e == null)
			e = window.event;

		var key = e.which || e.charCode || e.keyCode;
		var eElement = e.target || e.originalTarget || e.srcElement;

		if (FarsiType.Type) {
			
			if (
				(e.charCode != null && e.charCode != key) ||
				(e.which != null && e.which != key) ||
				(e.ctrlKey || e.altKey || e.metaKey) ||
				(key == 13 || key == 27 || key == 8)
			) return true;

			//check windows lang
			var className=z.className;
			var enFlag=false;
			
			if (className.search('englishOnly')!=-1)
				enFlag=true;
			//check windows lang
			if (key > 128 && enFlag) {
				showMessage('لطفا زبان ویندوز را بر روی حالت EN  قرار دهید ');
				return false;
				}
			else if (key > 128 && !enFlag) {
				return true;
				}

			// If Farsi
			if (FarsiType.Type && z.farsi) {

				//check CpasLock
				/*if ((key >= 65 && key <= 90&& !e.shiftKey) || (key >= 97 && key <= 122 ) && e.shiftKey) {
					alert("Caps Lock is On. To prevent entering farsi incorrectly, you should press Caps Lock to turn it off.");
					return false;
				}*/

				// Shift-space -> ZWNJ
				if (key == 32 && e.shiftKey)
					key = 8204;
				else
					key = FarsiType.farsiKey[key-32];

				key = typeof key == 'string' ? key : String.fromCharCode(key);

				// to farsi
				try {
					var maxLength = e.target.maxLength == -1 ? 20 : e.target.maxLength;
					if (e.target.type == "textarea") {
						maxLength = e.target.maxLength == -1 ? 255 : e.target.maxLength;
					}
					
					var docSelection = document.selection;
					var selectionStart = eElement.selectionStart;
					var selectionEnd = eElement.selectionEnd;

					if (typeof selectionStart == 'number') { 
						//FOR W3C STANDARD BROWSERS
						var nScrollTop = eElement.scrollTop;
						var nScrollLeft = eElement.scrollLeft;
						var nScrollWidth = eElement.scrollWidth;
						
						
						if(maxLength >= (eElement.value.substring(0, selectionStart) + key + eElement.value.substring(selectionEnd)).length){
							eElement.value = eElement.value.substring(0, selectionStart) + key + eElement.value.substring(selectionEnd);
							setSelectionRange(eElement, selectionStart + key.length, selectionStart + key.length);
						}
						
						
						var nW = eElement.scrollWidth - nScrollWidth;
						if (eElement.scrollTop == 0) { eElement.scrollTop = nScrollTop; }
					} else if (docSelection) {
						var nRange = docSelection.createRange();
						nRange.text = key;
						nRange.setEndPoint('StartToEnd', nRange);
						nRange.select();
					}
	
				} catch(error) {
					try {
						// IE
						e.keyCode = key
					} catch(error) {
						try {
							// OLD GECKO
							e.initKeyEvent("keypress", true, true, document.defaultView, false, false, true, false, 0, key, eElement);
						} catch(error) {
							//OTHERWISE
							if (FarsiType.UnSupportedAction == 0) {
								alert('Sorry! no FarsiType support')
								FarsiType.Disable();
								var Dis = document.getElementById('disableFarsiType')
								if (Dis != null) {
									Dis.disabled = true;
								}
								return false;
							} else {
								eElement.value += key;					
							}
						}
					}
				}

				if (e.preventDefault)
					e.preventDefault();
				e.returnValue = false;
			}
		}
		return true;
	}
	
	z.onkeypress = Convert;
	
	$(z).on("paste", function(e){
		var tmpTextData = $(z).val();
		setTimeout(function(){
			if ($(z).val().match(/[a-z]/g)) {
				$(z).val(tmpTextData);
			}
	    }, 0);
	});
}

if (window.attachEvent) {
	window.attachEvent('onload', FarsiType.init)
} else if (window.addEventListener) {
	window.addEventListener('load', FarsiType.init, false)
}