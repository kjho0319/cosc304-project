
<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="escape.jspf" %>

<!DOCTYPE html>
<html>
<head>
    <title>Jun and Logan's Grocery</title>
</head>
<body>

<h1>Search for the products you want to buy:</h1>

<%
// Read search and sort values before the form so the form can keep them
String name = request.getParameter("productName");
String sort = request.getParameter("sort");
if (name == null) name = "";
if (sort == null) sort = "name";
%>

<form method="get" action="listprod.jsp">
    <input type="text" name="productName" size="50" value="<%= escapeHtml(name) %>">
    <select name="sort">
        <option value="name" <%= sort.equals("name") ? "selected" : "" %>>Name (A-Z)</option>
        <option value="price_asc" <%= sort.equals("price_asc") ? "selected" : "" %>>Price: Low to High</option>
        <option value="price_desc" <%= sort.equals("price_desc") ? "selected" : "" %>>Price: High to Low</option>
    </select>
    <input type="submit" value="Submit">
    <input type="reset" value="Reset">
    (Leave blank for all products)
</form>

<%
Connection con = null;
PreparedStatement pstmt = null;
ResultSet rst = null;

try {
    con = getConnection();

    NumberFormat currFormat = NumberFormat.getCurrencyInstance();

    String sql = "SELECT productId, productName, productPrice FROM product";

    if (!name.trim().isEmpty()) {
        sql += " WHERE productName LIKE ?";
    }

    // Only hardcoded ORDER BY strings are used, so user input never goes into the SQL
    String orderBy;
    if (sort.equals("price_asc")) {
        orderBy = " ORDER BY productPrice ASC, productName";
    } else if (sort.equals("price_desc")) {
        orderBy = " ORDER BY productPrice DESC, productName";
    } else {
        orderBy = " ORDER BY productName";
    }
    sql += orderBy;

    pstmt = con.prepareStatement(sql);

    if (!name.trim().isEmpty()) {
        pstmt.setString(1, "%" + name.trim() + "%");
    }

    rst = pstmt.executeQuery();

    out.println("<h2>Products</h2>");
    out.println("<table border='1'>");
    out.println("<tr>");
    out.println("<th>Product Id</th>");
    out.println("<th>Product Name</th>");
    out.println("<th>Price</th>");
    out.println("<th>Action</th>");
    out.println("</tr>");

    while (rst.next()) {

        int productId = rst.getInt("productId");
        String productName = rst.getString("productName");
        double productPrice = rst.getDouble("productPrice");

        String encodedName = URLEncoder.encode(productName, "UTF-8");

        out.println("<tr>");

        out.println("<td>" + productId + "</td>");

        // Product name links to product details page
        out.println("<td><a href='product.jsp?id=" + productId + "'>"
            + escapeHtml(productName) + "</a></td>");

        out.println("<td>" + currFormat.format(productPrice) + "</td>");

        // Existing Add to Cart link remains unchanged
        out.println("<td><a href='addcart.jsp?id=" + productId
            + "&name=" + encodedName
            + "&price=" + productPrice + "'>Add to Cart</a></td>");

        out.println("</tr>");
    }

    out.println("</table>");

} catch (SQLException e) {
    application.log("Error retrieving products", e);
    out.println("Error retrieving products.");
} finally {

    if (rst != null) {
        try { rst.close(); } catch (SQLException e) {}
    }

    if (pstmt != null) {
        try { pstmt.close(); } catch (SQLException e) {}
    }

    if (con != null) {
        try { con.close(); } catch (SQLException e) {}
    }
}
%>

</body>
</html>
