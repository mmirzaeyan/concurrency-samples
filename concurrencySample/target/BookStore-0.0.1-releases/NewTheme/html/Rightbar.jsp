<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<aside id="sidebar" class="scheme-darkblue">
	<div id="sidebar-wrap">
		<div class="panel-group slim-scroll" role="tablist">
			<div class="panel panel-default">
				<div class="panel-heading" role="tab">
					<h4 class="panel-title">
						<a data-toggle="collapse" href="#sidebarNav">
							منوی کاربری <i class="fa fa-angle-up"></i>
						</a>
					</h4>
				</div>
				<div id="sidebarNav" class="panel-collapse collapse in" role="tabpanel">
					<div class="panel-body">
						<ul id="navigation">
							<li>
								<a id="dashboardRightbarLink"  onclick="loadDashboard(true)" style="cursor: pointer">
									<i class="fa fa-dashboard"></i> <span>داشبورد</span>
								</a>
							</li>
						</ul>
					</div>
				</div>
			</div>
		</div>
	</div>
</aside>

<script>
	$(function() {
		$.ajax({
			url : "<c:url value='/rest/menu/MenuItem/listMenu/1'/>",
			type : 'GET',
			async : false,
			dataType : 'json',
			contentType : 'application/json; charset=utf-8',
			success : function(data) {
				$.each(data.childs, function(index, node) {
					var li = $("<li>");
					var a = $("<a>");
					var ul = $("<ul>");
					var i = $("<i>");
					var span = $("<span>");

					$(span).text(node.topic);

					$(i).addClass("fa " + node.icon);

					if (node.attrMap != null && node.attrMap.url != null) {
						$(a).append($(i)).attr("href","<c:url value='"+node.attrMap.url+"'/>");
					} else {
						$(a).append($(i)).attr("href", "#");
					}
					$(a).append($(span));
					$(li).append($(a)).attr("id", "lvl" + node.id);
					$("#navigation").append($(li))
					menuBuild(node, node.id);
				});
			}
		});
	});
	function menuBuild(obj, id) {
		$.each(obj.childs, function(index, node) {
			var li = $("<li>");
			var a = $("<a>");
			var i = $("<i>");
			var ul = $("<ul>");
			$(i).addClass("fa fa-caret-right ");
			if (node.attrMap != null && node.attrMap.url != null) {
				$(a).append($(i)).append(node.topic)
					.attr("onclick","loadDashboard(false);loadFrame('" + node.attrMap.url + "','"+node.menuLayoutStateTitle+"')")
					.css("cursor","pointer");
			} else {
				$(a).append($(i)).append(node.topic).attr("href", "#");
			}
			$(li).append($(a)).attr("id", "lvl" + node.id);
			if (index == 0) {
				$(ul).append($(li)).attr("id", "lvul" + id);
				$("#lvl" + id).append($(ul));
			} else {
				$("#lvul" + id).append($(li));
			}
			menuBuild(node, node.id);
		});
	}
	/* function loadPageInContent(url){
		$.ajax({
			url : url,
			type : 'GET',
			async : true,
			success : function(data, textStatus, jqXhr) {
				$("#content").html(data);
			}
		});	
	} */
</script>
