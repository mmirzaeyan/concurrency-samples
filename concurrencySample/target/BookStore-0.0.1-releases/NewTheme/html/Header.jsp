<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<section id="header" class="scheme-darkblue">
	<header class="clearfix">
		<div class="branding scheme-darkblue">
			<a class="brand" onclick="loadFrame('')" style="cursor: pointer">
				<span><strong>بهاران</strong> </span>
			</a>
			<a href="#" class="offcanvas-toggle visible-xs-inline">
				<i class="fa fa-bars"></i>
			</a>
		</div>
		<!-- Branding end -->
		<!-- Left-side navigation -->
		<ul class="nav-left pull-left list-unstyled list-inline">
			<li class="sidebar-collapse divided-right">
				<a href="#" class="collapse-sidebar">
					<i class="fa fa-outdent"></i>
				</a>
			</li>
		</ul>
		<!-- Left-side navigation end -->
		<!-- Search -->
		<!-- <div class="search" id="main-search">
        <input type="text" class="form-control underline-input" placeholder="جستجو ...">
    </div> -->
		<!-- Search end -->
		<!-- Right-side navigation -->
		<ul class="nav-right pull-right list-inline">
			<li class="dropdown notifications">
				<a href class="dropdown-toggle" data-toggle="dropdown">
					<i class="fa fa-bell"></i>
				</a>
				<div class="dropdown-menu pull-right with-arrow panel panel-default animated littleFadeInLeft">
					<div class="panel-heading">اطلاعات ورودی</div>
					<ul class="list-group">
						<li class="list-group-item">
							<a href="#" class="media">
								<span class="pull-left media-object media-icon bg-danger"> <i class="fa fa-warning"></i>
								</span>
								<div class="media-body">
									<span class="block">آی پی</span> <small class="text-muted ipUserLogin"> </small>
								</div>
							</a>
						</li>

						<li class="list-group-item">
							<a href="#" class="media">
								<span class="pull-left media-object media-icon bg-primary"> <i class="fa fa-arrow-left"></i>
								</span>
								<div class="media-body">
									<span class="block">آی پی وروردی قبلی</span> <small class="text-muted pereviousIp"></small>
								</div>
							</a>
						</li>

						<li class="list-group-item">
							<a href="#" class="media">
								<span class="pull-left media-object media-icon bg-greensea"> <i class="fa fa-unlock"></i>
								</span>
								<div class="media-body">
									<span class="block">تاریخ اخرین ورود</span> <small class="text-muted loginSolarDate"> </small>
								</div>
							</a>
						</li>
					</ul>
				</div>
			</li>
			<li class="dropdown nav-profile">

				<a href class="dropdown-toggle" data-toggle="dropdown">
					<img src="<c:url value="NewTheme/images/arnold-avatar.jpg"/>" alt="" class="img-circle size-30x30  authenticatedUserImage">
					<span class="authenticatedUserFullName"><i class="fa fa-angle-down"></i></span>
				</a>

				<ul class="dropdown-menu animated littleFadeInRight" role="menu">

					<li>
						<a href="#">
							<span class="badge bg-greensea pull-right">86%</span> <i class="fa fa-user"></i>پروفایل
						</a>
					</li>
					<li>
						<a href="#">
							<i class="fa fa-cog"></i>تنظیمات
						</a>
					</li>
					<li class="divider"></li>
					<li>
						<a href="#">
							<i class="fa fa-lock"></i>قفل صفحه
						</a>
					</li>
					<li>
						<a style="cursor: pointer" onclick="logoutForm()">
							<i class="fa fa-sign-out"></i>خروج
							<c:url var="logoutUrl" value="j_spring_security_logout" />
							<form action="${logoutUrl}" method="post" name='frmLogout' style="position: hidden">
								<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
							</form>

						</a>
					</li>

				</ul>
			</li>
			<li class="toggle-right-sidebar">
				<a href="#">
					<i class="fa fa-comments"></i>
				</a>
			</li>
		</ul>
		<!-- Right-side navigation end -->
	</header>
</section>
<div class="modal splash  fade" id="loginNotification" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true"
	data-options="splash-2 splash-lightblue splash-ef-2" >
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title custom-font">به نام خدا</h4>
				<h5 class="modal-title custom-font">«اللهم صل علی محمد و آل محمد و عجل فرجهم»</h5>
			</div>
			<div class="modal-body " style="padding-bottom: 0px">
				<!-- tile widget -->
				<div class="tile-widget">
					<!-- row -->
					<div class="row">
						<!-- col -->
						<div class="col-sm-6">
							<div class="media mb-20">
								<div class="pull-right ">
									<img class="media-object img-circle size-100x100 authenticatedUserImage" src="assets/images/ici-avatar.jpg" alt="">
								</div>
								<div class="media-body">
									<h3 class="media-heading mb-0">
										<strong style="color: darkblue;" class="authenticatedUserFullName"></strong>
									</h3>
									<h4 style="color: dodgerblue;" class="text-default.lter userName"></h4>
								</div>
							</div>
						</div>
						
						<div class="col-sm-6">
							<div class="row">
								<dl class="dl-horizontal text-sm">
									<dt style="width: 100px; text-align: right;">تاریخ اخرین ورود :</dt>
									<dd style="margin-right: 70px; color: navy;" class="loginSolarDate"></dd>
									<dt style="width: 100px; text-align: right;">آی پی :</dt>
									<dd style="margin-right: 70px; color: navy;" class="ipUserLogin"></dd>
									<dt style="width: 100px; text-align: right;">آی پی وروردی قبلی :</dt>
									<dd style="margin-right: 70px; color: crimson;" class="pereviousIp"></dd>
								</dl>
							</div>
							<div class="row">
								<dl id="loginFailure" class="dl-horizontal text-sm">
								</dl>
							</div>
						</div>
						<!-- /col -->
					</div>
					<!-- /row -->
				</div>
				<!-- /tile widget -->
			</div>
			<div class="modal-footer" style="padding-top: 0px;">
				<button class="btn btn-greensea btn-border btn-rounded-20 btn-ef btn-ef-4 btn-ef-4b mb-10" data-dismiss="modal">
					تایید<i class="fa fa-arrow-right"></i>
				</button>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
var ee;
	$(function() {
		/* var options = "";
		var target = "";
		$("#loginNotification").on('show.bs.modal', function(e) {
			options = e.currentTarget.dataset.options
			target = $(e.target);
			target.addClass(options);
			$("body").addClass(options).addClass('splash');
		});
		$("#loginNotification").on('hidden.bs.modal', function() {
			target.removeClass(options);
			$("body").removeClass(options).removeClass('splash');
		}); */
		$.ajax({
			url : "<c:url value='/rest/security/user/getUserHistory'/>",
			type : "POST",
			async : false,
			success : function(result) {
				if (result.personelIamgeCode != null)
					$(".authenticatedUserImage").attr("src","<c:url value='/rest/security/user/loadImage/'/>"+ result.personelId);
				$(".userName").html(result.userName);
				$(".authenticatedUserFullName").html(result.firstName + " " + result.lastName);
				$(".loginSolarDate").html(result.loginSolarDate);
				$(".ipUserLogin").html(result.ip);
				$(".pereviousIp").html(result.pereviousIp);
			}
		});
		$.ajax({
			url:"<c:url value='/rest/security/loginHistory/loginFailureToLastSuccess' />",
			type:"GET",
			async : true,
			success : function(entities) {
				if (entities.length != 0) {
					$("#loginFailure").append("<h4>ورود ناموفق</h4><dt style='width: 100px; text-align: right;'>آی پی</dt><dd style='margin-right: 70px; ' >تاریخ ورود</dd>");
					$.each(entities,function(index,item){
						var dt = $("<dt>");
						var dd =$("<dd>");
						$(dt).text(item.ip).attr("style","width: 100px; text-align: right;color: navy;");
						$(dd).text(item.loginSolarDate).attr("style","margin-right: 70px; color: crimson;");
						$("#loginFailure").append($(dt)).append($(dd));
					});
				}
			}
		});
		/* setTimeout(function() {
			$("#loginNotification").modal("show");
		}, 1000); */
		
	});
</script>
