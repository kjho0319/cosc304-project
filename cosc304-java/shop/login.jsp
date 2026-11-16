<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="escape.jspf" %>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><title>Log In</title></head>
<body>
<h1>Log In</h1>
<%
String loginMessage = (String) session.getAttribute("loginMessage");
session.removeAttribute("loginMessage");
if (loginMessage != null)
    out.println("<p>" + escapeHtml(loginMessage) + "</p>");
%>
<form method="post" action="validateLogin.jsp">
    <p><label for="username">User ID:</label>
       <input id="username" name="username" type="text" maxlength="20" required></p>
    <p><label for="password">Password:</label>
       <input id="password" name="password" type="password" maxlength="30" required></p>
    <p><button type="submit">Log In</button></p>
</form>
<p><a href="index.jsp">Main Page</a></p>
</body>
</html>
