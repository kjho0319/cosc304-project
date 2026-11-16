<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ include file="auth.jsp" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="escape.jspf" %>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><title>Customer Information</title></head>
<body>
<h1>Customer Information</h1>
<%
String userName = (String) session.getAttribute("authenticatedUser");

// TODO: Use a PreparedStatement to retrieve information for the logged-in
//       customer, using customer.userid = userName (NOT a customer ID from
//       the query string). Display the customer's information.
//       Use getConnection() and try-with-resources to close database objects.
%>
<p><a href="index.jsp">Main Page</a></p>
</body>
</html>
