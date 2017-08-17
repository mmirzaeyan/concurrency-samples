<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">

	<%@ include file="/View/ScriptHeader/JqueryHead.jsp" %>
	<%@ include file="/View/ScriptHeader/BootstrapHead.jsp" %>
	<%@ include file="/View/ScriptHeader/AdminHead.jsp" %>
    <%@ include file="/View/ScriptHeader/baharanJqueryUi.jsp"%>
     <!-- Font Awesome -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">
    <!-- Ionicons -->
    <link rel="stylesheet" href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css">
    <script type="text/javascript">
		function showPageContent(action){
			var pageContent=action;
			switch(pageContent){
			case 1: 
				$("#pageContent").attr('src', '<c:url value ="/View/baseInfo/Index.jsp"/>') ;
				break;
			case 2: 
				$("#pageContent").attr('src', '<c:url value ="/View/security/user/Index.jsp"/>') ;
				break;
			case 3: 
				$("#pageContent").attr('src', '<c:url value ="/View/core/goods/products/book/Index.jsp"/>') ;
				break;
			case 4: 
				$("#pageContent").attr('src', '<c:url value ="/View/core/publisher/Index.jsp"/>') ;
				break;
			case 5: 
				$("#pageContent").attr('src', '<c:url value ="/View/core/order/Index.jsp"/>') ;
				break;
			case 6: 
				$("#pageContent").attr('src', '<c:url value ="/View/core/menu/MenuTree.jsp"/>') ;
				break;
			
			}
			}	
		function closeModal(){
			}
		function openMainPage(){
			window.open(
			  '<c:url value ="/View/frontEnd/homePage/Index.jsp"/>',
			  '_blank' 
			);

			
			
		}

		

    </script>
<title>داشبورد مدیریت</title>
</head>
<body class="hold-transition skin-blue sidebar-mini">
	 <div class="wrapper">

      <!-- Main Header -->
      <header class="main-header">

        <!-- Logo -->
        <a href="index2.html" class="logo">
          <!-- mini logo for sidebar mini 50x50 pixels -->
          <span class="logo-mini"><b>A</b>LT</span>
          <!-- logo for regular state and mobile devices -->
          <span class="logo-lg"><b>داشبورد مدیریت</b></span>
        </a>

        <!-- Header Navbar -->
        <nav class="navbar navbar-static-top" role="navigation">
          <!-- Sidebar toggle button-->
          <a href="#" class="sidebar-toggle" data-toggle="offcanvas" role="button">
            <span class="sr-only">Toggle navigation</span>
          </a>
          <!-- Navbar Right Menu -->
          <div class="navbar-custom-menu">
            <ul class="nav navbar-nav">
            </ul>
          </div>
        </nav>
      </header>
      <!-- Left side column. contains the logo and sidebar -->
      <aside class="main-sidebar">

        <!-- sidebar: style can be found in sidebar.less -->
        <section class="sidebar">

          <!-- Sidebar user panel (optional) -->
          <div class="user-panel">
            <div class="pull-left image">
              <img src="dist/img/user2-160x160.jpg" class="img-circle" alt="User Image">
            </div>
          </div> 


          <!-- Sidebar Menu -->
          <ul class="sidebar-menu">
            <li class="header">منو</li>
            <!-- Optionally, you can add icons to the links -->
            <li class="active"> <a href="#"><i class="fa fa-link"> <span  onclick="showPageContent(1);">فرم اطلاعات پایه</span></i></a></li>
            <li><a href="#"><i class="fa fa-link"></i> <span onclick="showPageContent(2);">مدیریت کاربران</span></a></li>
            <li><a href="#"><i class="fa fa-link"></i> <span onclick="showPageContent(3);">مدیریت کتاب</span></a></li>
            <li><a href="#"><i class="fa fa-link"></i> <span onclick="showPageContent(4);">مدیریت انتشارات</span></a></li>
            <li><a href="#"><i class="fa fa-link"></i> <span onclick="showPageContent(5);">مدیریت و پیگیری سفارشات</span></a></li>
            <li><a href="#"><i class="fa fa-link"></i> <span onclick="showPageContent(6);">مدیریت منو</span></a></li>
             <li><a href="#" onclick="openMainPage()"><i class="fa fa-link"></i> مشاهده صفحه اصلی</a></li>
             <li><a href="<c:url value="/logout" />" ><i class="fa fa-link"></i> خروج</a></li>
          </ul><!-- /.sidebar-menu -->
        </section>
        <!-- /.sidebar -->
      </aside>

      <!-- Content Wrapper. Contains page content -->
      <div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <section class="content-header">
          <h1>
           داشبورد مدیریت
          </h1>
        </section>

        <!-- Main content -->
        <section class="content">

          <iframe id="pageContent" src="" style="width: 100%;height: 700px;"/>

        </section><!-- /.content -->
      </div><!-- /.content-wrapper -->

      <!-- Main Footer -->
      <footer class="main-footer">
        <!-- To the right -->
        <div class="pull-right hidden-xs">
          Anything you want
        </div>
        <!-- Default to the left -->
        <strong>Copyright &copy; 2015 <a href="#">Company</a>.</strong> All rights reserved.
      </footer>

      <!-- Control Sidebar -->
      <aside class="control-sidebar control-sidebar-dark">
        <!-- Create the tabs -->
        <ul class="nav nav-tabs nav-justified control-sidebar-tabs">
          <li class="active"><a href="#control-sidebar-home-tab" data-toggle="tab"><i class="fa fa-home"></i></a></li>
          <li><a href="#control-sidebar-settings-tab" data-toggle="tab"><i class="fa fa-gears"></i></a></li>
        </ul>
        <!-- Tab panes -->
        <div class="tab-content">
          <!-- Home tab content -->
          <div class="tab-pane active" id="control-sidebar-home-tab">
            <h3 class="control-sidebar-heading">Recent Activity</h3>
            <ul class="control-sidebar-menu">
              <li>
                <a href="javascript::;">
                  <i class="menu-icon fa fa-birthday-cake bg-red"></i>
                  <div class="menu-info">
                    <h4 class="control-sidebar-subheading">Langdon's Birthday</h4>
                    <p>Will be 23 on April 24th</p>
                  </div>
                </a>
              </li>
            </ul><!-- /.control-sidebar-menu -->

            <h3 class="control-sidebar-heading">Tasks Progress</h3>
            <ul class="control-sidebar-menu">
              <li>
                <a href="javascript::;">
                  <h4 class="control-sidebar-subheading">
                    Custom Template Design
                    <span class="label label-danger pull-right">70%</span>
                  </h4>
                  <div class="progress progress-xxs">
                    <div class="progress-bar progress-bar-danger" style="width: 70%"></div>
                  </div>
                </a>
              </li>
            </ul><!-- /.control-sidebar-menu -->

          </div><!-- /.tab-pane -->
          <!-- Stats tab content -->
          <div class="tab-pane" id="control-sidebar-stats-tab">Stats Tab Content</div><!-- /.tab-pane -->
          <!-- Settings tab content -->
          <div class="tab-pane" id="control-sidebar-settings-tab">
            <form method="post">
              <h3 class="control-sidebar-heading">General Settings</h3>
              <div class="form-group">
                <label class="control-sidebar-subheading">
                  Report panel usage
                  <input type="checkbox" class="pull-right" checked>
                </label>
                <p>
                  Some information about this general settings option
                </p>
              </div><!-- /.form-group -->
            </form>
          </div><!-- /.tab-pane -->
        </div>
      </aside><!-- /.control-sidebar -->
      <!-- Add the sidebar's background. This div must be placed
           immediately after the control sidebar -->
      <div class="control-sidebar-bg"></div>
    </div><!-- ./wrapper -->

    <!-- REQUIRED JS SCRIPTS -->

    <!-- jQuery 2.1.4 -->
    <script src="plugins/jQuery/jQuery-2.1.4.min.js"></script>
    <!-- Bootstrap 3.3.5 -->
    <script src="bootstrap/js/bootstrap.min.js"></script>
    <!-- AdminLTE App -->
    <script src="dist/js/app.min.js"></script>

    <!-- Optionally, you can add Slimscroll and FastClick plugins.
         Both of these plugins are recommended to enhance the
         user experience. Slimscroll is required when using the
         fixed layout. -->
</body>
</html>