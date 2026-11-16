<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ include file="jdbc.jsp" %>
<%
request.setCharacterEncoding("UTF-8");
String username = request.getParameter("username");
String password = request.getParameter("password");
boolean validLogin = false;  // Invalid until the database confirms credentials.

if (username != null && !username.trim().isEmpty() &&
    password != null && !password.isEmpty())
{
    username = username.trim();
    try (Connection con = getConnection())
    {
        // Parameterized query: user input is never concatenated into the SQL.
        // NOTE: This course dataset has plaintext passwords for demonstration.
        //       Real systems should store securely hashed passwords.
        String sql = "SELECT userid FROM customer WHERE userid = ? AND password = ?";
        try (PreparedStatement ps = con.prepareStatement(sql))
        {
            ps.setString(1, username);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery())
            {
                if (rs.next())
                {
                    validLogin = true;
                    // Store the userid exactly as it appears in the database.
                    username = rs.getString("userid");
                }
            }
        }
    }
    catch (SQLException ex)
    {
        log("Unable to validate login", ex);
    }
}

if (validLogin)
{
    session.setAttribute("authenticatedUser", username);
    session.removeAttribute("loginMessage");
    response.sendRedirect("index.jsp");
}
else
{
    session.removeAttribute("authenticatedUser");
    session.setAttribute("loginMessage", "Invalid user ID or password.");
    response.sendRedirect("login.jsp");
}
return;
%>
