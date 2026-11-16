# COSC 304 — Lab 8 Java/JSP starter add-on

This package adds the **Lab 8 JSP files and images** to your existing Lab 7 Java web store. It is **not a standalone project**.

## Install

1. Start with your **existing** `cosc304-java` Lab 7 project. Do not reset the SQL Server database.
2. If you have customized your Lab 7 home page, **save a copy of `shop/index.jsp` first**. The ZIP includes a new `shop/index.jsp` and **replaces the existing Lab 7 main page**. Transfer any custom store name or other changes you wish to keep.
3. Extract this ZIP **into the `cosc304-java/` project directory**. Merge the `shop/` folder and allow **`shop/index.jsp` to be overwritten**. Do not replace any other existing Lab 7 JSP, Docker, or database files.
4. The new `shop/index.jsp` already links to shopping, order history, login/logout, customer information, the administrator report, and shipment tests for orders 1 and 3. Change `YOUR NAME Grocery` to your store name.
5. Edit your existing `shop/listprod.jsp` so each product name links to `product.jsp?id=<productId>`; retain its existing Add to Cart link. The starter does **not** replace `shop/listprod.jsp`.
6. Complete the TODOs in the new Lab 8 JSP files. The lab instructions are at https://github.com/rlawrenc/cosc_304/blob/main/labs/lab8/develop/README.md.

After extraction, launch the app as usual at **http://localhost/shop/**. You do not need to rebuild Docker just to add JSPs or images because the existing `shop/` directory is mounted into Tomcat.

## New files provided

| File | Purpose |
| --- | --- |
| `shop/admin.jsp` | TODO: authenticated daily sales report |
| `shop/auth.jsp` | Login requirement helper; include at top of protected pages |
| `shop/customer.jsp` | TODO: details of the logged-in customer |
| `shop/displayImage.jsp` | TODO: stream a product's binary image through an HTTP response |
| `shop/header.jsp` | Optional shared heading; edit store name |
| `shop/index.jsp` | **Replaces the Lab 7 main page** with Lab 8 links, login/logout state, and shipment test links |
| `shop/login.jsp` | Login form |
| `shop/logout.jsp` | Logout without clearing the shopping cart |
| `shop/product.jsp` | TODO: details and two image methods for the selected product |
| `shop/ship.jsp` | TODO: transactionally process an order from warehouse 1 |
| `shop/validateLogin.jsp` | TODO: verify username and password with the database |
| `shop/img/1.jpg`, `1_a.jpg`, `2.jpg`, `3.jpg`, `4.jpg`, `5.jpg` | Product photos from the previous Lab 8 starter |

**Starter behavior:** The new home page is functional immediately, but Lab 8 feature pages remain incomplete. Login intentionally fails until `validateLogin.jsp` is completed. The product, admin, customer and shipment pages intentionally have incomplete output until the TODOs are implemented.
