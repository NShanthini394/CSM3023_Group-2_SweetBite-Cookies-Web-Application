<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Login - SweetBite Cookies</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f9; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .login-container { background: white; padding: 40px; border-radius: 8px; box-shadow: 0px 4px 15px rgba(0,0,0,0.1); width: 350px; text-align: center; }
        .login-container h2 { color: #8b5a2b; margin-bottom: 20px; }
        input[type="email"], input[type="password"] { width: 90%; padding: 10px; margin: 10px 0; border: 1px solid #ccc; border-radius: 4px; }
        button { width: 95%; padding: 10px; background-color: #d2a679; color: white; border: none; border-radius: 4px; font-size: 16px; cursor: pointer; margin-top: 15px; }
        button:hover { background-color: #8b5a2b; }
        .error { color: red; font-size: 14px; margin-top: 10px; }
    </style>
</head>
<body>

    <div class="login-container">
        <img src="MainPhoto/SweetBite_Logo.png" alt="Logo" width="100">
        <h2>Welcome Back</h2>
        
        <form action="LoginServlet" method="post">
            <input type="email" name="email" placeholder="Enter Email" required><br>
            <input type="password" name="password" placeholder="Enter Password" required><br>
            <button type="submit">Secure Login</button>
        </form>
        
        <p style="font-size: 14px; margin-top: 15px;">
            Don't have an account? <a href="register.jsp" style="color: #8b5a2b; text-decoration: none; font-weight: bold;">Register Here</a>
        </p>
        
        <%-- Displays an error message if the Java Servlet catches a wrong password --%>
        <% if(request.getAttribute("errorMessage") != null) { %>
            <p class="error"><%= request.getAttribute("errorMessage") %></p>
        <% } %>
    </div>

</body>
</html>