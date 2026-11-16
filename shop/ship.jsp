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

final int WAREHOUSE_ID = 1;

// 1. Validate orderId.
int orderId = -1;
try
{
    orderId = Integer.parseInt(orderIdText == null ? "" : orderIdText.trim());
}
catch (NumberFormatException ex)
{
    orderId = -1;
}

if (orderId <= 0)
{
    out.println("<p>Invalid order id: " + escapeHtml(orderIdText) + "</p>");
}
else
{
    try (Connection con = getConnection())
    {
        // 2. Check that the order exists.
        boolean orderExists;
        try (PreparedStatement ps = con.prepareStatement(
                "SELECT orderId FROM ordersummary WHERE orderId = ?"))
        {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery())
            {
                orderExists = rs.next();
            }
        }

        if (!orderExists)
        {
            out.println("<p>Order " + orderId + " does not exist.</p>");
        }
        else
        {
            // 3. Everything from here on is ONE transaction.
            con.setAutoCommit(false);
            try
            {
                // Retrieve the products in the order.
                java.util.List<int[]> items = new java.util.ArrayList<>();
                try (PreparedStatement ps = con.prepareStatement(
                        "SELECT productId, quantity FROM orderproduct WHERE orderId = ? ORDER BY productId"))
                {
                    ps.setInt(1, orderId);
                    try (ResultSet rs = ps.executeQuery())
                    {
                        while (rs.next())
                            items.add(new int[] { rs.getInt("productId"), rs.getInt("quantity") });
                    }
                }

                if (items.isEmpty())
                {
                    con.rollback();
                    out.println("<p>Order " + orderId + " has no products to ship.</p>");
                }
                else
                {
                    // Create the shipment record for warehouse 1.
                    try (PreparedStatement ps = con.prepareStatement(
                            "INSERT INTO shipment (shipmentDate, shipmentDesc, warehouseId) "
                          + "VALUES (CURRENT_TIMESTAMP, ?, ?)"))
                    {
                        ps.setString(1, "Shipment for order " + orderId);
                        ps.setInt(2, WAREHOUSE_ID);
                        ps.executeUpdate();
                    }

                    // For each product: check warehouse 1 inventory, then subtract.
                    // UPDLOCK keeps another transaction from changing the row
                    // between our check and our update.
                    String checkSql = "SELECT quantity FROM productinventory WITH (UPDLOCK) "
                                    + "WHERE productId = ? AND warehouseId = ?";
                    String updateSql = "UPDATE productinventory SET quantity = quantity - ? "
                                     + "WHERE productId = ? AND warehouseId = ?";

                    boolean success = true;
                    int failedProductId = -1;
                    int failedOrdered = 0, failedAvailable = 0;

                    out.println("<table border=\"1\" cellpadding=\"4\">");
                    out.println("<tr><th>Product Id</th><th>Qty Ordered</th>"
                              + "<th>Previous Inventory</th><th>New Inventory</th></tr>");

                    try (PreparedStatement check = con.prepareStatement(checkSql);
                         PreparedStatement update = con.prepareStatement(updateSql))
                    {
                        for (int[] item : items)
                        {
                            int productId = item[0];
                            int ordered = item[1];

                            int available = 0;   // no inventory row = none in stock
                            check.setInt(1, productId);
                            check.setInt(2, WAREHOUSE_ID);
                            try (ResultSet rs = check.executeQuery())
                            {
                                if (rs.next())
                                    available = rs.getInt("quantity");
                            }

                            if (available < ordered)
                            {
                                success = false;
                                failedProductId = productId;
                                failedOrdered = ordered;
                                failedAvailable = available;
                                break;
                            }

                            update.setInt(1, ordered);
                            update.setInt(2, productId);
                            update.setInt(3, WAREHOUSE_ID);
                            update.executeUpdate();

                            out.println("<tr><td>" + productId + "</td><td>" + ordered
                                + "</td><td>" + available + "</td><td>" + (available - ordered)
                                + "</td></tr>");
                        }
                    }
                    out.println("</table>");

                    if (success)
                    {
                        con.commit();
                        out.println("<h3>Shipment for order " + orderId
                            + " successfully processed.</h3>");
                    }
                    else
                    {
                        con.rollback();
                        out.println("<h3>Shipment not done. Insufficient inventory for product id: "
                            + failedProductId + " (ordered " + failedOrdered + ", warehouse "
                            + WAREHOUSE_ID + " has " + failedAvailable + ").</h3>");
                        out.println("<p>The transaction was rolled back: no shipment was recorded "
                            + "and none of the inventory changes listed above were saved.</p>");
                    }
                }
            }
            catch (SQLException ex)
            {
                // Any database error part-way through undoes the whole shipment.
                con.rollback();
                throw ex;
            }
        }
    }
    catch (SQLException ex)
    {
        log("Unable to process shipment", ex);
        out.println("<p>Shipment not done. A database error occurred and all changes were rolled back: "
            + escapeHtml(ex.getMessage()) + "</p>");
    }
}
%>
<p><a href="index.jsp">Main Page</a></p>
</body>
</html>
