	$(function(){
		/*toggleSearchBox();*/
		gridRefresh();
		formRefresh();
	});
	/*----Content-----*/
 	function loadFrame(url,menuLayoutState){
 			if(menuLayoutState!=null&&!$("#minovate").hasClass(menuLayoutState)){
 				switch(menuLayoutState){
	 				case "sidebar-sm":{
	 					$("#minovate").removeClass("sidebar-xs").addClass("sidebar-sm");
	 					break;
	 				}
	 				case "sidebar-xs":{
	 					$("#minovate").removeClass("sidebar-sm").addClass("sidebar-xs");
	 					break;
	 				}
	 				case "sidebar-lg":{
	 					$("#minovate").removeClass("sidebar-sm").removeClass("sidebar-xs");
	 					break;
	 				}
 				}
 			}
 		$("#mainFrame").height($(window).height()-$("#header").height());
 		$("#mainFrame").attr("src",url);
 	}
 	
 	/*--	Modal ---*/
 	function openWindow(windowId, windowTitle, url, width, height, isMaximize,isModal) {
 		if (windowId == 0)
 			windowId = new Date().getTime();
 		if (url.indexOf('http://') == 0 || url.indexOf('https://') == 0) {
 			url += (url.indexOf('?') >= 0 ? '&' : '?') + 'refreshId='+ new Date().getTime() + '&windowId=' + windowId;
 		} else {
 			url += (url.indexOf('?') >= 0 ? '&' : '?') + 'refreshId='+ new Date().getTime() + '&windowId=' + windowId;
 		}
 		widthContent = width + 2 + 30;//1border left right modal content + 15 left right padding modal body
 		height += 25 + 30;//25 modal header + 15 top down padding modal body
 		$('#win_iframe_main').attr("src", url);
 		$('#win_iframe_main').attr("width", width);
 		$('#win_iframe_main').attr("height", height);
 		$('.modal-content').css("width", widthContent);
 		$('.modal-title').html(windowTitle);
 		$('#ModalPage').modal('show');
 	}

 	
 	/*-----Notification------*/
 	function showMessage(text, option) {
 		opt={};
 		if(option!=null){
 			opt=option;
 		}
 		shortCutFunction = (opt.toastType==null?"info":opt.toastType);
 		toastr.options = {
 				  "closeButton": (opt.progressBar==null?true:opt.closeButton),
 				  "debug": false,
 				  "newestOnTop": (opt.newestOnTop==null?false:opt.newestOnTop),
 				  "progressBar": (opt.progressBar==null?false:opt.progressBar),
 				  "positionClass": (opt.positionClass==null?"toast-top-center":opt.positionClass),
 				  "preventDuplicates": (opt.preventDuplicates==null?true:opt.preventDuplicates),
 				  "onclick": null,
 				  "showDuration": (opt.showDuration==null?"300":opt.showDuration),
 				  "hideDuration": (opt.hideDuration==null?"1000":opt.hideDuration),
 				  "timeOut": (opt.timeOut==null?"5000":opt.timeOut),
 				  "extendedTimeOut": (opt.extendedTimeOut==null?"1000":opt.extendedTimeOut),
 				  "showEasing": (opt.showEasing==null?"swing":opt.showEasing),
 				  "hideEasing": (opt.hideEasing==null?"linear":opt.hideEasing),
 				  "showMethod": (opt.showMethod==null?"fadeIn":opt.showMethod),
 				  "hideMethod": (opt.hideMethod==null?"fadeOut":opt.hideMethod),
 				  "tapToDismiss": (opt.tapToDismiss==null?false:opt.tapToDismiss),
 		}
 		var $toast = toastr[shortCutFunction](text, opt.title);
 	}
 	/*-------Grid Box--------*/
 	/*function toggleSearchBox(){
 		$.each($("[data-toggleId]"),function(){
 			idSearchBox = $(this).attr("data-toggleId");
 			$(this).on("click",function(){
 				$('#'+idSearchBox).slideToggle(500);
 			});
 		});
 	}*/
 	function gridRefresh(){
 		$.each($("[data-gridRefresh]"),function(){
 			calbackFunction=$(this).attr("data-gridRefresh").trim();
 			if(calbackFunction.length>0){
 				calbackFunction();
 			}else{
 				$(this).on("click",function(){
 					$("#grid").grid("fillTable");
 	 			});
 			}
 		});
 	}
 	function formRefresh(){
 		$.each($("[data-formRefresh]"),function(){
 			calbackFunction=$(this).attr("data-formRefresh").trim();
 			if(calbackFunction.length>0){
 				calbackFunction();
 			}else{
 				$(this).on("click",function(){
 					$('#FormMain').form('load', $('#id').val());
 	 			});
 			}
 		});
 	}
 	function tabToggle(tabId,active,disabled){
	 	$("#"+tabId+" a[data-toggle='tab']").each(function(index, object) {
			if (active.indexOf(index + 1) < 0) {
				$(this).addClass('disabled');
				$(this).parent().removeClass('active');
			} else {
				$(this).removeClass('disabled');
			}
			if (disabled.indexOf(index + 1) >= 0) {
				$(this).addClass('disabled');
				$(this).parent().removeClass('active');
			} else {
				$(this).removeClass('disabled');
			}
	 	});
 	}
