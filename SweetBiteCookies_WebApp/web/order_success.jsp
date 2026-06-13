<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, java.util.*" %>
<%
    // Prevent browser from caching the page after logout!
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
    
    // 1. Security Check: Must be logged in!
    if(session.getAttribute("userName") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. Grab the Order ID from the URL
    String orderID = request.getParameter("orderID");
    if(orderID == null || orderID.isEmpty()) {
        response.sendRedirect("index.jsp"); // If they try to guess the URL, kick them out
        return;
    }

    // Variables to hold the receipt data
    String customerName = (String) session.getAttribute("userName");
    java.sql.Date orderDate = null; 
    double totalPrice = 0.0;
    String status = "";
    String itemName = "";
    int quantity = 0;
    String imagePath = "SlideShow/cookies.jpg";

    // 3. Fetch the exact order details from the database!
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sweetbite_db", "root", "");
        
        // This massive SQL JOIN connects Order -> Cart -> Menu to get everything in one query!
        String sql = "SELECT o.date, o.totalPrice, o.status, m.itemName, m.image, c.quantity " +
                     "FROM `Order` o " +
                     "JOIN Cart c ON o.orderID = c.orderID " +
                     "JOIN Menu m ON c.menuID = m.menuID " +
                     "WHERE o.orderID = ?";
                     
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, orderID);
        ResultSet rs = stmt.executeQuery();
        
        if (rs.next()) {
            orderDate = rs.getDate("date");
            totalPrice = rs.getDouble("totalPrice");
            status = rs.getString("status");
            itemName = rs.getString("itemName");
            quantity = rs.getInt("quantity");
            imagePath = rs.getString("image");
        }
        conn.close();
    } catch (Exception e) { 
        e.printStackTrace(); 
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Order Confirmed - SweetBite</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #fdfaf6; font-family: Arial, sans-serif; }
        .receipt-card { 
            background: white; border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.08); 
            padding: 40px; margin-top: 50px; border-top: 8px solid #28a745; 
        }
        .order-id-badge {
            background-color: #f8f9fa; border: 1px dashed #ccc; padding: 8px 15px;
            border-radius: 8px; font-family: monospace; font-size: 16px; color: #666;
        }
        .item-row {
            display: flex; align-items: center; padding: 15px;
            background-color: #fffaf0; border-radius: 10px; margin-top: 20px;
        }
        .item-image {
            width: 80px; height: 80px; object-fit: cover; border-radius: 8px;
            margin-right: 15px; box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .btn-home {
            background-color: #8b5a2b; color: white; font-weight: bold;
            padding: 12px 30px; border-radius: 8px;
        }
        .btn-home:hover { background-color: #6f4428; color: white; }
    </style>
</head>
<body>

    <div class="container pb-5">
        <div class="row justify-content-center">
            <div class="col-md-7">
                <div class="receipt-card text-center">
                    
                    <div class="mb-4 text-success" style="font-size: 60px;">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    
                    <h2 style="color: #28a745; font-weight: 900;">Payment Successful!</h2>
                    <p class="text-muted mb-4">Thank you, <%= customerName %>! Your order has been securely processed and is now pending kitchen approval.</p>

                    <div class="order-id-badge mb-4">
                        Order Number: <strong><%= orderID %></strong>
                    </div>

                    <hr style="border-color: #eee;">

                    <div class="text-start mt-4">
                        <h5 class="text-muted mb-3">Receipt Summary</h5>
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">Date:</span>
                            <span class="fw-bold"><%= orderDate %></span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">Payment Method:</span>
                            <span class="fw-bold">Cash on Delivery (COD)</span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">Order Status:</span>
                            <span class="badge bg-warning text-dark"><%= status %></span>
                        </div>

                        <div class="item-row">
                            <img src="<%= imagePath %>" alt="Cookie" class="item-image">
                            <div class="flex-grow-1">
                                <h6 class="mb-1 fw-bold" style="color: #8b5a2b;"><%= itemName %></h6>
                                <p class="text-muted mb-0" style="font-size: 14px;">Quantity: <%= quantity %> Box(es)</p>
                            </div>
                        </div>

                        <div class="d-flex justify-content-between align-items-center mt-4 pt-3 border-top">
                            <h5 class="text-muted m-0">Total Paid:</h5>
                            <h3 class="text-success fw-bold m-0">RM <%= String.format("%.2f", totalPrice) %></h3>
                        </div>
                    </div>

                    <div class="mt-5">
                        <a href="index.jsp" class="btn btn-home w-100"><i class="fas fa-arrow-left me-2"></i> Return to Home</a>
                    </div>

                </div>
            </div>
        </div>
    </div>

</body>
</html>