<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Prevent browser from caching the page after logout!
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
    
    // Security Check: Kick them out if they aren't logged in as Admin!
    if(session.getAttribute("userRole") == null || !session.getAttribute("userRole").equals("Admin")) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard - SweetBite</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .sidebar { min-height: 100vh; background-color: #343a40; color: white; padding-top: 20px; }
        .sidebar a { color: #adb5bd; text-decoration: none; padding: 15px; display: block; font-size: 16px; }
        .sidebar a:hover, .sidebar a.active { background-color: #495057; color: white; border-left: 4px solid #d2a679; }
        .main-content { padding: 40px; width: 100%; }
        .stat-card { border-radius: 10px; border: none; transition: transform 0.2s; }
        .stat-card:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.1); }
        .icon-box { width: 60px; height: 60px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 24px; margin-bottom: 15px; }
    </style>
</head>
<body>

    <div class="d-flex">
        <div class="sidebar" style="width: 250px;">
            <div class="text-center mb-4 mt-2">
                <img src="MainPhoto/SweetBite_Logo.png" alt="SweetBite Logo" style="width: 85px; height: 85px; border-radius: 50%; border: 3px solid #d2a679; object-fit: cover; margin-bottom: 12px; box-shadow: 0 4px 8px rgba(0,0,0,0.2);">
                <h5 style="color: #d2a679; font-weight: 900; letter-spacing: 1px; margin-bottom: 2px;">SweetBite Cookies</h5>
                <span style="font-size: 13px; color: #adb5bd; text-transform: uppercase; letter-spacing: 2px;">Admin Dashboard</span>
            </div>
            
            <div class="px-3 mb-3 text-white text-center fw-bold" style="font-size: 15px; letter-spacing: 1px;">Welcome, <%= session.getAttribute("userName") %></div>
            <a href="admin_hub.jsp" class="active"><i class="fas fa-home me-2"></i> Dashboard</a>
            <a href="MenuServlet"><i class="fas fa-box-open me-2"></i> Manage Menu</a>
            <a href="OrderServlet"><i class="fas fa-receipt me-2"></i> Customer Orders</a>
            <a href="PromotionServlet"><i class="fas fa-tags me-2"></i> Promotions</a>
            
            <hr style="border-color: #495057;">
            <a href="LogoutServlet" class="text-danger"><i class="fas fa-sign-out-alt me-2"></i> Logout</a>
        </div>
        
        <div class="main-content">
            <h2 class="mb-1 text-dark fw-bold">Admin Control Center</h2>
            <p class="text-muted mb-5">Select a module below to manage the SweetBite database.</p>

            <div class="row">
                <div class="col-md-4 mb-4">
                    <div class="card stat-card shadow-sm h-100 p-4 text-center">
                        <div class="d-flex justify-content-center">
                            <div class="icon-box bg-primary text-white bg-opacity-75"><i class="fas fa-box-open"></i></div>
                        </div>
                        <h4 class="fw-bold">Menu & Inventory</h4>
                        <p class="text-muted small">Add, update, or remove cookie flavors and manage stock levels.</p>
                        <a href="MenuServlet" class="btn btn-primary mt-auto">Manage Menu <i class="fas fa-arrow-right ms-1"></i></a>
                    </div>
                </div>

                <div class="col-md-4 mb-4">
                    <div class="card stat-card shadow-sm h-100 p-4 text-center">
                        <div class="d-flex justify-content-center">
                            <div class="icon-box bg-success text-white bg-opacity-75"><i class="fas fa-receipt"></i></div>
                        </div>
                        <h4 class="fw-bold">Customer Orders</h4>
                        <p class="text-muted small">View incoming orders, update payment status, and manage deliveries.</p>
                        <a href="OrderServlet" class="btn btn-success mt-auto">Manage Orders <i class="fas fa-arrow-right ms-1"></i></a>
                    </div>
                </div>

                <div class="col-md-4 mb-4">
                    <div class="card stat-card shadow-sm h-100 p-4 text-center">
                        <div class="d-flex justify-content-center">
                            <div class="icon-box bg-warning text-dark bg-opacity-75"><i class="fas fa-tags"></i></div>
                        </div>
                        <h4 class="fw-bold">Promotions</h4>
                        <p class="text-muted small">Create discount codes, set flash sales, and manage visual banners.</p>
                        <a href="PromotionServlet" class="btn btn-warning mt-auto text-dark fw-bold">Manage Promotions <i class="fas fa-arrow-right ms-1"></i></a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>