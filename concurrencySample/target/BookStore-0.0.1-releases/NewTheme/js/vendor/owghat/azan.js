function showdate() {
	a = new Date();
	d = a.getDay();
	day = a.getDate();
	joomlacmsmonth = a.getMonth() + 1;
	year = a.getYear();
	year = (year == 0) ? 2000 : year;
	(year < 1000) ? (year += 2000) : true;
	year -= ((joomlacmsmonth < 3) || ((joomlacmsmonth == 3) && (day < 21))) ? 622 : 621;
	switch (joomlacmsmonth) {
	case 1:
		(day < 21) ? (joomlacmsmonth = 10, day += 10) : (joomlacmsmonth = 11, day -= 20);
		break;
	case 2:
		(day < 20) ? (joomlacmsmonth = 11, day += 11) : (joomlacmsmonth = 12, day -= 19);
		break;
	case 3:
		(day < 21) ? (joomlacmsmonth = 12, day += 9) : (joomlacmsmonth = 1, day -= 20);
		break;
	case 4:
		(day < 21) ? (joomlacmsmonth = 1, day += 11) : (joomlacmsmonth = 2, day -= 20);
		break;
	case 5:
	case 6:
		(day < 22) ? (joomlacmsmonth -= 3, day += 10) : (joomlacmsmonth -= 2, day -= 21);
		break;
	case 7:
	case 8:
	case 9:
		(day < 23) ? (joomlacmsmonth -= 3, day += 9) : (joomlacmsmonth -= 2, day -= 22);
		break;
	case 10:
		(day < 23) ? (joomlacmsmonth = 7, day += 8) : (joomlacmsmonth = 8, day -= 22);
		break;
	case 11:
	case 12:
		(day < 22) ? (joomlacmsmonth -= 3, day += 9) : (joomlacmsmonth -= 2, day -= 21);
		break;
	default:
		break;
	}
	document.getElementById("azanday").value = day;
	document.getElementById("azanjoomlacmsmonth").value = joomlacmsmonth;
}
function main() {
	showdate();
	var i = document.getElementById("cities").selectedIndex;
		var m = document.getElementById("azanjoomlacmsmonth").value;
	var d = eval(document.getElementById("azanday").value);
	var lg = eval(document.getElementById("longitude").value);
	var lat = eval(document.getElementById("latitude").value);
	var ep = sun(m, d, 4, lg)
		var zr = ep[0];
	delta = ep[1];
	ha = loc2hor(108.0, delta, lat)
		var t1 = Round(zr - ha, 24)
		ep = sun(m, d, t1, lg)
		zr = ep[0];
	delta = ep[1];
	ha = loc2hor(108.0, delta, lat)
		var t1 = Round(zr - ha + 0.025, 24)

		document.getElementById("azan_t1").innerHTML = hms(t1);
	document.getElementById("azan_ht1").value = hhh(t1);
	document.getElementById("azan_mt1").value = mmm(t1);
	ep = sun(m, d, 6, lg)
		zr = ep[0];
	delta = ep[1];
	ha = loc2hor(90.833, delta, lat)
		var t2 = Round(zr - ha, 24)
		ep = sun(m, d, t2, lg)
		zr = ep[0];
	delta = ep[1];
	ha = loc2hor(90.833, delta, lat)
		t2 = Round(zr - ha + 0.008, 24)

		document.getElementById("azan_t2").innerHTML = hms(t2);
	document.getElementById("azan_ht2").value = hhh(t2);
	document.getElementById("azan_mt2").value = mmm(t2);
	ep = sun(m, d, 12, lg)
		ep = sun(m, d, ep[0], lg)
		zr = ep[0] + 0.01;

	document.getElementById("azan_t3").innerHTML = hms(zr);
	document.getElementById("azan_ht3").value = hhh(zr);
	document.getElementById("azan_mt3").value = mmm(zr);
	ep = sun(m, d, 18, lg)
		zr = ep[0];
	delta = ep[1];
	ha = loc2hor(90.833, delta, lat)
		var t3 = Round(zr + ha, 24)
		ep = sun(m, d, t3, lg)
		zr = ep[0];
	delta = ep[1];
	ha = loc2hor(90.833, delta, lat)
		t3 = Round(zr + ha - 0.014, 24)
		document.getElementById("azan_t4").innerHTML = hms(t3);
	document.getElementById("azan_ht4").value = hhh(t3);
	document.getElementById("azan_mt4").value = mmm(t3);
	ep = sun(m, d, 18.5, lg)
		zr = ep[0];
	delta = ep[1];
	ha = loc2hor(94.3, delta, lat)
		var t4 = Round(zr + ha, 24)
		ep = sun(m, d, t4, lg)
		zr = ep[0];
	delta = ep[1];
	ha = loc2hor(94.3, delta, lat)
		t4 = Round(zr + ha + 0.013, 24)
		document.getElementById("azan_t5").innerHTML = hms(t4);
	document.getElementById("azan_ht5").value = hhh(t4);
	document.getElementById("azan_mt5").value = mmm(t4);
	setTimeout("main()", 60000);
	shownow();
}
function sun(m, d, h, lg) {
	if (m < 7)
		d = 31 * (m - 1) + d + h / 24;
	else
		d = 6 + 30 * (m - 1) + d + h / 24;
	var M = 74.2023 + 0.98560026 * d;
	var L = -2.75043 + 0.98564735 * d;
	var lst = 8.3162159 + 0.065709824 * Math.floor(d) + 1.00273791 * 24 * (d % 1) + lg / 15;
	var e = 0.0167065;
	var omega = 4.85131 - 0.052954 * d;
	var ep = 23.4384717 + 0.00256 * cosd(omega);
	var ed = 180.0 / Math.PI * e;
	var u = M;
	for (var i = 1; i < 5; i++)
		u = u - (u - ed * sind(u) - M) / (1 - e * cosd(u));
	var v = 2 * atand(tand(u / 2) * Math.sqrt((1 + e) / (1 - e)));
	var theta = L + v - M - 0.00569 - 0.00479 * sind(omega);
	var delta = asind(sind(ep) * sind(theta));
	var alpha = 180.0 / Math.PI * Math.atan2(cosd(ep) * sind(theta), cosd(theta));
	if (alpha >= 360)
		alpha -= 360;
	var ha = lst - alpha / 15;
	var zr = Round(h - ha, 24);
	return ([zr, delta])
}
function init() {
	lgs = [0, 49.70, 48.30, 45.07, 51.64, 48.68, 46.42, 57.33, 56.29, 50.84, 59.21, 46.28, 51.41, 48.34, 49.59, 60.86, 48.50, 53.06, 53.39, 47.00, 50.86, 52.52, 50.00, 50.88, 57.06, 47.09, 54.44, 59.58, 48.52, 51.59, 54.35];
	lats = [0, 34.09, 38.25, 37.55, 32.68, 31.32, 33.64, 37.47, 27.19, 28.97, 32.86, 38.08, 35.70, 33.46, 37.28, 29.50, 36.68, 36.57, 35.58, 35.31, 32.33, 29.62, 36.28, 34.64, 30.29, 34.34, 36.84, 36.31, 34.80, 30.67, 31.89];
}
function coord() {
	var c=document.getElementById("cities");
	var i = c.selectedIndex;
	document.getElementById("longitude").value = lgs[i].toString();
	document.getElementById("latitude").value = lats[i].toString();
}
function sind(x) {
	return (Math.sin(Math.PI / 180.0 * x));
}
function cosd(x) {
	return (Math.cos(Math.PI / 180.0 * x));
}
function tand(x) {
	return (Math.tan(Math.PI / 180.0 * x));
}
function atand(x) {
	return (Math.atan(x) * 180.0 / Math.PI);
}
function asind(x) {
	return (Math.asin(x) * 180.0 / Math.PI);
}
function acosd(x) {
	return (Math.acos(x) * 180.0 / Math.PI);
}
function sqrt(x) {
	return (Math.sqrt(x));
}
function frac(x) {
	return (x % 1);
}
function floor(x) {
	return (Math.floor(x));
}
function ceil(x) {
	return (Math.ceil(x));
}
function loc2hor(z, d, p) {
	return (acosd((cosd(z) - sind(d) * sind(p)) / cosd(d) / cosd(p)) / 15);
}
function Round(x, a) {
	var tmp = x % a;
	if (tmp < 0)
		tmp += a;
	return (tmp)
}
function hms(x) {
	x = Math.floor(3600 * x);
	h = Math.floor(x / 3600);
	mp = x - 3600 * h;
	m = Math.floor(mp / 60);
	s = Math.floor(mp - 60 * m);
	return (((h < 10) ? "0" : "") + h.toString() + ":" + ((m < 10) ? "0" : "") + m.toString());
}

function hhh(x) {
	x = Math.floor(3600 * x);
	h = Math.floor(x / 3600);
	mp = x - 3600 * h;
	m = Math.floor(mp / 60);
	s = Math.floor(mp - 60 * m);
	return (((h < 10) ? "0" : "") + h.toString())
}

function mmm(x) {
	x = Math.floor(3600 * x);
	h = Math.floor(x / 3600);
	mp = x - 3600 * h;
	m = Math.floor(mp / 60);
	s = Math.floor(mp - 60 * m);
	return (((m < 10) ? "0" : "") + m.toString())
}

function shownow() {

	today = new Date();
	azan_ttt = new Date();
	azan_ttt.setHours(document.getElementById("azan_ht1").value);
	azan_ttt.setMinutes(document.getElementById("azan_mt1").value);
	if (azan_ttt.getTime() > today.getTime()) {
		diff = azan_ttt.getTime() - today.getTime();
		diff = Math.floor(diff / (1000 * 60));
		hh = Math.floor(diff / (60));
		ss = diff - (hh * 60);
	} else {
		if (azan_ttt.getTime() == today.getTime())
			document.getElementById("pazanbox").innerHTML = "&#1575;&#1584;&#1575;&#1606; &#1589;&#1576;&#1581; &#1576;&#1607; &#1575;&#1601;&#1602; &#1578;&#1607;&#1585;&#1575;&#1606;";
		else {
			azan_ttt = new Date();
			azan_ttt.setHours(document.getElementById("azan_ht2").value);
			azan_ttt.setMinutes(document.getElementById("azan_mt2").value);
			if (azan_ttt.getTime() > today.getTime()) {
				diff = azan_ttt.getTime() - today.getTime();
				diff = Math.floor(diff / (1000 * 60));
				hh = Math.floor(diff / (60));
				ss = diff - (hh * 60)
			} else {
				if (azan_ttt.getTime() != today.getTime()){
					azan_ttt = new Date();
					azan_ttt.setHours(document.getElementById("azan_ht3").value);
					azan_ttt.setMinutes(document.getElementById("azan_mt3").value);
					if (azan_ttt.getTime() > today.getTime()) {
						diff = azan_ttt.getTime() - today.getTime();
						diff = Math.floor(diff / (1000 * 60));
						hh = Math.floor(diff / (60));
						ss = diff - (hh * 60)
					}else{
						if (azan_ttt.getTime() == today.getTime())
							document.getElementById("pazanbox").innerHTML = "&#1575;&#1584;&#1575;&#1606; &#1592;&#1607;&#1585; &#1576;&#1607; &#1575;&#1601;&#1602; &#1578;&#1607;&#1585;&#1575;&#1606;";
						else {
							azan_ttt = new Date();
							azan_ttt.setHours(document.getElementById("azan_ht4").value);
							azan_ttt.setMinutes(document.getElementById("azan_mt4").value);
							if (azan_ttt.getTime() > today.getTime()) {
									diff = azan_ttt.getTime() - today.getTime();
								diff = Math.floor(diff / (1000 * 60));
								hh = Math.floor(diff / (60));
								ss = diff - (hh * 60)
							} else {
								if (azan_ttt.getTime() != today.getTime()) {
									azan_ttt = new Date();
									azan_ttt.setHours(document.getElementById("azan_ht5").value);
									azan_ttt.setMinutes(document.getElementById("azan_mt5").value);
									if (azan_ttt.getTime() > today.getTime()) {
											diff = azan_ttt.getTime() - today.getTime();
										diff = Math.floor(diff / (1000 * 60));
										hh = Math.floor(diff / (60));
										ss = diff - (hh * 60)
									} else {

										if (azan_ttt.getTime() == today.getTime()) {
											document.getElementById("pazanbox").innerHTML = "&#1575;&#1584;&#1575;&#1606; &#1605;&#1594;&#1585;&#1576; &#1576;&#1607; &#1575;&#1601;&#1602; &#1578;&#1607;&#1585;&#1575;&#1606;" ;
										}else{
											azan_ttt = new Date();
											azan_ttt.setHours(23);
											azan_ttt.setMinutes(59);
											diff = azan_ttt.getTime() - today.getTime();
											diff = Math.floor(diff / (1000 * 60));
											hh = Math.floor(diff / (60));
											ss = diff - (hh * 60);
											hh += Math.floor(document.getElementById("azan_ht1").value);
											ss += Math.floor(document.getElementById("azan_mt1").value);
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
}
document.write("<input type=hidden id=latitude  name=latitude><input id=azanday type=hidden name=azanday><input id=azanjoomlacmsmonth type=hidden name=azanjoomlacmsmonth><input  type=hidden id=longitude name=longitude ><input type=hidden id=azan_ht1 name=azan_ht1 ><input type=hidden id=azan_mt1 name=azan_mt1 ><input type=hidden id=azan_ht2 name=azan_ht2 ><input type=hidden id=azan_mt2 name=azan_mt2 ><input type=hidden id=azan_ht3 name=azan_ht3 ><input type=hidden id=azan_mt3 name=azan_mt3 ><input type=hidden id=azan_ht4 name=azan_ht4 ><input type=hidden id=azan_mt4 name=azan_mt4 ><input type=hidden id=azan_ht5 name=azan_ht5 ><input type=hidden id=azan_mt5 name=azan_mt5 >")
document.write('<ul class="list-inline tbox m-0"><li class="tcol"><i class="wi wi-fog fa-3x"></i><p class="text-muted text-center">اذان صبح</p><p class="text-muted text-center"id="azan_t1"></p></li><li class="b-r tcol"><i class="wi wi-sunrise fa-3x"></i><p class="text-muted text-center">طلوع</p><p class="text-muted text-center"id="azan_t2"></p></li><li class="b-r tcol"><i class="wi wi-day-sunny fa-3x fa-spin"></i><p class="text-muted text-center">اذان ظهر</p><p class="text-muted text-center"id="azan_t3"></p></li><li class="b-r tcol"><i class="wi wi-sunset fa-3x"></i><p class="text-muted text-center">غروب</p><p class="text-muted text-center"id="azan_t4"></p></li><li class="b-r tcol"><i class="fa fa-moon-o fa-3x"></i><p class="text-muted text-center">اذان مغرب</p><p class="text-muted text-center"id="azan_t5"></p></li></ul>');