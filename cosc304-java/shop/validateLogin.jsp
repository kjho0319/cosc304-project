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
        // TODO: Use a PreparedStatement to verify that the supplied
        //       userid and password match a row in the customer table.
        //       Set validLogin = true ONLY when a matching row exists.
        //       Close any statement and result set with try-with-resources.
        // NOTE: This course dataset has plaintext passwords for demonstration.
        //       Real systems should store securely hashed passwords.
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
