```jsp
<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="jdbc.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title>Logan and Jun's Grocery Order List</title>
</head>
<body>

<h1>Order List</h1>

<%
Connection con = null;

try {
    // Make connection through  jdbc.jsp
    con = getConnection();

	//puts it into the money fromat witht he $ at the start
    NumberFormat currFormat = NumberFormat.getCurrencyInstance();

    // Retrieve all order summary records and customer names
    String sql =
        "SELECT o.orderId, o.orderDate, o.customerId, " +
        "c.firstName, c.lastName, o.totalAmount " +
        "FROM ordersummary o " +
        "JOIN customer c ON o.customerId = c.customerId " +
        "ORDER BY o.orderId";

		//create the prepared statement then execute it and same the result set
    PreparedStatement pstmt = con.prepareStatement(sql);
    ResultSet rst = pstmt.executeQuery();

    // Query to retrieve products in an order
    String productSQL =
        "SELECT op.productId, p.productName, op.quantity, op.price " +
        "FROM orderproduct op " +
        "JOIN product p ON op.productId = p.productId " +
        "WHERE op.orderId = ?";

		//create second prepared statement for later use
    PreparedStatement pstmt2 = con.prepareStatement(productSQL);

    // and product tables in the required order
    ArrayList<Integer> orderIds = new ArrayList<Integer>();
    ArrayList<String> orderDates = new ArrayList<String>();
    ArrayList<Integer> customerIds = new ArrayList<Integer>();
    ArrayList<String> customerNames = new ArrayList<String>();
    ArrayList<Double> totalAmounts = new ArrayList<Double>();

    // for every order in the result set
    while (rst.next()) {
		//add the info to the correct array list
        orderIds.add(rst.getInt("orderId"));
        orderDates.add(rst.getString("orderDate"));
        customerIds.add(rst.getInt("customerId"));
        customerNames.add(rst.getString("firstName") + " " + rst.getString("lastName"));
        totalAmounts.add(rst.getDouble("totalAmount"));
    }

    rst.close();//close your result set and your prepared statement since we are done using them
    pstmt.close();

    // Print the order summary table
    out.println("<table border='1'>");
    out.println("<tr>");
    out.println("<th>Order Id</th>");
    out.println("<th>Order Date</th>");
    out.println("<th>Customer Id</th>");
    out.println("<th>Customer Name</th>");
    out.println("<th>Total Amount</th>");
    out.println("</tr>");

    // for each order get that order info and populate the table
    for (int i = 0; i < orderIds.size(); i++) {

        out.println("<tr>");//create a table row for every item in the order
        out.println("<td>" + orderIds.get(i) + "</td>");
        out.println("<td>" + orderDates.get(i) + "</td>");
        out.println("<td>" + customerIds.get(i) + "</td>");
        out.println("<td>" + customerNames.get(i) + "</td>");
        out.println("<td>" + currFormat.format(totalAmounts.get(i)) + "</td>");
        out.println("</tr>");

        // Retrieve products for this order
        pstmt2.setInt(1, orderIds.get(i));
        ResultSet productRS = pstmt2.executeQuery();

        // Print product table
        out.println("</table>");
        out.println("<table border='1'>");
        out.println("<tr>");
        out.println("<th>Product Id</th>");
        out.println("<th>Quantity</th>");
        out.println("<th>Price</th>");
        out.println("</tr>");


        while (productRS.next()) {//for every product create a table row and output it into the super table
            int productId = productRS.getInt("productId");
            int quantity = productRS.getInt("quantity");
            double price = productRS.getDouble("price");

            out.println("<tr>");
            out.println("<td>" + productId + "</td>");
            out.println("<td>" + quantity + "</td>");
            out.println("<td>" + currFormat.format(price) + "</td>");
            out.println("</tr>");
        }

        out.println("</table>");

        productRS.close();

        // Reopen the order summary table for the next order
        out.println("<table border='1'>");
    }

    out.println("</table>");

    // Close resources
    pstmt2.close();
    con.close();

} catch (SQLException e) {
    out.println("Error connecting to database: " + e.getMessage());
}
%>

</body>
</html>
```