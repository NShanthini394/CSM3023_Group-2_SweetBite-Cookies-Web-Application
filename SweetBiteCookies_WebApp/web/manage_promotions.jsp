<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List" %>
<%@page import="model.Promotion" %>
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
    <title>Manage Promotions - SweetBite Admin</title>
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
        <a href="MenuServlet"><i class="fas fa-box-open me-2"></i> Manage Menu</a>
        <a href="OrderServlet"><i class="fas fa-receipt me-2"></i> Customer Orders</a>
        <a href="PromotionServlet" class="active"><i class="fas fa-tags me-2"></i> Promotions</a>
        <hr style="border-color: #495057;">
        <a href="LogoutServlet" class="text-danger"><i class="fas fa-sign-out-alt me-2"></i> Logout</a>
    </div>
    
    <div class="main-content">
        <h2 class="mb-4 text-dark"><i class="fas fa-tags text-warning"></i> Promotion Management Center</h2>

        <div class="row">
            <div class="col-md-4">
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-warning text-dark fw-bold">Create New Deal</div>
                    <div class="card-body">
                        <form action="PromotionServlet" method="post">
                            <input type="hidden" name="action" value="add">
                            
                            <div class="mb-2">
                                <label class="form-label fw-bold">Promo ID</label>
                                <input type="text" class="form-control" name="promoID" placeholder="e.g., PRM005" required>
                            </div>
                            <div class="mb-2">
                                <label class="form-label fw-bold">Title</label>
                                <input type="text" class="form-control" name="title" placeholder="e.g., Merdeka Sale" required>
                            </div>
                            <div class="mb-2">
                                <label class="form-label fw-bold">Promo Code</label>
                                <input type="text" class="form-control" name="promoCode" placeholder="MERDEKA31" required>
                            </div>
                            <div class="mb-2">
                                <label class="form-label fw-bold">Discount Rate</label>
                                <input type="number" step="0.01" class="form-control" name="discountRate" placeholder="0.15 for 15%" required>
                            </div>
                            <div class="mb-2">
                                <label class="form-label fw-bold">Image Path <small class="text-muted">(Optional)</small></label>
                                <input type="text" class="form-control" name="image" placeholder="SlideShow/photo.jpg">
                            </div>
                            <div class="row mb-3">
                                <div class="col">
                                    <label class="form-label fw-bold">Start</label>
                                    <input type="date" class="form-control" name="startDate" required>
                                </div>
                                <div class="col">
                                    <label class="form-label fw-bold">End</label>
                                    <input type="date" class="form-control" name="endDate" required>
                                </div>
                            </div>
                            
                            <button type="submit" class="btn btn-warning w-100 fw-bold text-dark"><i class="fas fa-plus"></i> Add Promotion</button>
                        </form>
                    </div>
                </div>
            </div>

            <div class="col-md-8">
                <div class="card shadow-sm">
                    <div class="card-header bg-dark text-white fw-bold">Active Promotions Database</div>
                    <div class="card-body p-0">
                        <table class="table table-hover table-striped m-0 align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>Image</th>
                                    <th>Title</th>
                                    <th>Code</th>
                                    <th>Rate</th>
                                    <th>Valid Until</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                    List<Promotion> listPromo = (List<Promotion>) request.getAttribute("listPromo");
                                    if (listPromo != null && !listPromo.isEmpty()) {
                                        for (Promotion promo : listPromo) {
                                %>
                                <tr>
                                    <td><img src="<%= promo.getImage() %>" alt="promo" style="width: 50px; height: 50px; object-fit: cover; border-radius: 5px; border: 1px solid #ccc;"></td>
                                    <td class="fw-bold text-dark"><%= promo.getTitle() %> <br><small class="text-muted"><%= promo.getPromoID() %></small></td>
                                    <td><span class="badge bg-success"><%= promo.getPromoCode() %></span></td>
                                    <td class="fw-bold"><%= promo.getDiscountRate() %></td>
                                    <td><small><%= promo.getEndDate() %></small></td>
                                    <td>
                                        <button type="button" class="btn btn-sm btn-outline-warning text-dark fw-bold" data-bs-toggle="modal" data-bs-target="#editModal_<%= promo.getPromoID() %>"><i class="fas fa-edit"></i> Edit</button>
                                        <a href="PromotionServlet?action=delete&promoID=<%= promo.getPromoID() %>" class="btn btn-sm btn-outline-danger" onclick="return confirm('Delete this deal?');"><i class="fas fa-trash"></i></a>
                                    </td>
                                </tr>

                                <div class="modal fade" id="editModal_<%= promo.getPromoID() %>" tabindex="-1" aria-hidden="true">
                                  <div class="modal-dialog">
                                    <div class="modal-content">
                                      <div class="modal-header bg-warning text-dark">
                                        <h5 class="modal-title fw-bold"><i class="fas fa-edit"></i> Edit Promotion: <%= promo.getPromoID() %></h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                      </div>
                                      <div class="modal-body text-start">
                                        <form action="PromotionServlet" method="post">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="promoID" value="<%= promo.getPromoID() %>">
                                            
                                            <div class="mb-3">
                                                <label class="form-label fw-bold text-dark">Promotion Title</label>
                                                <input type="text" class="form-control" name="title" value="<%= promo.getTitle() %>" required>
                                            </div>
                                            <div class="row mb-3">
                                                <div class="col">
                                                    <label class="form-label fw-bold text-dark">Promo Code</label>
                                                    <input type="text" class="form-control" name="promoCode" value="<%= promo.getPromoCode() %>" required>
                                                </div>
                                                <div class="col">
                                                    <label class="form-label fw-bold text-dark">Discount Rate</label>
                                                    <input type="number" step="0.01" class="form-control" name="discountRate" value="<%= promo.getDiscountRate() %>" required>
                                                </div>
                                            </div>
                                            <div class="mb-3">
                                                <label class="form-label fw-bold text-dark">Image Path</label>
                                                <input type="text" class="form-control" name="image" value="<%= promo.getImage() %>">
                                            </div>
                                            <div class="row mb-4">
                                                <div class="col">
                                                    <label class="form-label fw-bold text-dark">Start Date</label>
                                                    <input type="date" class="form-control" name="startDate" value="<%= promo.getStartDate() %>" required>
                                                </div>
                                                <div class="col">
                                                    <label class="form-label fw-bold text-dark">End Date</label>
                                                    <input type="date" class="form-control" name="endDate" value="<%= promo.getEndDate() %>" required>
                                                </div>
                                            </div>
                                            
                                            <button type="submit" class="btn btn-warning w-100 fw-bold text-dark">Save All Changes</button>
                                        </form>
                                      </div>
                                    </div>
                                  </div>
                                </div>
                                <%      } 
                                    } else { %>
                                    <tr><td colspan="6" class="text-center text-danger py-4">No promotions found.</td></tr>
                                <% } %>
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