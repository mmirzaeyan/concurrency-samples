/**
 * 
 */
/*$(function(){	
	$('.money').live('onkeydown',function(){
		money(this);
	});
	
}); */
function moneySeparator(field) {
	var price;
	price = "";
	while (field.value.indexOf(",") != -1) {
		field.value = field.value.replace(",", "");
	}
	txt_field = document.getElementById("ttd");
	txt_field = field.value.length;
	var counter = 0;
	for ( var i = txt_field - 1; i >= 0; i--) {
		price = field.value.charAt(i) + price;
		counter++;
		if (counter % 3 == 0 && i > 0) {
			price = "," + price;
			counter = 0;
		}
	}
	field.value = price;
}

function stringMoneySeparator(field) {
	var price;
	price = "";

	txt_field = document.getElementById("ttd");
	//alert(field.length);
	txt_field = field.length;
	var counter = 0;
	for ( var i = txt_field - 1; i >= 0; i--) {
		price = field.charAt(i) + price;
		counter++;
		if (counter % 3 == 0 && i > 0) {
			price = "," + price;
			counter = 0;
		}
	}
	return price;
}