package controller;

import model.Order;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "OrderServlet", urlPatterns = {"/OrderServlet"})
public class OrderServlet extends HttpServlet {

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
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("delete".equals(action)) {
                deleteOrder(request, response);
            } else {
                listOrders(request, response);
            }
        } catch (SQLException ex) { 
            throw new ServletException(ex); 
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("updateStatus".equals(action)) {
                updateStatus(request, response);
            }
        } catch (SQLException ex) { 
            throw new ServletException(ex); 
        }
    }
    
    // ==========================================
    // CRUD DATABASE OPERATIONS
    // ==========================================

    private void listOrders(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        List<Order> listOrder = new ArrayList<>();
        
        String sql = "SELECT o.orderID, o.customerID, c.name AS customerName, o.date, o.totalPrice, o.status " +
                     "FROM `Order` o " +
                     "JOIN Customer c ON o.customerID = c.customerID " +
                     "ORDER BY o.date DESC";
                     
        try (Connection connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
             
            while (resultSet.next()) {
                listOrder.add(new Order(
                    resultSet.getString("orderID"),
                    resultSet.getString("customerID"),
                    resultSet.getString("customerName"),
                    resultSet.getDate("date"),
                    resultSet.getDouble("totalPrice"),
                    resultSet.getString("status")
                ));
            }
        } 
        
        request.setAttribute("listOrder", listOrder);
        request.getRequestDispatcher("manage_orders.jsp").forward(request, response);
    }

    private void updateStatus(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        String sql = "UPDATE `Order` SET status = ? WHERE orderID = ?";
        
        try (Connection conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
             PreparedStatement stmt = conn.prepareStatement(sql)) {
             
            stmt.setString(1, request.getParameter("status"));
            stmt.setString(2, request.getParameter("orderID"));
            stmt.executeUpdate();
        }
        
        response.sendRedirect("OrderServlet");
    }

    private void deleteOrder(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        String sql = "DELETE FROM `Order` WHERE orderID = ?";
        
        try (Connection connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
             PreparedStatement statement = connection.prepareStatement(sql)) {
             
            statement.setString(1, request.getParameter("orderID"));
            statement.executeUpdate(); 
            // NOTE: Due to ON DELETE CASCADE, Cart items are automatically deleted too!
        }
        
        response.sendRedirect("OrderServlet");
    }
}