var clonedHeaderRow;
$(window).scroll(updateTableHeaders).trigger("scroll");
$(window).resize(floatingHeader);

function floatingHeader() {
	if ($(".fixHeader").length < 0) {
		return false;
	}
	$(".floatingHeader").remove();
	$(".grid").each(function() {
		clonedHeaderRow = $(".fixHeader", this);
		clonedHeaderRow.before(clonedHeaderRow.clone()).css("width", clonedHeaderRow.width()).addClass("floatingHeader");
	});
	var gridHeader = $(".fixHeader th");
	var floatingHeader = $(".floatingHeader th");
	var columnCount = 0;
	var gridHeaderColumnCount = gridHeader.length;
	while (columnCount < gridHeaderColumnCount) {
		floatingHeader.width(gridHeader.first().width());
		gridHeader = gridHeader.next();
		floatingHeader = floatingHeader.next();
		columnCount++;
	}
	updateTableHeaders();
}

function updateTableHeaders() {
	if ($(".fixHeader").length < 0) {
		return false;
	}
	$(".grid").each(function() {
		var el = $(this);
		var offset = el.offset();
		var scrollTop = $(window).scrollTop();
		var floatingHeader = $(".floatingHeader", this);
		if ((scrollTop > offset.top)) {
			floatingHeader.css({
				"visibility" : "visible"
			});
		} else {
			floatingHeader.css({
				"visibility" : "hidden"
			});
		}
	});
}