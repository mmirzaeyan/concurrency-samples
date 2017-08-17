<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8" isELIgnored="true"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="sec"	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="codePlus" tagdir="/WEB-INF/tags"%>
<html xmlns="http://www.w3.org/1999/xhtml" lass="no-js" lang="">
<head > 
    <title></title>
    <META http-equiv="Content-Type" content="text/html;charset=UTF-8">
    <%@ include file="/View/ScriptHeader/Head.jsp" %>
    <%@ include file="/View/ScriptHeader/FancyDialog.jsp"%>
    <%@ include file="/View/ScriptHeader/baharanJqueryUi.jsp"%>
    <%@ include file="/View/ScriptHeader/Tooltip.jsp"%>
    <script language="javascript" type="text/javascript">
    	var isFirstShow = true;
		var entitiesCache = {};
        var pageSize = 5;
        var pageNo = 0;
        var order = 'e.id asc';
        var resultNum = 0;
        var restUrl="<c:url value = '/rest/core/goods/products/book' />";
    	var restUrlPublisher = "<c:url value = '/rest/core/publisher' />";
    	var restUrlPublisherProduct = "<c:url value = '/rest/core/publisherProduct' />";
        
        

	    function refreshcombo(){
	    	$("#cmbPublisherSearch").multiselect('rebuild');
	    	$("#cmbPublisherProductSearch").multiselect('rebuild');
	    	$("#cmbLessonSearch").multiselect('rebuild');
	    	$("#cmbGradeSearch").multiselect('rebuild');
	    	$("#cmbFieldSearch").multiselect('rebuild');
	    	$("#cmb‌‌BookTypeSearch").multiselect('rebuild');
	    	
		  }
	    
        function init() {
        	fillCombo("cmbPublisherSearch",restUrlPublisher+"/getAll", {}, "id", "publisherName","...",-1,refreshcombo);
        	fillCombo("cmbLessonSearch","<c:url value = '/rest/core/baseInformation/list/7' />", {}, "id", "topic","...",-1,refreshcombo);
        	fillCombo("cmbGradeSearch","<c:url value = '/rest/core/baseInformation/list/5' />", {}, "id", "topic","...",-1,refreshcombo);
        	fillCombo("cmbFieldSearch","<c:url value = '/rest/core/baseInformation/list/6' />", {}, "id", "topic","...",-1,refreshcombo);
        	fillCombo("cmb‌‌BookTypeSearch","<c:url value = '/rest/core/baseInformation/list/4' />", {},"id", "topic", "...",-1,refreshcombo);
        	
        	fillTable();
        }

		
        function fillTable() {
			jsonData = {
				order : order,
				pageNumber : pageNo,
				pageSize : pageSize,
				name:$("#txtNameSearch").val(),
				isbn:$("#txtIsbnSearch").val(),
				printYear:$("#txtPrintYearSearch").val(),
				author:$("#txtAuthorSearch").val(),
				translator:$("#txtTranslatorSearch").val(),
				publishers: getSelectedFromMultiple('cmbPublisherSearch'),
				publisherProducts: getSelectedFromMultiple('cmbPublisherProductSearch'),
				fields:getSelectedFromMultiple('cmbFieldSearch') ,
				lessons:getSelectedFromMultiple('cmbLessonSearch'),
				grades:getSelectedFromMultiple('cmbGradeSearch'),
				bookType:getSelectedFromMultiple('cmb‌‌BookTypeSearch')
			};
			loadGrid('GridRowTemplate', 'entityBody', restUrl + "/list/grid",jsonData);
		}

        function fillCmbPublihserProductSearch(){
        	var publisherId=$("#cmbPublisherSearch").val()
    		if (publisherId==-1){
    			$('#cmbPublisherProductSearch').find('option:not(:first)').remove();
    		}
    		else{
    			 fillCombo("cmbPublisherProductSearch",restUrlPublisherProduct+"/getAllMulti/"+publisherId, {}, "id", "productName","...",-1,refreshcombo);
    		}	
        }
        
        function deleteEntity(id) {
			if (id) {
				swal({
					title: "آیا از انجام این کار مطمئن هستید ؟",
					  text: "پس از انجام عملیات حذف امکان بازیابی وجود ندارد",
					  type: "warning",
					  showCancelButton: true,
					  confirmButtonText: "بله ، حذف میکنم",
					  cancelButtonText: "خیر ، انصراف میدهم",
					  confirmButtonColor: "#DD6B55",
					  closeOnConfirm: false
					},
					function(){
						Loader(true);
						$ .ajax({
							type : "DELETE",
							url : restUrl + "/delete/" + id,
							contentType : "application/json;",
							success : function(res) {
								if (res)
									fillTable();
								else
									sweetAlert("Oops...", "Something went wrong!", "error");
								},
							error : function() {
								sweetAlert("خطا...!", "خطای سیستمی", "error");
								Loader(false);
								}
								
						});
					  	swal("Deleted!", "Your imaginary file has been deleted.", "success");
					  	Loader(false);
				});
			}
        }


        function clearSearch(){
			$(".searchControl").val('');
			$(".multiCombo").multiselect('deselectAll',false);
			$(".multiCombo").multiselect('updateButtonText');
        }
        
    </script>
    
</head>
<body id="minovate" class="appWrapper rtl" onload="pageLoad()">
	<span id="confirm"></span>
    <form id="FormMain" >
	    <div dir="rtl">
				<%@ include file="Grid.jsp" %>
		</div>
	</form>
</body>
</html>
