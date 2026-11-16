
<%@ page import="java.sql.*,java.io.*" trimDirectiveWhitespaces="true" %>
<%@ include file="jdbc.jsp" %>
<%
String idText = request.getParameter("id");
int productId;

try {
    productId = Integer.parseInt(idText == null ? "" : idText.trim());

    if (productId <= 0) {
        throw new NumberFormatException();
    }
} catch (NumberFormatException ex) {
    response.sendError(400, "Invalid product ID");
    return;
}

String sql = "SELECT productImage FROM product WHERE productId = ?";

try (
    Connection con = getConnection();
    PreparedStatement ps = con.prepareStatement(sql)
) {
    ps.setInt(1, productId);

    try (ResultSet rs = ps.executeQuery()) {

        if (!rs.next()) {
            response.sendError(404, "Product not found");
            return;
        }

        try (InputStream image = rs.getBinaryStream("productImage")) {

            if (image == null) {
                response.sendError(404, "No database image for this product");
                return;
            }

            // Set the response content type
            response.setContentType("image/jpeg");

            // Get the output stream
            ServletOutputStream output = response.getOutputStream();

            // Copy image bytes to the browser
            byte[] buffer = new byte[4096];
            int bytesRead;

            while ((bytesRead = image.read(buffer)) != -1) {
                output.write(buffer, 0, bytesRead);
            }

            output.flush();
        }
    }

} catch (SQLException | IOException ex) {
    log("Unable to retrieve product image", ex);

    if (!response.isCommitted()) {
        response.sendError(500, "Unable to retrieve product image");
    }
}
%>
