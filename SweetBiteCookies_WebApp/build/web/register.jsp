<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Register - SweetBite Cookies</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f9; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .register-container { background: white; padding: 30px 40px; border-radius: 8px; box-shadow: 0px 4px 15px rgba(0,0,0,0.1); width: 400px; text-align: center; }
        .register-container h2 { color: #8b5a2b; margin-bottom: 20px; }
        input[type="text"], input[type="email"], input[type="password"], textarea, input[type="tel"] { width: 90%; padding: 10px; margin: 8px 0; border: 1px solid #ccc; border-radius: 4px; font-family: Arial;}
        button { width: 95%; padding: 10px; background-color: #28a745; color: white; border: none; border-radius: 4px; font-size: 16px; cursor: pointer; margin-top: 15px; }
        button:hover { background-color: #218838; }
        .error { color: red; font-size: 14px; margin-top: 10px; }
    </style>
</head>
<body>

    <div class="register-container">
        <h2>Create an Account</h2>
        <p style="color: gray; font-size: 14px;">Join the SweetBite family today!</p>
        
        <form action="RegisterServlet" method="post">
            <input type="text" name="name" placeholder="Full Name" required><br>
            <input type="email" name="email" placeholder="Email Address" required><br>
            <input type="password" name="password" placeholder="Create Password" required><br>
            <input type="tel" id="phoneInput" name="phone" placeholder="Phone Number (e.g. 012-3456789)" pattern="[0-9-]+" required><br>
            <textarea name="address" placeholder="Delivery Address" rows="3" required></textarea><br>
            
            <button type="submit">Register Now</button>
        </form>
        
        <p style="font-size: 14px; margin-top: 15px;">
            Already have an account? <a href="login.jsp" style="color: #8b5a2b; text-decoration: none; font-weight: bold;">Login Here</a>
        </p>
        
        <% if(request.getAttribute("errorMessage") != null) { %>
            <p class="error"><%= request.getAttribute("errorMessage") %></p>
        <% } %>
    </div>

    <script>
        const phoneInput = document.getElementById('phoneInput');
        phoneInput.addEventListener('input', function (e) {
            // Remove all non-numeric characters before processing
            let value = e.target.value.replace(/\D/g, ''); 
            
            // If they type more than 3 numbers, stick a hyphen in there
            if (value.length > 3) {
                value = value.slice(0, 3) + '-' + value.slice(3);
            }
            
            // Limit to max 12 characters (e.g., 011-12345678)
            e.target.value = value.slice(0, 12); 
        });
    </script>
</body>
</html>