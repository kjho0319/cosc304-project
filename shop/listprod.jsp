<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="jdbc.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title>Jun and Logan's Grocery</title>
</head>
<body>

<h1>Search for the products you want to buy:</h1>

<form method="get" action="listprod.jsp">
    <input type="text" name="productName" size="50">
    <input type="submit" value="Submit">
    <input type="reset" value="Reset">
    (Leave blank for all products)
</form>

<%

String name = request.getParameter("productName");

Connection con = null;
PreparedStatement pstmt = null; // create all but dont assign values yet
ResultSet rst = null;

try {
    //make the database connection
    con = getConnection();

    //format the prices as currency
    NumberFormat currFormat = NumberFormat.getCurrencyInstance();

    //start building the SQL query
    String sql = "SELECT productId, productName, productPrice FROM product";

    //if they put a specific name value then add a where clause to only get products with those letters/of that name
    if (name != null && !name.trim().isEmpty()) {
        sql += " WHERE productName LIKE ?";
    }

    //order by the productName ASC
    sql += " ORDER BY productName";

    //setup the prepared statement
    pstmt = con.prepareStatement(sql);

    //if the name has a value then trim it to make spaces not mess you up
    if (name != null && !name.trim().isEmpty()) {
        pstmt.setString(1, "%" + name.trim() + "%");
    }

    //execute query
    rst = pstmt.executeQuery();

    //create your table to make it pretty
    out.println("<h2>Products</h2>");
    out.println("<table border='1'>");
    out.println("<tr>");
    out.println("<th>Product Id</th>");
    out.println("<th>Product Name</th>");
    out.println("<th>Price</th>");
    out.println("<th>Action</th>");
    out.println("</tr>");

        //for every product in your resultset
    while (rst.next()) {
        int productId = rst.getInt("productId");
        String productName = rst.getString("productName");//get the id,name, and price of the product
        double productPrice = rst.getDouble("productPrice");


        String encodedName = URLEncoder.encode(productName, "UTF-8");//encode for security

        out.println("<tr>");
        out.println("<td>" + productId + "</td>");//then add them to the table
        out.println("<td>" + productName + "</td>");
        out.println("<td>" + currFormat.format(productPrice) + "</td>");

        //Link to addcart.jsp
        out.println("<td><a href='addcart.jsp?id=" + productId
            + "&name=" + encodedName
            + "&price=" + productPrice + "'>Add to Cart</a></td>");

        out.println("</tr>");
    }

    out.println("</table>");

} catch (SQLException e) {
    out.println("Error connecting to database: " + e.getMessage());
} finally {
    //always close the database resources when you dont need them anymore
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