<%@ page import="java.sql.*,java.io.*" trimDirectiveWhitespaces="true" %><%@ include file="jdbc.jsp" %><%
// This JSP returns ONLY image bytes, never HTML or text output.
String idText = request.getParameter("id");
int productId;
try
{
    productId = Integer.parseInt(idText == null ? "" : idText.trim());
    if (productId <= 0) throw new NumberFormatException();
}
catch (NumberFormatException ex)
{
    response.sendError(400, "Invalid product ID");
    return;
}

String sql = "SELECT productImage FROM product WHERE productId = ?";
try (Connection con = getConnection();
     PreparedStatement ps = con.prepareStatement(sql))
{
    ps.setInt(1, productId);
    try (ResultSet rs = ps.executeQuery())
    {
        if (!rs.next())
        {
            response.sendError(404, "Product not found");
            return;
        }
        try (InputStream image = rs.getBinaryStream("productImage"))
        {
            if (image == null)
            {
                response.sendError(404, "No database image for this product");
                return;
            }

            // TODO: Set response content type to "image/jpeg".
            // TODO: Obtain response.getOutputStream() and copy the image
            //       bytes from the InputStream to the output stream.
            //       Use a byte[] buffer and a loop, not out.println().
            //       Do not render HTML on this page.
            response.sendError(501, "Image streaming not implemented yet");
        }
    }
}
catch (SQLException | IOException ex)
{
    log("Unable to retrieve product image", ex);
    if (!response.isCommitted())
        response.sendError(500, "Unable to retrieve product image");
}
%>