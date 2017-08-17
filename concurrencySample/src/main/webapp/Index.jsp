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

	function updatePostWithDelay(){
		$.ajax({
			type : "POST",
			url : "/rest/post/updatePostWithWait", 
			contentType : "application/json;",
			dataType : "json",
			success : function(res) {
				alert(res);
			}
		});
	}

	function updatePost(){
		$.ajax({
			type : "POST",
			url : "/rest/post/updatePost",
			contentType : "application/json;",
			dataType : "json",
			success : function(res) {
				alert(res);
			}
		});
	}


	function updatePostAndRollback(){
		$.ajax({
			type : "POST",
			url : "/rest/post/updatePostAndRollback",
			contentType : "application/json;",
			dataType : "json",
			success : function(res) {
				alert(res);
			}
		});
	}

	

	function updatePostWithWaitSerializable(){
		$.ajax({
			type : "POST",
			url : "/rest/post/updatePostWithWaitSerializable", 
			contentType : "application/json;",
			dataType : "json",
			success : function(res) {
				alert(res);
			}
		});	
	}

	function updatePostSerializable(){
		$.ajax({
			type : "POST",
			url : "/rest/post/updatePostSerializable",
			contentType : "application/json;",
			dataType : "json",
			success : function(res) {
				alert(res);
			}
		});
	}

	function updatePostDatabselockWithWait(){
		$.ajax({
			type : "POST",
			url : "/rest/post/updatePostDatabselockWithWait",
			contentType : "application/json;",
			dataType : "json",
			success : function(res) {
				alert(res);
			}
		});
	}

	function updatePostDatabselock(){
		$.ajax({
			type : "POST",
			url : "/rest/post/updatePostDatabselock",
			contentType : "application/json;",
			dataType : "json",
			success : function(res) {
				alert(res);
			}
		});
	}


	function saveToShowIncreamentTheVersion(){
		$.ajax({
			type : "POST",
			url : "/rest/postComment/saveToShowIncreamentTheVersion",
			contentType : "application/json;",
			dataType : "json",
			success : function(res) {
				alert(res);
			}
		});

	}
</script>
</head>
<body align="center">

<table border="2" style="width: 100%;"> 
	<tr>
		<td colspan="3" align="center">
			<h3>Some of Concurrency Samples </h3>
		</td>
	</tr>
	<tr>
		<td align="center" colspan="3">List of Samples  </td>
	</tr>
	<tr>
		<td> to see read commited & dirty read push the first transaction and secound transaction - the action is on Post Model </td>
		<td> 
			<input type="button" value="startFirstTransaction"	 onclick="savePostWithDelay()"/>
		</td>
		<td> 
			<input type="button" value="startSecoundTransaction" onclick="toSeeReadUncommited()" /> 
		</td>
	</tr>

	<tr>
		<td>
			to see lost update & dirty wirte push the first transaction and secound transaction - isolation level is Read Committed - the action is on Post Model
		 </td>
		<td> 
			<input type="button" value="startFirstTransaction"	 onclick="updatePostWithDelay()"/>
		</td>
		<td> 
			<input type="button" value="startSecoundTransaction" onclick="updatePost()" /> 
		</td>
	</tr>
	<tr>
		<td>
		 	to see lost update and dirty write push the first transaction and secound transaction - isolation level is Serializable read and it's prevent it. -
		 	the action is on Post Model
		 </td>
		<td> 
			<input type="button" value="startFirstTransaction"	 onclick="updatePostWithWaitSerializable()"/>
		</td>
		<td>
			<input type="button" value="startSecoundTransaction" onclick="updatePostSerializable()" /> 
		</td>
	</tr>

	<tr>
		<td>
			 to see manage concurrenct just with database lock on a row  - isolation level is Read Commited  and it's database explicit lock prevent it not isolation-
		 	remember that mysql does not have for update no wait solution - the action is on Post Model
		 </td>
		<td> 
			<input type="button" value="startFirstTransaction"	 onclick="updatePostDatabselockWithWait()"/>
		</td>
		<td> 
			<input type="button" value="startSecoundTransaction" onclick="updatePostDatabselock()" /> 
		</td>
	</tr>
	
	<tr>
		<td>
			 to see Version field behavior with hibernate , after any transaction on postComment Object the version field will ++ 
		 </td>
		<td colspan="2"> 
			<input type="button" value="savePostComment"	 onclick="saveToShowIncreamentTheVersion()"/>
		</td>
	</tr>
	
	<tr>
		<td>To see that adding version field will prevent lost update & dirty write with read committed isolation level that is one of low level isolation </td>
		<td> 
			<input type="button" value="startFirstTransaction"	 onclick="savePostWithDelay()"/>
		</td>
		<td> 
			<input type="button" value="startSecoundTransaction" onclick="toSeeReadUncommited()" /> 
		</td>
	</tr>
	<tr>
		<td>To see that dirty write and first transaction rollback - the databse understand that a newer version of resource exist and dont wirte on this new version </td>
		<td> 
			<input type="button" value="startFirstTransaction"	 onclick="updatePostAndRollback()"/>
		</td>
		<td> 
			<input type="button" value="startSecoundTransaction" onclick="updatePost()" /> 
		</td>
	</tr>

</table>
</body>
</html>
