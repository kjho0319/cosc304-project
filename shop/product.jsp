<%@ page import="java.sql.*,java.math.BigDecimal,java.text.NumberFormat,java.util.Locale" %>
<%@ page import="java.net.URLEncoder,java.nio.charset.StandardCharsets" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="escape.jspf" %>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><title>Product Details</title></head>
<body>
<%@ include file="header.jsp" %>
<h2>Product Details</h2>
<%
String productIdText = request.getParameter("id");

// TODO: Validate that "id" identifies a positive integer product ID.
// TODO: Use a PreparedStatement with getConnection() to retrieve productName,
//       productPrice, productDesc, productImageURL, and productImage by ID.
// TODO: Show an appropriate message for an invalid or unknown product ID.
// TODO: Display product details, escaping text inserted into HTML.
// TODO: If productImageURL is present, display it with <img src="...">.
// TODO: If a binary productImage exists, display it with an <img> tag whose
//       src is "displayImage.jsp?id=<productId>".
// TODO: Provide an Add to Cart link using the existing Lab 7 URL parameters:
//       addcart.jsp?id=<id>&name=<URL-encoded name>&price=<price>
//       URLEncoder.encode(name, StandardCharsets.UTF_8) is available above.
%>
<p><a href="listprod.jsp">Continue Shopping</a> |
   <a href="index.jsp">Main Page</a></p>
</body>
</html>
