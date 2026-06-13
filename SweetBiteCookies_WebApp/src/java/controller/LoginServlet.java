package controller;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

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
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        HttpSession session = request.getSession();

        try (Connection connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword)) {
            
            // 1. Check if the user is a STAFF MEMBER
            String staffQuery = "SELECT * FROM Staff WHERE email = ? AND password = ?";
            try (PreparedStatement staffStmt = connection.prepareStatement(staffQuery)) {
                staffStmt.setString(1, email);
                staffStmt.setString(2, password);
                ResultSet staffRs = staffStmt.executeQuery();
                
                if (staffRs.next()) {
                    session.setAttribute("userRole", "Admin");
                    session.setAttribute("userName", staffRs.getString("name"));
                    session.setAttribute("staffID", staffRs.getString("staffID"));
                    
                    response.sendRedirect("admin_hub.jsp"); // Route to Admin Dashboard
                    return;
                }
            }

            // 2. Check if the user is a CUSTOMER
            String custQuery = "SELECT * FROM Customer WHERE email = ? AND password = ?";
            try (PreparedStatement custStmt = connection.prepareStatement(custQuery)) {
                custStmt.setString(1, email);
                custStmt.setString(2, password);
                ResultSet custRs = custStmt.executeQuery();
                
                if (custRs.next()) {
                    session.setAttribute("userRole", "Customer");
                    session.setAttribute("userName", custRs.getString("name"));
                    session.setAttribute("customerID", custRs.getString("customerID")); 
                    
                    response.sendRedirect("index.jsp"); // Route to Storefront
                    return;
                }
            }

            // 3. If neither, send them back to login with an error
            request.setAttribute("errorMessage", "Invalid email or password!");
            request.getRequestDispatcher("login.jsp").forward(request, response);

        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
}