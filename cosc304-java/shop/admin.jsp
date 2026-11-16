<%@ page import="java.sql.*,java.math.BigDecimal,java.text.NumberFormat,java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="escape.jspf" %>
<%-- TODO: Include auth.jsp HERE, before any HTML output, to require login. --%>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><title>Administrator Report</title></head>
<body>
<h1>Administrator Report</h1>
<%
// TODO: Use getConnection() and a SQL query to show total sales for each day.
//       Group orders by the date portion of orderDate and sum totalAmount.
//       Display the results in an HTML table.
//       Use try-with-resources for the connection, statement, and result set.
%>
<p><a href="index.jsp">Main Page</a></p>
</body>
</html>
