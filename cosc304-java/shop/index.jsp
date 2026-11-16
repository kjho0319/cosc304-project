<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="escape.jspf" %>
<%
String userName = (String) session.getAttribute("authenticatedUser");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Logan and Jun's Grocery Main Page</title>
</head>
<body>
<h1 align="center">Welcome to Logan and Jun's Grocery</h1>

<h2 align="center"><a href="listprod.jsp">Begin Shopping</a></h2>
<h2 align="center"><a href="listorder.jsp">List All Orders</a></h2>

<% if (userName == null) { %>
<h2 align="center"><a href="login.jsp">Log In</a></h2>
<% } else { %>
<h3 align="center">Signed in as: <%= escapeHtml(userName) %></h3>
<h2 align="center"><a href="logout.jsp">Log Out</a></h2>
<% } %>

<h2 align="center"><a href="customer.jsp">Customer Information</a></h2>
<h2 align="center"><a href="admin.jsp">Administrator Report</a></h2>

<h3 align="center">Shipment Tests</h3>
<p align="center"><a href="ship.jsp?orderId=1">Process order 1</a> |
    <a href="ship.jsp?orderId=3">Process order 3</a></p>
<p align="center"><small>Shipment processing changes inventory once implemented. Use the lab sample database for these tests.</small></p>
</body>
</html>
