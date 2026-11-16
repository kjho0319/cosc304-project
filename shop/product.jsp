
<%@ page import="java.sql.*,java.math.BigDecimal,java.text.NumberFormat,java.util.Locale" %>
<%@ page import="java.net.URLEncoder,java.nio.charset.StandardCharsets" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="escape.jspf" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Product Details</title>
</head>

<body>

<%@ include file="header.jsp" %>

<h2>Product Details</h2>

<%
String productIdText = request.getParameter("id");

int productId = -1;
boolean validId = false;
boolean productFound = false;
boolean hasBinaryImage = false;

String productName = "";
String productDesc = "";
String productImageURL = "";
BigDecimal productPrice = null;

byte[] productImage = null;

// Validate product ID
try {
    productId = Integer.parseInt(productIdText);

    if (productId > 0) {
        validId = true;
    }
} catch (Exception e) {
    validId = false;
}

// Retrieve product information
if (!validId) {
    out.println("<p>Invalid product ID.</p>");
} else {

    String sql = "SELECT productName, productPrice, productDesc, " +
                 "productImageURL, productImage " +
                 "FROM product WHERE productId = ?";

    try (
        Connection con = getConnection();
        PreparedStatement pstmt = con.prepareStatement(sql)
    ) {

        pstmt.setInt(1, productId);

        try (ResultSet rs = pstmt.executeQuery()) {

            if (rs.next()) {

                productFound = true;

                productName = rs.getString("productName");
                productPrice = rs.getBigDecimal("productPrice");
                productDesc = rs.getString("productDesc");
                productImageURL = rs.getString("productImageURL");

                productImage = rs.getBytes("productImage");

                if (productImage != null && productImage.length > 0) {
                    hasBinaryImage = true;
                }
            }
        }

    } catch (SQLException e) {
        application.log("Error retrieving product details", e);
        out.println("<p>Unable to retrieve product information.</p>");
    }

    if (!productFound) {
        out.println("<p>Product not found.</p>");
    }
}

// Display product information
if (productFound) {

    String safeName = escapeHtml(productName);
    String safeDesc = escapeHtml(productDesc);

    NumberFormat currency = NumberFormat.getCurrencyInstance(Locale.US);
%>

    <h3><%= safeName %></h3>

    <p>
        <strong>Product ID:</strong>
        <%= productId %>
    </p>

    <p>
        <strong>Price:</strong>
        <%= productPrice == null ? "Price unavailable" :
            currency.format(productPrice) %>
    </p>

    <p>
        <strong>Description:</strong>
        <%= safeDesc %>
    </p>

    <%-- Display image using productImageURL --%>

    <% if (productImageURL != null && !productImageURL.trim().isEmpty()) { %>

        <h3>Product Image (URL)</h3>

        <img src="<%= escapeHtml(productImageURL) %>"
             alt="<%= safeName %>"
             style="max-width:300px; max-height:300px;">

    <% } %>

    <%-- Display image stored in the database --%>

    <% if (hasBinaryImage) { %>

        <h3>Product Image (Database)</h3>

        <img src="displayImage.jsp?id=<%= productId %>"
             alt="<%= safeName %>"
             style="max-width:300px; max-height:300px;">

    <% } %>

    <%-- Add to Cart --%>

    <p>
        <% if (productPrice != null) { %>

            <a href="addcart.jsp?id=<%= productId %>&name=<%= URLEncoder.encode(productName, StandardCharsets.UTF_8) %>&price=<%= productPrice.toPlainString() %>">
                Add to Cart
            </a>

        <% } %>
    </p>

<%
}
%>

<hr>

<p>
    <a href="listprod.jsp">Continue Shopping</a> |
    <a href="index.jsp">Main Page</a>
</p>

</body>
</html>
