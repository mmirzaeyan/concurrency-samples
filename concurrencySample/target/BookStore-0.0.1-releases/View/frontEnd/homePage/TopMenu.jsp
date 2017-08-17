<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!------------- top menu -------------->
<div id="topMenu" class="navbar" style="background-color: #f5ed99">
	<div id="innerMenu" class="navbar-inner">
		<div id="menuContainer" class="container">
			<div id="horizentalMenu" class="nav-collapse  ">
				<ul id="menu" class="nav nav-pills clearfix ">
					<li>
						<div class="cd-dropdown-wrapper">
							<a class="cd-dropdown-trigger" href="#0">دسته بندی</a>
							<nav class="cd-dropdown">
								<h2>Title</h2>
								<a href="#0" class="cd-close">Close</a>
								<ul id="menuTrigger" class="cd-dropdown-content">

								</ul>
								<!-- .cd-dropdown-content -->
							</nav>
							<!-- .cd-dropdown -->
						</div> <!-- .cd-dropdown-wrapper -->
					</li>
					<li><a href="">آشنایی با ما</a></li>
					<li><a href="">تماس با ما</a></li>
					<li><a href="">نحوه خرید</a></li>
					<li><a href="../Search">جستجوی پیشرفته</a></li>

				</ul>
			</div>
		</div>
	</div>
</div>
<script language="javascript" type="text/javascript">
    var menuRestUrl = "<c:url value = '/rest/core/menu'/>";

    $(function() {
        loadMenu();
    });

    function runner(parent,items){
        var p = parent;
        $.each(items,function(){
            var li = "<li class='has-children'><a class='' href='#' onclick='goToSearch("+this.id+")'>" + this.title + "</a>";
            p = p + li;
            if(this.items && this.items.length > 0){
                var firstLevelChild = this.items;
                p = p + "<ul class='cd-secondary-dropdown is-hidden'>"
                var ChildItems = "";
                for (i = 0; i < firstLevelChild.length; i++) {
                    ChildItems = ChildItems + "<li class='has-children'><a class='' href='#' onclick='goToSearch("+firstLevelChild[i].id+")'>" + firstLevelChild[i].title + "</a>";
                    if (firstLevelChild[i].items && firstLevelChild[i].items.length > 0) {
                        var secondLevelChild = firstLevelChild[i].items;
                        ChildItems = ChildItems + "<ul class='is-hidden'>";
                        for (j = 0; j < secondLevelChild.length; j++) {
                            ChildItems = ChildItems + "<li><a class='' href='#' onclick='goToSearch("+secondLevelChild[j].id+")'>" + secondLevelChild[j].title + "</a></li>";
                        }
                        ChildItems = ChildItems +  "</ul></li>";
                    } else {
                        ChildItems = ChildItems + "</li>";
                    }
                }
                p = p + ChildItems + "</ul>";
            }
            p = p + "</li>";
        });
        return p;
    }




    var nariman = function(menuJsonData){
        var source = [];
        var newArray = new Array();
        for(i=0; i < menuJsonData.length ; i++){
            if(menuJsonData[i].parentId == 1){
                source[i] = {
                    id			:menuJsonData[i].id ,
                    parentId	:menuJsonData[i].parentId,
                    title		:menuJsonData[i].title,
                    items		:[]};
                if(menuJsonData[i].items && menuJsonData[i].items.length > 0){
                    for(j=0 ; j < menuJsonData[i].items.length ; j++){
                        source[i].items[j] = {
                            id			:menuJsonData[i].items[j].id ,
                            parentId	:menuJsonData[i].items[j].parentId,
                            title		:menuJsonData[i].items[j].title,
                            items		:[]};
                        if(menuJsonData[i].items[j].items && menuJsonData[i].items[j].items.length > 0){
                            for(c=0 ; c < menuJsonData[i].items[j].items.length ; c++){
                                source[i].items[j].items[c] = {
                                    id			:menuJsonData[i].items[j].items[c].id ,
                                    parentId	:menuJsonData[i].items[j].items[c].parentId,
                                    title		:menuJsonData[i].items[j].items[c].title};
                            }
                        }
                    }
                }
                newArray.push(source[i]);
            }
        }
        return newArray;
    }

    function loadMenu(){
        $.getJSON(menuRestUrl + "/front/list/getAll" ,null,
            function(entities){
                if(entities){
                    var menuJsonData = entities;
                    var source = nariman(menuJsonData);
                    var li = " ";
                    var menuHtml = runner(li, source);
                    $("#menuTrigger").html(menuHtml)
                    initMegaMenu();
                }
            })
    }

    function goToSearch(menuId) {
        window.location = "<c:url value ='/search?menuId=" + menuId + "'/>";
    }
</script>
<!------------- top menu -------------->