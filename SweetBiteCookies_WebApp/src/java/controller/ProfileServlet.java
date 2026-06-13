package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/ProfileServlet")
public class ProfileServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Find out which button the user clicked
        String action = request.getParameter("action");
        String customerID = request.getParameter("customerID");
        
        // Database credentials
        String jdbcURL = "jdbc:mysql://localhost:3306/sweetbite_db";
        String dbUser = "root";
        String dbPassword = "";
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
            
            // ==========================================
            // ACTION 1: SAVE CHANGES
            // ==========================================
            if ("update".equals(action)) {
                String name = request.getParameter("name");
                String email = request.getParameter("email");
                String password = request.getParameter("password");
                String phone = request.getParameter("phoneNumber");
                String address = request.getParameter("address");
                
                String sql = "UPDATE Customer SET name=?, email=?, password=?, phoneNumber=?, address=? WHERE customerID=?";
                PreparedStatement ps = conn.prepareStatement(sql);
                
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, password);
                ps.setString(4, phone);
                ps.setString(5, address);
                ps.setString(6, customerID);
                
                ps.executeUpdate();
                
                // Genius UX trick: Update the session variable so the "Hi, Name" in the navbar changes instantly!
                HttpSession session = request.getSession(false);
                if (session != null) {
                    session.setAttribute("userName", name);
                }
                
                // Refresh the page to show the saved data
                response.sendRedirect("my_profile.jsp");
                
            } 
            // ==========================================
            // ACTION 2: DELETE MY ACCOUNT
            // ==========================================
            else if ("delete".equals(action)) {
                String sql = "DELETE FROM Customer WHERE customerID=?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, customerID);
                ps.executeUpdate(); // Automatically deletes their Cart and Orders due to CASCADE!
                
                // Redirect them to LogoutServlet to completely destroy their session securely
                response.sendRedirect("LogoutServlet");
            }
            
            conn.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("my_profile.jsp?error=true");
        }
    }
}