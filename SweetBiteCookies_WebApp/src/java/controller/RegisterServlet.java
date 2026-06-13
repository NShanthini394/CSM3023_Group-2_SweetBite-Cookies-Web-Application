package controller;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/RegisterServlet"})
public class RegisterServlet extends HttpServlet {

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
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        // Generate a unique Customer ID (e.g., C98234)
        String customerID = "C" + (int)(Math.random() * 100000);

        try (Connection connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword)) {
            
            // 1. Check if email already exists
            String checkEmailQuery = "SELECT email FROM Customer WHERE email = ?";
            try (PreparedStatement checkStmt = connection.prepareStatement(checkEmailQuery)) {
                checkStmt.setString(1, email);
                ResultSet rs = checkStmt.executeQuery();
                
                if (rs.next()) {
                    request.setAttribute("errorMessage", "Email is already registered. Please login.");
                    request.getRequestDispatcher("register.jsp").forward(request, response);
                    return; // Stop execution if email exists
                }
            }

            // 2. Insert new customer into database
            String insertQuery = "INSERT INTO Customer (customerID, name, email, password, phoneNumber, address) VALUES (?, ?, ?, ?, ?, ?)";
            try (PreparedStatement insertStmt = connection.prepareStatement(insertQuery)) {
                insertStmt.setString(1, customerID);
                insertStmt.setString(2, name);
                insertStmt.setString(3, email);
                insertStmt.setString(4, password);
                insertStmt.setString(5, phone);
                insertStmt.setString(6, address);
                
                insertStmt.executeUpdate();
            }

            // 3. Success! Send them to login page
            response.sendRedirect("login.jsp");

        } catch (SQLException ex) {
            throw new ServletException("Database Error: " + ex.getMessage(), ex);
        }
    }
}