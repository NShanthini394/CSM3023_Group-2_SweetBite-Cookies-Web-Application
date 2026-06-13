<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List" %>
<%@page import="model.Order" %>
<%@page import="java.sql.*" %> 
<%
    // Prevent browser from caching the page after logout!
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
    
    if(session.getAttribute("userRole") == null || !session.getAttribute("userRole").equals("Admin")) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Orders - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .sidebar { min-height: 100vh; background-color: #343a40; color: white; padding-top: 20px; }
        .sidebar a { color: #adb5bd; text-decoration: none; padding: 15px; display: block; font-size: 16px; }
        .sidebar a:hover, .sidebar a.active { background-color: #495057; color: white; border-left: 4px solid #d2a679; }
        .main-content { padding: 30px; width: 100%; }
        
        /* Status Badge Colors */
        .status-Pending { background-color: #ffc107; color: #000; }
        .status-Processing { background-color: #0d6efd; color: #fff; }
        .status-Completed { background-color: #198754; color: #fff; }
        
        /* Custom scrollbar for modals with lots of cookies */
        .modal-body { max-height: 400px; overflow-y: auto; }
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
        <a href="admin_hub.jsp"><i class="fas fa-home me-2"></i> Dashboard</a>
        <a href="MenuServlet"><i class="fas fa-box-open me-2"></i> Manage Menu</a>
        <a href="OrderServlet" class="active"><i class="fas fa-receipt me-2"></i> Customer Orders</a>
        <a href="PromotionServlet"><i class="fas fa-tags me-2"></i> Promotions</a>
        
        <hr style="border-color: #495057;">
        <a href="LogoutServlet" class="text-danger"><i class="fas fa-sign-out-alt me-2"></i> Logout</a>
    </div>

    <div class="main-content">
        <h2 class="mb-4 text-dark"><i class="fas fa-receipt text-success"></i> Customer Orders Center</h2>

        <div class="card shadow-sm">
            <div class="card-header bg-success text-white fw-bold">Live Order Tracker</div>
            <div class="card-body p-0">
                <table class="table table-hover table-striped m-0 align-middle text-center">
                    <thead class="table-light">
                        <tr>
                            <th>Order ID</th>
                            <th>Date</th>
                            <th>Customer Name</th>
                            <th>Total Amount</th>
                            <th>Current Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            List<Order> listOrder = (List<Order>) request.getAttribute("listOrder");
                            if (listOrder != null && !listOrder.isEmpty()) {
                                for (Order o : listOrder) {
                        %>
                        <tr>
                            <td class="fw-bold"><%= o.getOrderID() %></td>
                            <td><%= o.getDate() %></td>
                            <td><%= o.getCustomerName() %> <br><small class="text-muted"><%= o.getCustomerID() %></small></td>
                            <td class="fw-bold text-success">RM <%= String.format("%.2f", o.getTotalPrice()) %></td>
                            <td><span class="badge status-<%= o.getStatus() %> px-3 py-2"><%= o.getStatus() %></span></td>
                            <td>
                                <div class="d-flex justify-content-center align-items-center gap-2">
                                    
                                    <button type="button" class="btn btn-sm btn-outline-dark" data-bs-toggle="modal" data-bs-target="#orderModal_<%= o.getOrderID() %>">
                                        <i class="fas fa-eye"></i> View
                                    </button>

                                    <form action="OrderServlet" method="post" class="d-flex m-0">
                                        <input type="hidden" name="action" value="updateStatus">
                                        <input type="hidden" name="orderID" value="<%= o.getOrderID() %>">
                                        <select name="status" class="form-select form-select-sm me-1" style="width: auto;">
                                            <option value="Pending" <%= o.getStatus().equals("Pending") ? "selected" : "" %>>Pending</option>
                                            <option value="Processing" <%= o.getStatus().equals("Processing") ? "selected" : "" %>>Processing</option>
                                            <option value="Completed" <%= o.getStatus().equals("Completed") ? "selected" : "" %>>Completed</option>
                                        </select>
                                        <button type="submit" class="btn btn-sm btn-primary">Update</button>
                                    </form>
                                    
                                    <a href="OrderServlet?action=delete&orderID=<%= o.getOrderID() %>" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure you want to permanently delete this order?');">
                                        <i class="fas fa-trash"></i>
                                    </a>
                                    
                                </div>
                            </td>
                        </tr>

                        <div class="modal fade" id="orderModal_<%= o.getOrderID() %>" tabindex="-1" aria-labelledby="modalLabel_<%= o.getOrderID() %>" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content" style="border-radius: 15px; overflow: hidden;">
                                    <div class="modal-header" style="background-color: #343a40; color: white;">
                                        <h5 class="modal-title fw-bold" id="modalLabel_<%= o.getOrderID() %>">
                                            <i class="fas fa-box-open me-2 text-warning"></i> Order #<%= o.getOrderID() %>
                                        </h5>
                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body p-4 text-start">
                                        <h6 class="text-muted text-uppercase small fw-bold mb-3">Items to Pack:</h6>
                                        <%
                                            try {
                                                Class.forName("com.mysql.cj.jdbc.Driver");
                                                Connection connModal = DriverManager.getConnection("jdbc:mysql://localhost:3306/sweetbite_db", "root", "");
                                                
                                                String itemSql = "SELECT m.itemName, c.quantity, c.subtotal FROM Cart c JOIN Menu m ON c.menuID = m.menuID WHERE c.orderID = ?";
                                                PreparedStatement psItem = connModal.prepareStatement(itemSql);
                                                psItem.setString(1, o.getOrderID());
                                                ResultSet rsItem = psItem.executeQuery();
                                                
                                                while(rsItem.next()) {
                                        %>
                                                <div class="d-flex justify-content-between align-items-center border-bottom py-2 mb-2">
                                                    <div>
                                                        <span class="fw-bold text-dark"><%= rsItem.getString("itemName") %></span><br>
                                                        <span class="badge bg-secondary">Qty: <%= rsItem.getInt("quantity") %></span>
                                                    </div>
                                                    <span class="fw-bold text-success">RM <%= String.format("%.2f", rsItem.getDouble("subtotal")) %></span>
                                                </div>
                                        <%
                                                } // end while
                                                connModal.close();
                                            } catch (Exception e) {
                                                out.println("<p class='text-danger'>Unable to load items.</p>");
                                            }
                                        %>
                                        
                                        <div class="d-flex justify-content-between mt-4 p-3 bg-light rounded">
                                            <span class="fw-bold text-dark fs-5">Total Paid:</span>
                                            <span class="fw-bold text-danger fs-5">RM <%= String.format("%.2f", o.getTotalPrice()) %></span>
                                        </div>
                                    </div>
                                    <div class="modal-footer bg-light">
                                        <button type="button" class="btn btn-secondary fw-bold" data-bs-dismiss="modal">Close</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <%      } // End Loop
                            } else { %>
                            <tr><td colspan="6" class="text-center text-muted py-5"><i class="fas fa-box-open fs-3 mb-3 d-block"></i> No orders found.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>