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
    
    // Grab the customer ID securely from the session
    String customerID = (String) session.getAttribute("customerID"); 
    if (customerID == null) {
        customerID = (String) session.getAttribute("userID");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Orders - SweetBite Cookies</title>
    <link rel="icon" href="MainPhoto/SweetBite_Logo.png" type="image/png">
    <link rel="stylesheet" href="style.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #fdfaf5; padding-top: 100px; }
        .orders-container { max-width: 800px; margin: 40px auto; }
        
        /* Modern Order Card Styling */
        .order-card {
            background: white; border-radius: 15px; box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            border: none; border-left: 6px solid #8b5e3c; transition: transform 0.3s ease, box-shadow 0.3s ease;
            margin-bottom: 20px;
        }
        .order-card:hover { transform: translateY(-3px); box-shadow: 0 8px 25px rgba(0,0,0,0.1); }
        .badge-pending { background-color: #ffc107; color: #000; }
        .badge-processing { background-color: #0dcaf0; color: #000; }
        .badge-completed { background-color: #198754; color: #fff; }
        .badge-cancelled { background-color: #dc3545; color: #fff; }
        
        .btn-receipt { color: #8b5e3c; border: 1px solid #8b5e3c; border-radius: 8px; font-weight: bold; transition: 0.3s; }
        .btn-receipt:hover { background-color: #8b5e3c; color: white; }
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

    <div class="container orders-container">
        <div class="text-center mb-5">
            <i class="fas fa-shopping-bag" style="font-size: 60px; color: #8b5e3c;"></i>
            <h2 class="mt-3 text-dark fw-bold">Order History</h2>
            <p class="text-muted">Track and review your past sweet treats</p>
        </div>

        <%
            boolean hasOrders = false;
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sweetbite_db", "root", "");
                
                String sql = "SELECT * FROM `Order` WHERE customerID = ? ORDER BY date DESC";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, customerID);
                ResultSet rs = ps.executeQuery();
                
                while(rs.next()) {
                    hasOrders = true;
                    String orderID = rs.getString("orderID");
                    Date orderDate = rs.getDate("date");
                    double total = rs.getDouble("totalPrice");
                    String status = rs.getString("status");
                    
                    String badgeClass = "badge-pending";
                    if(status.equalsIgnoreCase("Pending")) badgeClass = "badge-pending";
                    else if(status.equalsIgnoreCase("Processing")) badgeClass = "badge-processing";
                    else if(status.equalsIgnoreCase("Completed")) badgeClass = "badge-completed";
                    else if(status.equalsIgnoreCase("Cancelled")) badgeClass = "badge-cancelled";
        %>
                
                <div class="card order-card">
                    <div class="card-body p-4">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <h5 class="fw-bold mb-0" style="color: #8b5e3c;">Order #<%= orderID %></h5>
                            <span class="text-muted small"><i class="far fa-calendar-alt me-1"></i> <%= orderDate %></span>
                        </div>
                        <hr style="border-color: #d2a679; opacity: 0.3;">
                        
                        <div class="d-flex justify-content-between align-items-center mt-3">
                            <div>
                                <p class="mb-1 text-dark">Total Amount: <span class="fw-bold fs-5">RM <%= String.format("%.2f", total) %></span></p>
                                <span class="badge <%= badgeClass %> px-3 py-2 rounded-pill shadow-sm" style="font-size: 13px;">
                                    <i class="fas fa-info-circle me-1"></i> <%= status %>
                                </span>
                            </div>
                            <a href="view_receipt.jsp?orderID=<%= orderID %>" class="btn btn-receipt px-4 py-2">
                                <i class="fas fa-receipt me-2"></i> View Receipt
                            </a>
                        </div>
                    </div>
                </div>

        <%
                } // End while loop
                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
            
            if (!hasOrders) {
        %>
            <div class="text-center mt-5 p-5 bg-white shadow-sm" style="border-radius: 20px; border: 2px dashed #d2a679;">
                <i class="fas fa-cookie-bite mb-3" style="font-size: 50px; color: #d2a679;"></i>
                <h4 class="fw-bold" style="color: #8b5e3c;">You haven't placed any orders yet!</h4>
                <p class="text-muted">Your sweet journey starts here. Explore our menu to find your perfect treat.</p>
                <a href="index.jsp#menu" class="btn mt-3" style="background-color: #8b5e3c; color: white; font-weight: bold; border-radius: 10px; padding: 10px 30px;">Go to Menu</a>
            </div>
        <%
            }
        %>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>