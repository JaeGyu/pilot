<%@page import="java.util.Date" import="java.sql.*"%>
<html>
<head>
<title>Chat</title>
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.8.0/jquery.min.js"></script>
<script>
	var emptyChk = function() {
		if (user_id.value == "" || message.value == "") {
			alert("Empty field!");
		}
	};
	
	$(function(){
		$('#message').focus();
	});
</script>
</head>
<body>
	<%
		String userId = request.getParameter("user_id");
		String rowCount = request.getParameter("row_count");
		if (rowCount == null || rowCount.isEmpty()) {
			rowCount = "10";
		}
		String message = request.getParameter("message");
	%>
	<form method="post">
		<table>
			<tr>
				<td>ID:</td>
				<%
					out.println("<td><input type=\"text\" name=\"user_id\" id=\"user_id\" value=\""
							+ (userId == null ? "" : userId) + "\"/></td>");
				%>
				<td></td>
			</tr>
			<tr>
				<td>Row Count</td>
				<%
					out.println("<td><input type=\"text\" name=\"row_count\" id=\"row_count\" value=\""
							+ rowCount + "\"/></td>");
				%>
				<td></td>
			</tr>
			<tr>
				<td>Message:</td>
				<td><input type="text" name="message" id="message" /></td>
				<td><input type="submit" value="Send" onClick="emptyChk()" /></td>
			</tr>
		</table>
	</form>
	<%
		Class.forName("org.gjt.mm.mysql.Driver");

		Connection con = null;
		ResultSet rs = null;
		Statement stmt = null;

		String url = "jdbc:mysql://127.0.0.1/db_ctb?user=ctb&password=cTb0409";
		con = DriverManager.getConnection(url);
		stmt = con.createStatement();

		if (userId != null && !userId.isEmpty() && message != null
				&& !message.isEmpty()) {
			stmt.executeUpdate("insert into tb_chat_message (created_time, user_id, message) values (now(), '"
					+ userId + "', '" + message + "')");
		}
	%>

	<table border="1" cellspacing="0" cellpadding="3">
		<tr>
			<th width="100">Time</th>
			<th width="100">User ID</th>
			<th width="500">Message</th>
		</tr>
		<%
			rs = stmt
					.executeQuery("select * from tb_chat_message order by id desc limit "
							+ rowCount);
			while (rs.next()) {
				Timestamp createdTime = rs.getTimestamp("created_time");
				userId = rs.getString("user_id");
				message = rs.getString("message");

				out.print("<tr><td>" + createdTime + "</td><td>" + userId
						+ "</td><td>" + message + "</td></tr>");
			}
			stmt.close();
			con.close();
		%>
	</table>
</body>
</html>