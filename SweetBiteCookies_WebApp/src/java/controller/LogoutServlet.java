package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Get the current session
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // 2. Destroy the session completely (Works for both Admin and Customer)
            session.invalidate();
        }
        
        // 3. Security Headers: Prevent the browser from caching this page
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache"); 
        response.setDateHeader("Expires", 0); 
        
        // 4. Redirect to the public storefront!
        response.sendRedirect("index.jsp");
    }
}