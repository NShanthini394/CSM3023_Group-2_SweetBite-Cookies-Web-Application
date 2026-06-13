package controller;

import model.Promotion;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "PromotionServlet", urlPatterns = {"/PromotionServlet"})
public class PromotionServlet extends HttpServlet {

    private String jdbcURL = "jdbc:mysql://localhost:3306/sweetbite_db";
    private String jdbcUsername = "root";
    private String jdbcPassword = ""; 
    
    @Override
    public void init() throws ServletException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new ServletException("MySQL Driver not found in WEB-INF/lib!", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("delete".equals(action)) {
                deletePromotion(request, response);
            } else {
                listPromotions(request, response);
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("add".equals(action)) {
                insertPromotion(request, response);
            } else if ("update".equals(action)) {
                updatePromotion(request, response);
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    // ==========================================
    // CRUD DATABASE OPERATIONS
    // ==========================================

    private void listPromotions(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        List<Promotion> listPromo = new ArrayList<>();
        String sql = "SELECT * FROM Promotion";
        
        try (Connection connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            
            while (resultSet.next()) {
                Promotion promo = new Promotion(
                    resultSet.getString("promoID"),
                    resultSet.getString("title"),
                    resultSet.getString("promoCode"),
                    resultSet.getDouble("discountRate"),
                    resultSet.getDate("startDate"),
                    resultSet.getDate("endDate"),
                    resultSet.getString("image")
                );
                listPromo.add(promo);
            }
        }
        
        request.setAttribute("listPromo", listPromo);
        request.getRequestDispatcher("manage_promotions.jsp").forward(request, response);
    }

    private void insertPromotion(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        String sql = "INSERT INTO Promotion (promoID, title, promoCode, discountRate, startDate, endDate, image) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setString(1, request.getParameter("promoID"));
            statement.setString(2, request.getParameter("title"));
            statement.setString(3, request.getParameter("promoCode"));
            statement.setDouble(4, Double.parseDouble(request.getParameter("discountRate")));
            statement.setDate(5, Date.valueOf(request.getParameter("startDate")));
            statement.setDate(6, Date.valueOf(request.getParameter("endDate")));
            
            // Add image path (default to logo if left blank)
            String imagePath = request.getParameter("image");
            if(imagePath == null || imagePath.trim().isEmpty()) {
                imagePath = "MainPhoto/SweetBite_Logo.png";
            }
            statement.setString(7, imagePath);
            
            statement.executeUpdate();
        }
        
        response.sendRedirect("PromotionServlet");
    }

    private void updatePromotion(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        String sql = "UPDATE Promotion SET title=?, promoCode=?, discountRate=?, startDate=?, endDate=?, image=? WHERE promoID=?";
        
        try (Connection connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setString(1, request.getParameter("title"));
            statement.setString(2, request.getParameter("promoCode"));
            statement.setDouble(3, Double.parseDouble(request.getParameter("discountRate")));
            statement.setDate(4, Date.valueOf(request.getParameter("startDate")));
            statement.setDate(5, Date.valueOf(request.getParameter("endDate")));
            
            String imagePath = request.getParameter("image");
            if(imagePath == null || imagePath.trim().isEmpty()) {
                imagePath = "MainPhoto/SweetBite_Logo.png";
            }
            statement.setString(6, imagePath);
            
            // The WHERE clause ID
            statement.setString(7, request.getParameter("promoID"));
            
            statement.executeUpdate();
        }
        
        response.sendRedirect("PromotionServlet");
    }

    private void deletePromotion(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        String sql = "DELETE FROM Promotion WHERE promoID = ?";
        
        try (Connection connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
             PreparedStatement statement = connection.prepareStatement(sql)) {
             
            statement.setString(1, request.getParameter("promoID"));
            statement.executeUpdate();
        }
        
        response.sendRedirect("PromotionServlet");
    }
}