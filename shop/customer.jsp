<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ include file="auth.jsp" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="escape.jspf" %>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><title>Customer Information</title></head>
<body>
<h1>Customer Information</h1>
<%
String userName = (String) session.getAttribute("authenticatedUser");

// The customer is identified ONLY by the logged-in session user. Any id/userid
// passed in the URL is deliberately ignored, so changing the URL cannot show
// another customer's information.
String sql = "SELECT customerId, firstName, lastName, email, phonenum, address, "
           + "city, state, postalCode, country, userid "
           + "FROM customer WHERE userid = ?";

String[][] fields = {
    {"customerId", "Id"},
    {"firstName",  "First Name"},
    {"lastName",   "Last Name"},
    {"email",      "Email"},
    {"phonenum",   "Phone"},
    {"address",    "Address"},
    {"city",       "City"},
    {"state",      "State"},
    {"postalCode", "Postal Code"},
    {"country",    "Country"},
    {"userid",     "User id"}
};

try (Connection con = getConnection();
     PreparedStatement ps = con.prepareStatement(sql))
{
    ps.setString(1, userName);
    try (ResultSet rs = ps.executeQuery())
    {
        if (!rs.next())
        {
            out.println("<p>No customer record was found for user "
                + escapeHtml(userName) + ".</p>");
        }
        else
        {
%>
<table border="1" cellpadding="4">
<%
            for (String[] f : fields)
            {
                String value = rs.getString(f[0]);
                String shown = (value == null || value.trim().isEmpty())
                    ? "<em>Not provided</em>" : escapeHtml(value);
%>
<tr><th align="left"><%= f[1] %></th><td><%= shown %></td></tr>
<%
            }
%>
</table>
<%
        }
    }
}
catch (SQLException ex)
{
    log("Unable to retrieve customer information", ex);
    out.println("<p>Unable to retrieve customer information: "
        + escapeHtml(ex.getMessage()) + "</p>");
}
%>
<p><a href="index.jsp">Main Page</a></p>
</body>
</html>
