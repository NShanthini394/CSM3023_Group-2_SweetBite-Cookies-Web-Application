package controller;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "CheckoutServlet", urlPatterns = {"/CheckoutServlet"})
public class CheckoutServlet extends HttpServlet {

    private String jdbcURL = "jdbc:mysql://localhost:3306/sweetbite_db";
    private String jdbcUsername = "root";
    private String jdbcPassword = "";

    @Override
    public void init() throws ServletException {
        try { 
            Class.forName("com.mysql.cj.jdbc.Driver"); 
        } catch (ClassNotFoundException e) { 
            throw new ServletException(e); 
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        // 1. Security Check: Are they logged in?
        String customerID = "C001"; // Fallback to our dummy account if session expires
        if (session.getAttribute("userName") != null) {
            // In a full system, we would pull their real ID from the session here.
        }

        // 2. Grab the data from the Order Form
        String menuID = request.getParameter("menuID");
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        String promoCode = request.getParameter("promoCode"); 

        double pricePerBox = 0.0;
        double discountRate = 0.0;

        try (Connection conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword)) {
            
            // 3. Get the original price of the Cookie from the DB
            try (PreparedStatement stmt = conn.prepareStatement("SELECT price FROM Menu WHERE menuID = ?")) {
                stmt.setString(1, menuID);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) { 
                    pricePerBox = rs.getDouble("price"); 
                }
            }

            // 4. Validate the Promo Code (If they typed one)
            if (promoCode != null && !promoCode.trim().isEmpty()) {
                String promoSql = "SELECT discountRate FROM Promotion WHERE promoCode = ? AND CURDATE() BETWEEN startDate AND endDate";
                try (PreparedStatement stmt = conn.prepareStatement(promoSql)) {
                    stmt.setString(1, promoCode.trim());
                    ResultSet rs = stmt.executeQuery();
                    if (rs.next()) {
                        discountRate = rs.getDouble("discountRate"); // e.g., 0.15 for 15%
                    }
                }
            }

            // 5. Calculate the Final Math
            double subtotal = pricePerBox * quantity;
            double discountAmount = subtotal * discountRate;
            double finalTotal = subtotal - discountAmount;

            // Generate unique IDs for the database
            String orderID = "ORD-" + System.currentTimeMillis(); 
            String cartID = "CRT-" + System.currentTimeMillis();

            // 6. Save to `Order` Table
            String orderSql = "INSERT INTO `Order` (orderID, customerID, date, totalPrice, status) VALUES (?, ?, CURDATE(), ?, 'Pending')";
            try (PreparedStatement stmt = conn.prepareStatement(orderSql)) {
                stmt.setString(1, orderID);
                stmt.setString(2, customerID);
                stmt.setDouble(3, finalTotal);
                stmt.executeUpdate();
            }

            // 7. Save to `Cart` Table
            String cartSql = "INSERT INTO Cart (cartID, orderID, menuID, quantity, subtotal) VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(cartSql)) {
                stmt.setString(1, cartID);
                stmt.setString(2, orderID);
                stmt.setString(3, menuID);
                stmt.setInt(4, quantity);
                stmt.setDouble(5, finalTotal); // saving final discounted total
                stmt.executeUpdate();
            }

            // 8. Reduce Stock Quantity in `Menu` Table
            String stockSql = "UPDATE Menu SET stockQuantity = stockQuantity - ? WHERE menuID = ?";
            try (PreparedStatement stmt = conn.prepareStatement(stockSql)) {
                stmt.setInt(1, quantity);
                stmt.setString(2, menuID);
                stmt.executeUpdate();
            }

            // 9. Success! Send them to the dedicated digital receipt page!
            response.sendRedirect("order_success.jsp?orderID=" + orderID);

        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
}