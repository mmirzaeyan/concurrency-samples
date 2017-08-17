<html>

<head>
<script type="text/javascript" src="jquery-2.2.2.min.js"></script>
</script>
<script type="text/javascript">
	function savePostWithDelay(){
		$.ajax({
			type : "POST",
			url : "/rest/post/savePostWithDelay",
			contentType : "application/json;",
			dataType : "json",
			success : function(res) {
				alert(res);
			}
		});
	}

	function toSeeReadUncommited(){
		$.getJSON("/rest/post/toSeeReadUncommited", function(entityData) {
			console.log(entityData);
		});
	}

</script>
</head>
<body align="center">
<h3>Some of Concurrency Samples </h3>
<table border="2"> 
<tr>
<td align="center" colspan="3">List of Samples  </td>

<tr>
<tr>
<td> to see read commited push the first transaction and secound transaction </td>
<td> <input type="button" value="startFirstTransaction"	 onclick="savePostWithDelay()"/></td>
<td> <input type="button" value="startSecoundTransaction" onclick="toSeeReadUncommited()" /> </td>
<tr>

</table>
</body>
</html>
