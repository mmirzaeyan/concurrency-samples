<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ attribute name="id" 				required="true" 	rtexprvalue="true"%>
<%@ attribute name="extensions" 		required="true" 	rtexprvalue="true"%>
<%@ attribute name="maxSize" 			required="true" 	rtexprvalue="true"%>
<%@ attribute name="haveDelete"			required="true" 	rtexprvalue="true"%>
<%@ attribute name="haveDownload" 		required="false"  	rtexprvalue="true"%>
<%@ attribute name="fileCodeDataBind" 	required="true" 	rtexprvalue="true"%>
<%@ attribute name="fileNameDataBind" 	required="true" 	rtexprvalue="true"%>
<%@ attribute name="width" 				required="false" 	rtexprvalue="true"%>
<%@ attribute name="cssClass" 			required="false" 	rtexprvalue="true"%>
<%@ attribute name="txtAttr" 			required="false" 	rtexprvalue="true"%>
<%@ attribute name="callback" 			required="false" 	rtexprvalue="true"%>

<script type="text/javascript" src="<c:url value = '/Scripts/MyJQuery/FileUpload/vendor/jquery.ui.widget.js'/>"></script>
<script type="text/javascript" src="<c:url value = '/Scripts/MyJQuery/FileUpload/jquery.iframe-transport.js'/>"></script>
<script type="text/javascript" src="<c:url value = '/Scripts/MyJQuery/FileUpload/jquery.fileupload.js'/>"> </script>

<script type="text/javascript">	
	$(function(){
		$('#fileupload_${id}').fileupload({
        	replaceFileInput: false, 
            formData: function (form) {
                return [ { name: 'fileCode', value:  $('#hiddenFileCode_${id}').val()}];
            },
            dataType: 'json',
            url: "<c:url value='/rest/attachment/save' />",
            maxFileSize:${maxSize},
            acceptFileTypes: /(\.|\/)(${extensions})$/i,
            autoUpload: true,
            add: function (e, data) {
        	           	$('#progress_${id}').css('visibility','visible');
            			$('#bar_${id}').css('width','0%');
            			$("#tmpPath_${id}").val($("#fileupload_${id}").val());
    					var uploadErrors = [];
    					var acceptFileTypes = /(\.|\/)(${extensions})$/i;
    					/*
    					if(!acceptFileTypes.test(data.originalFiles[0]['type'])) {
    						showMessage(" خطا! فرمت غیرمجاز!  ") ;
    						return;
    					}
    				    if(data.originalFiles[0]['size'] > ${maxSize}) {
    				            showMessage(" خطا! حجم فایل می بایست کمتر از " +  toMoneyFormat(${maxSize}) + "بایت باشد. ");
    				            return;
    			        } */
    					if(uploadErrors.length > 0) {
    						showMessage('خطا در آپلود عکس!');
    					} else {
    						data.submit();
    					}
        	            
        	},
        	progressall: function (e, data) {
                var progress = parseInt(data.loaded / data.total * 100, 10);
                $('#progress_${id} .bar').css(
                    'width',
                    progress + '%'
                );
            },
        	error:function(){},
            complete:function (result) {
            	var res=JSON.parse(result.responseText);
                if (${callback}!=null)
                	${callback}(res.fileCode);
            	$('#hiddenFileCode_${id}').val(res.fileCode);
            	$('#tmpPath_${id}').val(res.fileName);
            	$('#progress_${id}').css('visibility','hidden');
	        }
        });
	});
	function getFile_${id}(fileCode){
	    if (fileCode.length>0&&fileCode!='-1'){ 
	   	 var url="<c:url value='/rest/attachment/getFile/' />"+fileCode;
			 window.open(url,"_blank");
	    }
	}
	function deleteFile_${id}(fileCode){
		 var fCode = $('#hiddenFileCode_${id}').val();
	     if (fCode.trim().length>0&&fCode!='-1') {
	    	 baharanConfirm(" تایید پاک کردن فایل ضمیمه شده ","آيا از حذف شدن فايل اطمينان داريد ؟",function(){
	             Loader(true);
	             $.ajax({
	 				type:"DELETE",
	 				url	:'<c:url value="/rest/attachment/deleteFile/" />'+fCode,
	 				contentType:"application/json;",
	 				success:function(res){$('#hiddenFileCode_${id}').val('');$('#tmpPath_${id}').val('');}
	             });
	             Loader(false);
	         });
	     }
	     else 
	     	showMessage('فايلي براي حذف وجود ندارد' );
	}
	function HandleFileButtonClick_${id}(){	  
		  $("#fileupload_${id}").click();
	}
	function Clear_${id}(){
		$('#hiddenFileCode_${id}').val('');
		$('#tmpPath_${id}').val('');		  
	}
</script>
<div class="fileinput-button" style="float: right; z-index: 1000;">
 
		<input 		id="fileupload_${id}" 					 type="file" name="file"				style="display: none; height: 5px;" />
		<input 		type="text" 					${txtAttr}		 size="20" id="tmpPath_${id}" class="disableText ${cssClass}"	 		onClick="HandleFileButtonClick_${id}()"		style="height:18px; width: ${width};"   data-bind="${fileNameDataBind}"/> 
		<input 		id="hiddenFileCode_${id}"				 type="hidden"   data-bind="${fileCodeDataBind}" class="form-control input-md"/> 
	 	<c:if test="${haveDownload}">																		       
				<img style="cursor: pointer;vertical-align: text-bottom"		src="<c:url value = '/Content/images/Download.gif' />"	title="<spring:message code='UI.General.Download' />"  onclick="getFile_${id}($('#hiddenFileCode_${id}').val());" >
	  	</c:if>
		<c:if 		test="${haveDelete}">
			<img 	class="readOnly"	style="cursor: pointer;vertical-align: text-bottom;" 	src="<c:url value = '/Content/images/delete.gif' />"	title="<spring:message code='UI.General.Delete' />"    onclick="deleteFile_${id}($('#hiddenFileCode_${id}').val());" >
		</c:if>
</div>
<div class="progress progress-striped active" 	style="float: right; z-index: 1002; margin-right: -213px; width: 212px; opacity: 0.9; visibility: hidden;"	id="progress_${id}">
	<div class="bar" id="bar_${id}" style="width: 0%;"></div>
</div>
        