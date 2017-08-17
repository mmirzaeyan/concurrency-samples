$(function () {
	$.ajaxSetup({
		  cache: false,
	      "error":		function (xhr, ev, settings, exception) {
	            			var message;
							var statusErrorMap = {
								'400' : "خطای سیستمی در اجرای درخواست.",/*"Server understood the request but request content was invalid."*/
								'401' : "شما دسترسی مجاز برای این کار را ندارید",/*"Unauthorised access."*/
								'403' : "شما دسترسی مجاز برای این کار را ندارید",/*"Forbidden resouce can't be accessed"*/
								'500' : "خطای سیستمی در اجرای درخواست",/*"Server understood the request but request content was invalid."*/
								'503' : "Service Unavailable"/*"Server understood the request but request content was invalid."*/
							};
							if (xhr.status != undefined && xhr.status != null) {
								message = statusErrorMap[xhr.status];
								if (xhr.status == 403 || xhr.status == 401) {
									sweetAlert(message, "خطا", "error");
									goToLoginPage();
									return;
								}
								else if (xhr.status == 500) {
									if (xhr.responseText.trim().length > 0)
										message = xhr.responseText;
									else
										message = "خطای سیستمی";
									sweetAlert(message, "error");
								}
								else if (xhr.status == 400) {
									try { //java bean validation
										var data = JSON.parse(xhr.responseText);
									} catch(e) {
										message = "خطای سیستمی \n.";
									}
								}
								else {
									if (!message)
										message = "خطای سیستمی \n.";
								}
							}
							else if (ev == 'parsererror') {
								message = "Error.\nParsing JSON Request failed.";
							}
							else if (ev == 'timeout') {
								message = "Request Time out.";
							}
							else if (ev == 'abort') {
								message = "Request was aborted by the server";
							}
							else {
								message = "Unknow Error \n.";
							}
							sweetAlert(message, "خطا", "error");
	      }
	});
});


