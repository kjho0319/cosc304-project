<%
// Remove only the authentication state; preserve the shopping cart session.
session.removeAttribute("authenticatedUser");
session.removeAttribute("loginMessage");
response.sendRedirect("index.jsp");
return;
%>
