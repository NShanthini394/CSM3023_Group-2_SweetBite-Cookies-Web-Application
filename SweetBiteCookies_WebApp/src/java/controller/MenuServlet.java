package controller;

import model.Menu;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "MenuServlet", urlPatterns = {"/MenuServlet"})
public class MenuServlet extends HttpServlet {

    private String jdbcURL = "jdbc:mysql://localhost:3306/sweetbite_db";
    private String jdbcUsername = "root";
    private String jdbcPassword = "";

    @Override
    public void init() throws ServletException {
        try { Class.forName("com.mysql.cj.jdbc.Driver"); } 
        catch (ClassNotFoundException e) { throw new ServletException(e); }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("delete".equals(action)) { deleteMenu(request, response); } 
            else { listMenus(request, response); }
        } catch (SQLException ex) { throw new ServletException(ex); }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("add".equals(action)) { insertMenu(request, response); } 
            else if ("update".equals(action)) { updateMenu(request, response); }
        } catch (SQLException ex) { throw new ServletException(ex); }
    }

    private void listMenus(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        List<Menu> listMenu = new ArrayList<>();
        try (Connection connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
             PreparedStatement statement = connection.prepareStatement("SELECT * FROM Menu");
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                listMenu.add(new Menu(
                    resultSet.getString("menuID"), resultSet.getString("itemName"),
                    resultSet.getString("description"), resultSet.getDouble("price"),
                    resultSet.getInt("stockQuantity"), resultSet.getString("image"),
                    resultSet.getString("category")
                ));
            }
        }
        request.setAttribute("listMenu", listMenu);
        request.getRequestDispatcher("manage_menu.jsp").forward(request, response);
    }

    private void insertMenu(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        String sql = "INSERT INTO Menu (menuID, itemName, description, price, stockQuantity, image, category) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, request.getParameter("menuID"));
            stmt.setString(2, request.getParameter("itemName"));
            stmt.setString(3, request.getParameter("description"));
            stmt.setDouble(4, Double.parseDouble(request.getParameter("price")));
            stmt.setInt(5, Integer.parseInt(request.getParameter("stockQuantity")));
            
            String imagePath = request.getParameter("image");
            if(imagePath == null || imagePath.trim().isEmpty()) { imagePath = "SlideShow/cookies.jpg"; }
            stmt.setString(6, imagePath);
            stmt.setString(7, request.getParameter("category"));
            stmt.executeUpdate();
        }
        response.sendRedirect("MenuServlet");
    }

    private void updateMenu(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        String sql = "UPDATE Menu SET itemName=?, description=?, price=?, stockQuantity=?, image=?, category=? WHERE menuID=?";
        try (Connection conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, request.getParameter("itemName"));
            stmt.setString(2, request.getParameter("description"));
            stmt.setDouble(3, Double.parseDouble(request.getParameter("price")));
            stmt.setInt(4, Integer.parseInt(request.getParameter("stockQuantity")));
            stmt.setString(5, request.getParameter("image"));
            stmt.setString(6, request.getParameter("category"));
            stmt.setString(7, request.getParameter("menuID"));
            stmt.executeUpdate();
        }
        response.sendRedirect("MenuServlet");
    }

    private void deleteMenu(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        try (Connection conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
             PreparedStatement stmt = conn.prepareStatement("DELETE FROM Menu WHERE menuID = ?")) {
            stmt.setString(1, request.getParameter("menuID"));
            stmt.executeUpdate();
        }
        response.sendRedirect("MenuServlet");
    }
}