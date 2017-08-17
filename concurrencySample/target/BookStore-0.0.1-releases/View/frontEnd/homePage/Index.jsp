<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="codePlus" tagdir="/WEB-INF/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
	<%@ include file="/View/ScriptHeader/FrontEndHead.jsp"%>
	<%@ include file="/View/ScriptHeader/SlickHead.jsp"%>
	<%@ include file="/View/ScriptHeader/SweetAlertHead.jsp" %>

	<script language="javascript" type="text/javascript">
        var restUrl = "<c:url value = '/rest/core/goods/products/book' />";
        var restUrlOrderItem = "<c:url value = '/rest/order/orderItem/front/addToBasket/' />";

        $(function() {
            fillTable();
        });

        function loadSlick(){
            $('.regular').slick({
                arrows: false,
                dots: true,
                infinite: false,
                speed: 300,
                slidesToShow: 6,
                slidesToScroll: 6,
                rtl:true
            });
        }

        function fillTable() {
            var appendText = ""
            var counter=1;
            $.getJSON(restUrl + "/front/list/getAll",
                function(entities) {
                    if (entities.entityList)
                        $('#GridRowTemplate').tmpl(entities.entityList).replaceAll('#entityBody');
                    else {
                        $('#GridRowTemplate').tmpl(entities).replaceAll("#entityBody");
                    }

                    loadSlick();
                });
        }


        function addToShoppingCart(productId) {
            $.ajax({
                type : "POST",
                url : restUrlOrderItem + productId,
                success : function(res) {
                    if (res)
                        swal("", "محصول مورد نظر با موفقیت به سبد خرید شما اضافه شد", "success");
                    return res.id
                }
            });

        }
        function goToArtifactPage(artifactId) {
            window.location = "<c:url value ='/View/frontEnd/singleArtifact/index.jsp?artifactId=" + artifactId + "'/>";
        }
     
      
	</script>
</head>
<body>
<span id="confirm"></span>
<%@ include file="Header.jsp"%>
<%@ include file="TopMenu.jsp"%>
<%@ include file="Commercial.jsp"%>
<%@ include file="Footer.jsp" %>
</body>
</html>