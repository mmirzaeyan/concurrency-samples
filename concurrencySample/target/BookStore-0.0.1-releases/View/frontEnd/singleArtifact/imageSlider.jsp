<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8" isELIgnored="true"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="codePlus" tagdir="/WEB-INF/tags"%>
<html>
<head>

<%@ include file="/View/ScriptHeader/FrontEndHead.jsp"%>
<%@ include file="/View/ScriptHeader/ImageSliderHead.jsp"%>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
<style type="text/css">
	#slideshow img{
		display:inline-block;
		max-height:400px;
 		width: 100%; 
 		margin-top:20px;
	}
	
	.img-thumbs{
            width: 100%;
            height: 25%;
        }
    .desoslide-overlay{
    top:auto !important;bottom:0 !important
    }
</style>

<script type="text/javascript">
	var id =<%=request.getParameter("artifactId")%>	;
	$(function() {
		loadSlider(id);
	});
	
	function runSlider(){
		$('#slideshow').desoSlide({
		    thumbs: $('#slideShow_thumb li > a'),
		    auto: {
		        start: true
		    },
		
		    first: 1,
		    interval: 6000
		});
	};
	
	function loadSlider(productId){
		$.getJSON(restUrlPicture + "/front/getAll/" + productId , function(entities){
			if (entities.entityList){console.log(entities.entityList)
				$('#GridRowTemplate').tmpl(entities.entityList).replaceAll('#entityBody');
			}
			else {
				$('#GridRowTemplate').tmpl(entities).replaceAll("#entityBody");
			}
			runSlider();
		});
	};
	
	
</script>
</head>
<body>
	<section id="section_demo" >
	    <div class="row">
	        <div id="slideshow" class="col-lg-10 col-lg-offset-1 text-center"></div>
	    </div>
	    <hr>
	    <div class="row">
	        <article class="col-lg-12 ">
	            <ul id="slideShow_thumb" class="desoslide-thumbs-horizontal list-inline " style="50%;margin:auto;">
	                <div id="entityBody" class="entityBody">
						<script id="GridRowTemplate" type="text/html">
							<li class="col-lg-2" >
	                    		<a href="<c:url value='/rest/attachment/front/getFile/${pictureCode}'/>" data-desoslide-index="0">
	                        	<img src="<c:url value='/rest/attachment/front/getFile/${pictureCode}'/>" class="img-thumbs img-responsive" alt="tortoise" data-desoslide-caption-title="A tortoise">
	                    		</a>
	                		</li>
						</script>
					</div>
	            </ul>
	        </article>
	    </div>
	</section>
</body>
</html>