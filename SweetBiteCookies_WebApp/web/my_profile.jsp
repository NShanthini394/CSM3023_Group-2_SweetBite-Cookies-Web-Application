<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%
    // Prevent browser from caching the page after logout!
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
    
    // Security Check: Kick them out to index if they aren't logged in as Customer!
    if(session.getAttribute("userRole") == null || !session.getAttribute("userRole").equals("Customer")) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    // SMART SESSION CHECK: Try to get the ID whether it was saved as "customerID" or "userID"
    String customerID = (String) session.getAttribute("customerID"); 
    if (customerID == null) {
        customerID = (String) session.getAttribute("userID");
    }
    
    String name = "", email = "", password = "", phone = "", address = "";
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sweetbite_db", "root", "");
        PreparedStatement ps = conn.prepareStatement("SELECT * FROM Customer WHERE customerID = ?");
        ps.setString(1, customerID);
        ResultSet rs = ps.executeQuery();
        
        if(rs.next()) {
            name = rs.getString("name");
            email = rs.getString("email");
            password = rs.getString("password");
            phone = rs.getString("phoneNumber");
            address = rs.getString("address");
        }
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Profile - SweetBite Cookies</title>
    <link rel="icon" href="MainPhoto/SweetBite_Logo.png" type="image/png">
    <link rel="stylesheet" href="style.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #fdfaf5; padding-top: 100px; }
        .profile-card { max-width: 650px; margin: 40px auto; background: white; padding: 40px; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.08); border-top: 6px solid #8b5e3c; }
        
        /* UI Tweak: Make inputs look like editable data, not empty forms */
        .settings-input { background-color: #f8f9fa; border: 1px solid #ced4da; font-weight: 500; color: #495057; }
        .settings-input:focus { background-color: #ffffff; border-color: #8b5e3c; box-shadow: 0 0 0 0.2rem rgba(139, 94, 60, 0.25); }
        
        .btn-save { background-color: #198754; color: white; font-weight: bold; border-radius: 10px; padding: 12px; transition: 0.3s; }
        .btn-save:hover { background-color: #146c43; transform: translateY(-2px); color: white;}
        .btn-delete { background-color: #dc3545; color: white; font-weight: bold; border-radius: 10px; padding: 12px; transition: 0.3s; }
        .btn-delete:hover { background-color: #b02a37; transform: translateY(-2px); color: white;}
    </style>
</head>
<body>

    <nav class="navbar" style="position: fixed !important; top: 0 !important; width: 100% !important; padding: 15px 10% !important;">
        <div class="logo-container">
            <img src="MainPhoto/SweetBite_Logo.png" alt="Logo" class="logo-img">
            <a href="index.jsp" style="text-decoration: none;"><span class="logo-text">SweetBite Cookies</span></a>
        </div>
        
        <ul class="d-flex align-items-center m-0 ms-auto" style="list-style: none; gap: 20px;">
            <li class="nav-item">
                <a href="index.jsp" class="nav-link" style="color: white !important; font-weight: bold; font-size: 16px; text-decoration: none;">Home</a>
            </li>
            
            <li class="nav-item dropdown">
                <a class="nav-link" href="#" id="accountDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false" style="color: white !important; font-size: 26px; padding: 0;">
                    <i class="far fa-user-circle"></i>
                </a>
                <ul class="dropdown-menu dropdown-menu-end mt-2 shadow" aria-labelledby="accountDropdown" style="border: 2px solid #8b5a2b; border-radius: 12px; background-color: #fdfaf6; min-width: 220px; padding: 0;">
                    <li style="padding: 0;">
                        <div class="px-3 py-2 text-center" style="background-color: #f4e4d4; border-top-left-radius: 10px; border-top-right-radius: 10px;">
                            <span style="color: #8b5a2b; font-weight: 900; font-size: 15px;">Hi, <%= session.getAttribute("userName") %></span>
                        </div>
                    </li>
                    <li style="padding: 0;"><hr class="dropdown-divider m-0" style="border-color: #d2a679;"></li>
                    <li style="padding: 0;"><a class="dropdown-item fw-bold py-2 mt-1" href="my_profile.jsp" style="color: #8b5a2b !important;"><i class="far fa-id-badge me-2" style="width: 20px;"></i> My Profile</a></li>
                    <li style="padding: 0;"><a class="dropdown-item fw-bold py-2" href="my_orders.jsp" style="color: #8b5a2b !important;"><i class="fas fa-shopping-bag me-2" style="width: 20px;"></i> My Orders</a></li>
                    <li style="padding: 0;"><hr class="dropdown-divider m-0" style="border-color: #d2a679; opacity: 0.3;"></li>
                    <li style="padding: 0;"><a class="dropdown-item fw-bold py-2 mb-1" href="LogoutServlet" style="color: #dc3545 !important;"><i class="fas fa-sign-out-alt me-2" style="width: 20px;"></i> Logout</a></li>
                </ul>
            </li>
        </ul>
    </nav>

    <div class="container">
        <div class="profile-card">
            <div class="text-center mb-4">
                <i class="fas fa-user-circle" style="font-size: 80px; color: #8b5e3c;"></i>
                <h2 class="mt-2 text-dark fw-bold">My Account</h2>
                <p class="text-muted">Update your details or manage your account</p>
            </div>

            <form action="ProfileServlet" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="customerID" value="<%= customerID %>">
                
                <div class="mb-3">
                    <label class="fw-bold text-dark mb-1 small text-uppercase">Full Name</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light"><i class="fas fa-user text-muted"></i></span>
                        <input type="text" class="form-control settings-input" name="name" value="<%= name %>" required>
                    </div>
                </div>
                
                <div class="mb-3">
                    <label class="fw-bold text-dark mb-1 small text-uppercase">Email Address</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light"><i class="fas fa-envelope text-muted"></i></span>
                        <input type="email" class="form-control settings-input" name="email" value="<%= email %>" required>
                    </div>
                </div>
                
                <div class="mb-3">
                    <label class="fw-bold text-dark mb-1 small text-uppercase">Password</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light"><i class="fas fa-lock text-muted"></i></span>
                        <input type="password" class="form-control settings-input" name="password" value="<%= password %>" required>
                    </div>
                </div>
                
                <div class="mb-3">
                    <label class="fw-bold text-dark mb-1 small text-uppercase">Phone Number</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light"><i class="fas fa-phone text-muted"></i></span>
                        <input type="text" class="form-control settings-input" name="phoneNumber" value="<%= phone %>" required>
                    </div>
                </div>
                
                <div class="mb-4">
                    <label class="fw-bold text-dark mb-1 small text-uppercase">Delivery Address</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light"><i class="fas fa-map-marker-alt text-muted"></i></span>
                        <textarea class="form-control settings-input" name="address" rows="3" required><%= address %></textarea>
                    </div>
                </div>
                
                <button type="submit" class="btn btn-save w-100 mb-3"><i class="fas fa-save me-2"></i> Save Changes</button>
            </form>

            <hr style="border-color: #d2a679; opacity: 0.3; margin: 30px 0;">

            <form action="ProfileServlet" method="post" onsubmit="return confirm('Are you absolutely sure you want to leave the SweetBite family? This will permanently delete your account and order history.');">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="customerID" value="<%= customerID %>">
                <button type="submit" class="btn btn-delete w-100"><i class="fas fa-user-times me-2"></i> Delete My Account</button>
            </form>
            
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>