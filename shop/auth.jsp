<%
// Include this file BEFORE any HTML output on pages that require a login.
if (session.getAttribute("authenticatedUser") == null)
{
    session.setAttribute("loginMessage", "Please log in to access that page.");
    response.sendRedirect("login.jsp");
    return;  // Stop processing the protected page.
}
%>
