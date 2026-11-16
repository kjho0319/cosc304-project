<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ include file="jdbc.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<title>Grocery Order Processing</title>
</head>
<body>

<%
// Get customer id
String custId = request.getParameter("customerId");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

NumberFormat currFormat = NumberFormat.getCurrencyInstance();

// 1. Validate that the customer id is a number (stays -1 if not)
int customerId = -1;
try {
    customerId = Integer.parseInt(custId);
} catch (NumberFormatException e) {
    // stays -1
}

if (customerId == -1) {
    out.println("<h1>Invalid customer id. Go back to the previous page and try again.</h1>");
} else if (productList == null || productList.isEmpty()) {
    // 2. Cart must contain products
    out.println("<h1>Your shopping cart is empty!</h1>");
} else {
    // 3. Connect (try-with-resources closes the connection automatically)
    try (Connection con = getConnection()) {

        // 4. Validate that the customer exists in the database
        PreparedStatement search = con.prepareStatement(
            "SELECT customerId, firstName, lastName FROM customer WHERE customerId = ?");
        search.setInt(1, customerId);
        ResultSet rs = search.executeQuery();

        if (rs.next()) {
            String customerName = rs.getString("firstName") + " " + rs.getString("lastName");

            // Save the whole order as one transaction: either everything is saved or nothing is
            con.setAutoCommit(false);
            try {
                // 5. Insert the order summary (total = 0 for now) and get the generated orderId
                PreparedStatement insertOrder = con.prepareStatement(
                    "INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (?, ?, ?)",
                    Statement.RETURN_GENERATED_KEYS);
                insertOrder.setInt(1, customerId);
                insertOrder.setTimestamp(2, new java.sql.Timestamp(System.currentTimeMillis()));
                insertOrder.setDouble(3, 0);
                insertOrder.executeUpdate();

                ResultSet keys = insertOrder.getGeneratedKeys();
                keys.next();
                int orderId = keys.getInt(1);

                // 6. Loop through the cart: insert each product into orderproduct and add up the total
                PreparedStatement insertItem = con.prepareStatement(
                    "INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (?, ?, ?, ?)");

                double total = 0;
                StringBuilder itemRows = new StringBuilder();

                Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
                while (iterator.hasNext()) {
                    Map.Entry<String, ArrayList<Object>> entry = iterator.next();
                    ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
                    String productId = (String) product.get(0);
                    String productName = (String) product.get(1);
                    String price = (String) product.get(2);
                    double pr = Double.parseDouble(price);
                    int qty = ((Integer) product.get(3)).intValue();

                    insertItem.setInt(1, orderId);
                    insertItem.setInt(2, Integer.parseInt(productId));
                    insertItem.setInt(3, qty);
                    insertItem.setDouble(4, pr);
                    insertItem.executeUpdate();

                    double subtotal = pr * qty;
                    total += subtotal;

                    // Remember this row for the receipt
                    itemRows.append("<tr><td>").append(productId)
                            .append("</td><td>").append(productName)
                            .append("</td><td align=\"center\">").append(qty)
                            .append("</td><td align=\"right\">").append(currFormat.format(pr))
                            .append("</td><td align=\"right\">").append(currFormat.format(subtotal))
                            .append("</td></tr>");
                }

                // 7. Update the order with the real total
                PreparedStatement updateTotal = con.prepareStatement(
                    "UPDATE ordersummary SET totalAmount = ? WHERE orderId = ?");
                updateTotal.setDouble(1, total);
                updateTotal.setInt(2, orderId);
                updateTotal.executeUpdate();

                con.commit();

                // 8. Print out the order summary
                out.println("<h1>Your Order Summary</h1>");
                out.println("<table>");
                out.println("<tr><th>Product Id</th><th>Product Name</th><th>Quantity</th><th>Price</th><th>Subtotal</th></tr>");
                out.println(itemRows.toString());
                out.println("<tr><td colspan=\"4\" align=\"right\"><b>Order Total</b></td>"
                          + "<td align=\"right\">" + currFormat.format(total) + "</td></tr>");
                out.println("</table>");

                out.println("<h1>Order completed. Will be shipped soon...</h1>");
                out.println("<h1>Your order reference number is: " + orderId + "</h1>");
                out.println("<h1>Shipping to customer: " + customerId + " Name: " + customerName + "</h1>");
                out.println("<h2><a href=\"index.jsp\">Return to shopping</a></h2>");

                // 9. Clear the shopping cart only after all order operations succeed
                session.removeAttribute("productList");

            } catch (SQLException ex) {
                con.rollback();   // undo the partial order
                throw ex;
            }
        } else {
            out.println("<h1>Invalid customer id. Go back to the previous page and try again.</h1>");
        }

    } catch (SQLException ex) {
        out.println("<h1>Database error: " + ex.getMessage() + "</h1>");
    }
}
%>
</body>
</html>
