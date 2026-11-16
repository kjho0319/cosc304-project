<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="escape.jspf" %>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><title>Shipment Processing</title></head>
<body>
<%@ include file="header.jsp" %>
<h2>Process Shipment</h2>
<%
String orderIdText = request.getParameter("orderId");

// TODO: Validate orderId and check that the order exists.
// TODO: Open a connection with getConnection() and turn off auto-commit.
// TODO: Retrieve all orderproduct rows for this order.
// TODO: Create a shipment record for warehouseId = 1.
// TODO: For EACH product, confirm the warehouse has enough quantity and
//       subtract the ordered amount from productinventory.
// TODO: Commit ONLY when all operations succeed.
// TODO: On insufficient stock or other failure, roll back EVERYTHING,
//       including the shipment record and any preceding inventory changes.
// TODO: Display a useful success or failure message; close all resources.
// Note: do not enable auto-commit before calling commit() or rollback().
//       The connection is closed automatically when using try-with-resources.
%>
<p><a href="index.jsp">Main Page</a></p>
</body>
</html>
