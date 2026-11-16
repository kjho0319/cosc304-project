<%@ page import="java.sql.*,java.math.BigDecimal,java.text.NumberFormat,java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="escape.jspf" %>
<%@ include file="auth.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><title>Administrator Report</title></head>
<body>
<h1>Administrator Report</h1>
<%
// Total sales per day: group by the DATE part of orderDate (a DATETIME) so
// orders at different times on the same day are combined.
String sql = "SELECT CAST(orderDate AS DATE) AS orderDay, SUM(totalAmount) AS totalSales "
           + "FROM ordersummary "
           + "WHERE orderDate IS NOT NULL "
           + "GROUP BY CAST(orderDate AS DATE) "
           + "ORDER BY orderDay";

NumberFormat currency = NumberFormat.getCurrencyInstance(Locale.CANADA);

try (Connection con = getConnection();
     PreparedStatement ps = con.prepareStatement(sql);
     ResultSet rs = ps.executeQuery())
{
    boolean any = false;
    BigDecimal grandTotal = BigDecimal.ZERO;
%>
<h2>Daily Sales</h2>
<table border="1" cellpadding="4">
<tr><th>Order Date</th><th>Total Order Amount</th></tr>
<%
    while (rs.next())
    {
        any = true;
        java.sql.Date day = rs.getDate("orderDay");
        BigDecimal total = rs.getBigDecimal("totalSales");
        if (total == null) total = BigDecimal.ZERO;
        grandTotal = grandTotal.add(total);
%>
<tr><td><%= escapeHtml(String.valueOf(day)) %></td><td align="right"><%= currency.format(total) %></td></tr>
<%
    }
    if (!any)
    {
%>
<tr><td colspan="2">No orders have been placed yet.</td></tr>
<%
    }
    else
    {
%>
<tr><th>All days</th><th align="right"><%= currency.format(grandTotal) %></th></tr>
<%
    }
%>
</table>
<%
}
catch (SQLException ex)
{
    log("Unable to produce sales report", ex);
    out.println("<p>Unable to load the sales report: " + escapeHtml(ex.getMessage()) + "</p>");
}
%>
<p><a href="index.jsp">Main Page</a></p>
</body>
</html>
