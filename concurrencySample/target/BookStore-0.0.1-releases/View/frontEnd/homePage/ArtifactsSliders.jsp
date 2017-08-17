<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="true"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<!------------- product-slider ----------->

	<div class="row">
		<div class="col-md-1 pull-right"></div>
		<div class="col-md-9 pull-right">
			<h3>پر بازدید ترین ها</h3>
		</div>
	</div>
	<div class="col-lg-12">
	<div class="regular slider">
		<div id="entityBody" class="entityBody">
			<script id="GridRowTemplate" type="text/html">
				<div class="col-sm-2">
					<div class="artifact-item">
            			<img src="<c:url value='/rest/attachment/front/getFile/${mainPictureCode}'/>" alt=""/>
            			<div class="artifact-details">
                			<div>
                    			<h5>${name}</h5>
                			</div>
                			<div >
                    			<h5> ${price}</h5>
                			</div>
                			<a class="btn btn-default scale-fit" onclick="addToShoppingCart(${id})" >
                    		<i class="fa fa-shopping-cart"></i> <span class="hidden-sm" >اضافه یه سبد خرید</span></a>
                			<a class="btn btn-default scale-fit" onClick="goToArtifactPage(${id})">
                    		<i class="fa fa-list "></i>اطلاعات بیشتر</a>
            			</div>
        			</div>
				</div>
			</script>
			</div>
		</div>
	</div>
	<div class="row">
	</div>
<!------------- product-slider ----------->