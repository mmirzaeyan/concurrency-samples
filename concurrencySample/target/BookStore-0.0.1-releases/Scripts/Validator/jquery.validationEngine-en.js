(function ($) {
	$.fn.validationEngineLanguage = function () {};
	$.validationEngineLanguage = {
		newLang : function () {
			$.validationEngineLanguage.allRules = {
				"required" : { // Add your regex rules here, you can take telephone as an example
					"regex" : "none",
					"alertText" : "این فیلد الزامی است",
					"alertTextCheckboxMultiple" : "یکی از موارد را انتخاب کنید",
					"alertTextCheckboxe" : "لطفا این مورد را انتخاب کنید"
				},
                "dateRange": {
                    "regex": "none",
                    "alertText": "نامعتبر ",
                    "alertText2": "بازه تاریخی"
                },
                "dateTimeRange": {
                    "regex": "none",
                    "alertText": "نامعتبر ",
                    "alertText2": "بازه زمانی"
                },
                "minSize": {
                    "regex": "none",
					"alertText" : " حداقل",
					"alertText2" : "  کاراکتر وارد نمائید"
                },
                "maxSize": {
                    "regex": "none",
					"alertText" : " حداکثر",
					"alertText2" : "  کاراکتر وارد نمائید"
                },
				"groupRequired": {
                    "regex": "none",
                    "alertText": "یکی از فیلدها را پرکنید."
                },
                "equals": {
                    "regex": "none",
                    "alertText": "مقدار واردشده یکسان نیست."
                },
                "creditCard": {
                    "regex": "none",
                    "alertText": "شماره کارت نامعتبر است."
                },
                "phone": {
                    // credit: jquery.h5validate.js / orefalo
                    "regex": /^([\+][0-9]{1,3}[\ \.\-])?([\(]{1}[0-9]{2,6}[\)])?([0-9\ \.\-\/]{3,20})((x|ext|extension)[\ ]?[0-9]{1,4})?$/,
                    "alertText": "شماره تلفن نامعتبر است."
                },
				"length" : {
					"regex" : "none",
					"alertText" : "بین ",
					"alertText2" : " تا ",
					"alertText3" : " حرف مجاز است "
				},
				"maxCheckbox" : {
					"regex" : "none",
					"alertText" : " بیش‌ترین گزینه‌ی قابل انتخاب ",
					"alertText2" : " است"
				},
				"minCheckbox" : {
					"regex" : "none",
					"alertText" : " لطفا ",
					"alertText2" : " مورد انتخاب کنید"
				},
				"confirm" : {
					"regex" : "none",
					"alertText" : "تکرار رمز صحیح نیست"
				},
				"mobile" : {
					"regex" : /^[0][0-9\-\(\)\ ]+$/,
					"alertText" : "شماره همراه باید 11 رقمی باشد "
				},
				"email" : {
					"regex" : /^[a-zA-Z0-9_\.\-]+\@([a-zA-Z0-9\-]+\.)+[a-zA-Z0-9]{2,4}$/,
					"alertText" : "آدرس ایمیل معتبر نمی باشد"
				},
				"integer" : {
					"regex" : /^[\-\+]?\d+$/,
					"alertText" : "لطفا عدد وارد کنید"
				},
                "number": {
                    // Number, including positive, negative, and floating decimal. credit: orefalo
                    "regex": /^[\-\+]?((([0-9]{1,3})([,][0-9]{3})*)|([0-9]+))?([\.]([0-9]+))?$/,
                    "alertText": "عدد وارد شده صحیح نیست."
                },
				"fcurrency" : {
					"regex" : /^[0-9\,]+\.?[0-9]*$/,
					"alertText" : "لطفا قیمت را صحیح وارد کنید"
				},
				"icurrency" : {
					"regex" : /^[0-9\,]*$/,
					"alertText" : "لطفا قیمت را بدون اعشار وارد کنید"
				},
				"fnumber" : {
					"alertText" : " این فیلد باید به صورت ",
					"alertText2" : " رقم صحیح و ",
					"alertText3" : " رقم اعشار باشد",
					"alertText4" : " رقم صحیح باشد",
					"alertText6" : "لطفا عدد را صحیح وارد نمایید"
				},
				"inumber" : {
					"regex" : /^[0-9\,]*$/,
					"alertText" : "لطفا عدد وارد کنید"
				},
				"min" : {
					"alertText" : "مقدار حداقل"
				},
				"minLength" : {
					"alertText" : " حداقل",
					"alertText2" : "  کاراکتر وارد نمائید"
				},
				"maxLength" : {
					"alertText" : " حداکثر",
					"alertText2" : "  کاراکتر وارد نمائید"
				},
				"combo" : {
					"alertText" : "يكي از آيتم ها راانتخاب کنید"
				},
				"isNationalCode" : {
					"alertText" : "کد ملی را صحیح وارد کنید"
				},
				"max" : {
					"alertText" : "مقدار حداکثر"
				},
				"ip" : {
					"regex" : /^[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3},[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}$/,
					"alertText" : "بازه ی آی پی درست نیست"
				},
				"date" : {
					"alertText" : "تاریخ وارد شده اشتباه است,لطفا با این ساختار وارد کنید. روز/ماه/سال"
				},
				"onlyNumber" : {
					"regex" : /^[0-9\ ]+$/,
					"alertText" : "لطفا عدد وارد کنید"
				},
				"noSpecialCaracters" : {
					"regex" : /^[0-9a-zA-Z]+$/,
					"alertText" : "فقط عدد و حروف"
				},
				"ajaxUser" : {
					"file" : "validateUser.php",
					"extraData" : "name=eric",

					"alertTextOk" : " This user is available",
					"alertTextLoad" : "Loading, please wait",
					"alertText" : "This user is already taken"

				},
				"ajaxName" : {
					"file" : "validateUser.php",
					"alertText" : "This name is already taken",

					"alertTextOk" : "This name is available",

					"alertTextLoad" : "Loading, please wait"
				},
				"onlyLetter" : {
					"regex" : /^[a-zA-Z\ \']+$/,
					"alertText" : "تنها ورود حروف مجاز است"
				},
				"onlyLetterSp" : {
					"regex" : /^[a-zA-Z\ \']+$/,
					"alertText" : "فقط حروف انگلیسی"
				},
				"onlyLetterNumber" : {
					"regex" : /^[0-9a-zA-Z]+$/,
					"alertText" : "فقط اعداد و حروف انگلیسی وارد کنید"
				},
				"validate2fields" : {

					"nname" : "validate2fields",
					"alertText" : "You must have a firstname and a lastname"
				},
				"validateMelliCode" : {
					"file" : "",
					"alertText" : "کد ملی وارد شده معتبر نیست",
					"alertTextLoad" : "در حال بررسی..."
				},
				"checkUserExist" : {
					"file" : "",
					"alertText" : "این نام کاربری تکراری است",
					"alertTextLoad" : "بررسی نام کاربری..."
				},
				"minCurrentYear" : {
					"alertText" : "سال وارد شده باید از سال جاری بزرگتر باشد"
				},
				"maxCurrentYear" : {
					"alertText" : "سال وارد شده باید از سال جاری بزرگتر نباشد"
				},
				"widthHigthLength" : {
					"regex" : /^[1-9]([0-9]{0,3})\*[1-9]([0-9]{0,3})\*[1-9]([0-9]{0,3})$/,
					"alertText" : "فرمت عرض * طول * ارتفاع را رعايت فرماييد"
				},
                //tls warning:homegrown not fielded 
				"dateTimeFormat": {
	                "regex": /^\d{4}[\/\-](0?[1-9]|1[012])[\/\-](0?[1-9]|[12][0-9]|3[01])\s+(1[012]|0?[1-9]){1}:(0?[1-5]|[0-6][0-9]){1}:(0?[0-6]|[0-6][0-9]){1}\s+(am|pm|AM|PM){1}$|^(?:(?:(?:0?[13578]|1[02])(\/|-)31)|(?:(?:0?[1,3-9]|1[0-2])(\/|-)(?:29|30)))(\/|-)(?:[1-9]\d\d\d|\d[1-9]\d\d|\d\d[1-9]\d|\d\d\d[1-9])$|^((1[012]|0?[1-9]){1}\/(0?[1-9]|[12][0-9]|3[01]){1}\/\d{2,4}\s+(1[012]|0?[1-9]){1}:(0?[1-5]|[0-6][0-9]){1}:(0?[0-6]|[0-6][0-9]){1}\s+(am|pm|AM|PM){1})$/,
                    "alertText": "Invalid Date or Date Format",
                    "alertText2": "Expected Format: ",
                    "alertText3": "mm/dd/yyyy hh:mm:ss AM|PM or ", 
                    "alertText4": "yyyy-mm-dd hh:mm:ss AM|PM"
	            }
			}
		}
	}
})(jQuery);

$(document).ready(function () {
	$.validationEngineLanguage.newLang()
});
