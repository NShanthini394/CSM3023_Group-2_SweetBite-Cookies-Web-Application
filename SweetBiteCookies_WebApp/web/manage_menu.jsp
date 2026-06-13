<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List" %>
<%@page import="model.Menu" %>
<%
    // Prevent browser from caching the page after logout!
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
    
    // Security check
    if(session.getAttribute("userRole") == null || !session.getAttribute("userRole").equals("Admin")) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Inventory - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .sidebar { min-height: 100vh; background-color: #343a40; color: white; padding-top: 20px; }
        .sidebar a { color: #adb5bd; text-decoration: none; padding: 15px; display: block; font-size: 16px; }
        .sidebar a:hover, .sidebar a.active { background-color: #495057; color: white; border-left: 4px solid #d2a679; }
        .main-content { padding: 30px; width: 100%; }
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
        <a href="MenuServlet" class="active"><i class="fas fa-box-open me-2"></i> Manage Menu</a>
        <a href="OrderServlet"><i class="fas fa-receipt me-2"></i> Customer Orders</a>
        <a href="PromotionServlet"><i class="fas fa-tags me-2"></i> Promotions</a>
        
        <hr style="border-color: #495057;">
        <a href="LogoutServlet" class="text-danger"><i class="fas fa-sign-out-alt me-2"></i> Logout</a>
    </div>
    
    <div class="main-content">
        <h2 class="mb-4 text-dark"><i class="fas fa-box-open text-primary"></i> Inventory Management</h2>

        <div class="row">
            <div class="col-md-4">
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-primary text-white fw-bold">Add New Cookie</div>
                    <div class="card-body">
                        <form action="MenuServlet" method="post">
                            <input type="hidden" name="action" value="add">
                            
                            <div class="mb-2">
                                <label class="form-label fw-bold small">Menu ID</label>
                                <input type="text" class="form-control" name="menuID" required>
                            </div>
                            <div class="mb-2">
                                <label class="form-label fw-bold small">Item Name</label>
                                <input type="text" class="form-control" name="itemName" required>
                            </div>
                            <div class="mb-2">
                                <label class="form-label fw-bold small">Category</label>
                                <select name="category" class="form-select">
                                    <option value="Classic Favorites">Classic Favorites</option>
                                    <option value="Premium Selections">Premium Selections</option>
                                    <option value="Seasonal Specials">Seasonal Specials</option>
                                </select>
                            </div>
                            <div class="mb-2">
                                <label class="form-label fw-bold small">Description</label>
                                <textarea class="form-control" name="description" rows="2" required></textarea>
                            </div>
                            <div class="row mb-2">
                                <div class="col">
                                    <label class="form-label fw-bold small">Price/Box (RM)</label>
                                    <input type="number" step="0.01" class="form-control" name="price" required>
                                </div>
                                <div class="col">
                                    <label class="form-label fw-bold small">Stock Qty</label>
                                    <input type="number" class="form-control" name="stockQuantity" required>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-bold small">Image Path</label>
                                <input type="text" class="form-control" name="image" placeholder="SlideShow/cookies.jpg">
                            </div>
                            
                            <button type="submit" class="btn btn-primary w-100"><i class="fas fa-plus"></i> Add to Menu</button>
                        </form>
                    </div>
                </div>
            </div>

            <div class="col-md-8">
                <div class="card shadow-sm">
                    <div class="card-header bg-dark text-white fw-bold">Current Stock Levels</div>
                    <div class="card-body p-0">
                        <table class="table table-hover table-striped m-0 align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>Item</th>
                                    <th>Category</th>
                                    <th>Price</th>
                                    <th>Stock</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                    List<Menu> listMenu = (List<Menu>) request.getAttribute("listMenu");
                                    if (listMenu != null) {
                                        for (Menu m : listMenu) {
                                %>
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <img src="<%= m.getImage() %>" style="width: 40px; height: 40px; object-fit: cover; border-radius: 5px; margin-right: 10px;">
                                            <div>
                                                <strong><%= m.getItemName() %></strong><br>
                                                <small class="text-muted"><%= m.getMenuID() %></small>
                                            </div>
                                        </div>
                                    </td>
                                    <td><span class="badge bg-secondary"><%= m.getCategory() %></span></td>
                                    <td>RM <%= String.format("%.2f", m.getPrice()) %></td>
                                    <td class="<%= m.getStockQuantity() < 10 ? "text-danger fw-bold" : "text-success fw-bold" %>"><%= m.getStockQuantity() %></td>
                                    <td>
                                        <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#editModal<%= m.getMenuID() %>"><i class="fas fa-edit"></i> Edit</button>
                                        <a href="MenuServlet?action=delete&menuID=<%= m.getMenuID() %>" class="btn btn-sm btn-outline-danger" onclick="return confirm('Delete this item?');"><i class="fas fa-trash"></i></a>
                                    </td>
                                </tr>

                                <div class="modal fade" id="editModal<%= m.getMenuID() %>" tabindex="-1">
                                  <div class="modal-dialog">
                                    <div class="modal-content">
                                      <div class="modal-header bg-primary text-white">
                                        <h5 class="modal-title">Edit Item: <%= m.getMenuID() %></h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                      </div>
                                      <div class="modal-body">
                                        <form action="MenuServlet" method="post">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="menuID" value="<%= m.getMenuID() %>">
                                            
                                            <div class="mb-2">
                                                <label>Name</label>
                                                <input type="text" name="itemName" class="form-control" value="<%= m.getItemName() %>">
                                            </div>
                                            <div class="mb-2">
                                                <label>Category</label>
                                                <select name="category" class="form-select">
                                                    <option value="Classic Favorites" <%= m.getCategory().equals("Classic Favorites") ? "selected" : "" %>>Classic Favorites</option>
                                                    <option value="Premium Selections" <%= m.getCategory().equals("Premium Selections") ? "selected" : "" %>>Premium Selections</option>
                                                    <option value="Seasonal Specials" <%= m.getCategory().equals("Seasonal Specials") ? "selected" : "" %>>Seasonal Specials</option>
                                                </select>
                                            </div>
                                            <div class="mb-2">
                                                <label>Description</label>
                                                <textarea name="description" class="form-control" rows="2"><%= m.getDescription() %></textarea>
                                            </div>
                                            <div class="row">
                                                <div class="col">
                                                    <label>Price (RM)</label>
                                                    <input type="number" step="0.01" name="price" class="form-control" value="<%= m.getPrice() %>">
                                                </div>
                                                <div class="col">
                                                    <label>Stock</label>
                                                    <input type="number" name="stockQuantity" class="form-control" value="<%= m.getStockQuantity() %>">
                                                </div>
                                            </div>
                                            <div class="mt-2">
                                                <label>Image Path</label>
                                                <input type="text" name="image" class="form-control" value="<%= m.getImage() %>">
                                            </div>
                                            <button type="submit" class="btn btn-success w-100 mt-3">Save Changes</button>
                                        </form>
                                      </div>
                                    </div>
                                  </div>
                                </div>
                                <% 
                                        } // End loop
                                    } // End if
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>