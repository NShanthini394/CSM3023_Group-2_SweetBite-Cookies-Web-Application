<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%
    // Prevent browser from caching the page after logout!
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
    
    // Security Check: Kick them out if not a Customer
    if(session.getAttribute("userRole") == null || !session.getAttribute("userRole").equals("Customer")) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    String customerID = (String) session.getAttribute("customerID"); 
    if (customerID == null) {
        customerID = (String) session.getAttribute("userID");
    }
    
    // Grab the orderID from the URL we just passed
    String orderID = request.getParameter("orderID");
    
    // Security Check: If someone tries to load the page without an orderID, kick them back
    if(orderID == null || orderID.isEmpty()) {
        response.sendRedirect("my_orders.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Order Receipt - SweetBite Cookies</title>
    <link rel="icon" href="MainPhoto/SweetBite_Logo.png" type="image/png">
    <link rel="stylesheet" href="style.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #fdfaf5; padding-top: 100px; }
        .receipt-card {
            max-width: 500px; margin: 20px auto 50px; background: white; padding: 40px; border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08); border-top: 8px solid #8b5e3c; border-bottom: 8px dashed #8b5e3c;
        }
        .item-row { border-bottom: 1px dashed #ddd; padding: 10px 0; }
        .item-row:last-child { border-bottom: none; }
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
        
        <div class="mb-3 text-center">
            <a href="my_orders.jsp" class="text-decoration-none" style="color: #8b5e3c; font-weight: bold;">
                <i class="fas fa-arrow-left me-2"></i> Back to Order History
            </a>
        </div>

        <div class="receipt-card">
            <div class="text-center mb-4">
                <h2 class="fw-bold" style="color: #8b5e3c;">SweetBite Receipt</h2>
                <p class="text-muted mb-0">Order ID: <strong>#<%= orderID %></strong></p>
            </div>
            
            <hr style="border: 1px solid #8b5e3c;">
            
            <div class="mt-4 mb-4">
            <%
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sweetbite_db", "root", "");
                    
                    // 1. Verify this order actually belongs to this customer!
                    String orderCheckSql = "SELECT date, totalPrice, status FROM `Order` WHERE orderID = ? AND customerID = ?";
                    PreparedStatement psCheck = conn.prepareStatement(orderCheckSql);
                    psCheck.setString(1, orderID);
                    psCheck.setString(2, customerID);
                    ResultSet rsCheck = psCheck.executeQuery();
                    
                    if(rsCheck.next()) {
                        String date = rsCheck.getString("date");
                        double finalTotal = rsCheck.getDouble("totalPrice");
                        String status = rsCheck.getString("status");
                        
                        // 2. Fetch the items for this order by joining Cart and Menu tables
                        String itemsSql = "SELECT m.itemName, c.quantity, c.subtotal FROM Cart c JOIN Menu m ON c.menuID = m.menuID WHERE c.orderID = ?";
                        PreparedStatement psItems = conn.prepareStatement(itemsSql);
                        psItems.setString(1, orderID);
                        ResultSet rsItems = psItems.executeQuery();
                        
                        while(rsItems.next()) {
            %>
                            <div class="d-flex justify-content-between item-row">
                                <div>
                                    <span class="fw-bold text-dark"><%= rsItems.getString("itemName") %></span><br>
                                    <span class="text-muted small">Qty: <%= rsItems.getInt("quantity") %></span>
                                </div>
                                <span class="fw-bold" style="color: #8b5e3c;">RM <%= String.format("%.2f", rsItems.getDouble("subtotal")) %></span>
                            </div>
            <%
                        } // end while items
            %>
            </div>
            
            <hr style="border: 1px solid #8b5e3c;">
            
            <div class="d-flex justify-content-between align-items-center mt-3">
                <span class="fw-bold text-dark fs-5">TOTAL AMOUNT</span>
                <span class="fw-bold fs-4" style="color: #dc3545;">RM <%= String.format("%.2f", finalTotal) %></span>
            </div>
            
            <div class="text-center mt-4">
                <span class="badge bg-light text-dark border p-2"><i class="far fa-calendar-alt me-1"></i> Ordered on: <%= date %></span><br>
                <span class="badge bg-dark mt-2"><i class="fas fa-info-circle me-1"></i> Status: <%= status %></span>
            </div>

            <%
                    } else {
                        // If order doesn't exist or belongs to someone else
                        out.println("<div class='alert alert-danger text-center'>Error: Order not found or unauthorized access.</div>");
                    }
                    conn.close();
                } catch (Exception e) {
                    e.printStackTrace();
                    out.println("<div class='alert alert-danger text-center'>Database Error. Please try again later.</div>");
                }
            %>
            
            <div class="text-center mt-5">
                <button onclick="window.print()" class="btn btn-outline-secondary btn-sm"><i class="fas fa-print me-1"></i> Print Receipt</button>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>