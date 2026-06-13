<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, java.util.*, model.Menu, model.Promotion" %>
<%
    // Prevent browser from caching the page after logout!
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
    
    // Security check: Must be logged in!
    if(session.getAttribute("userName") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Menu> availableCookies = new ArrayList<>();
    List<Promotion> activePromos = new ArrayList<>();
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sweetbite_db", "root", "");
        
        // 1. Fetch available cookies
        PreparedStatement stmtMenu = conn.prepareStatement("SELECT * FROM Menu WHERE stockQuantity > 0");
        ResultSet rsMenu = stmtMenu.executeQuery();
        while (rsMenu.next()) {
            availableCookies.add(new Menu(
                rsMenu.getString("menuID"), rsMenu.getString("itemName"), "", rsMenu.getDouble("price"), 0, "", ""
            ));
        }
        
        // 2. Fetch active promotions for the dropdown
        PreparedStatement stmtPromo = conn.prepareStatement("SELECT * FROM Promotion WHERE CURDATE() BETWEEN startDate AND endDate");
        ResultSet rsPromo = stmtPromo.executeQuery();
        while (rsPromo.next()) {
            activePromos.add(new Promotion(
                rsPromo.getString("promoID"), rsPromo.getString("title"), rsPromo.getString("promoCode"), 
                rsPromo.getDouble("discountRate"), rsPromo.getDate("startDate"), rsPromo.getDate("endDate"), ""
            ));
        }
        
        conn.close();
    } catch (Exception e) { 
        e.printStackTrace(); 
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Checkout - SweetBite Cookies</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #fdfaf6; font-family: Arial, sans-serif; }
        .checkout-card { background: white; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.05); padding: 40px; margin-top: 50px; border-top: 8px solid #8b5a2b; }
        .form-label { font-weight: bold; color: #8b5a2b; }
        .btn-confirm { background-color: #28a745; color: white; font-weight: bold; font-size: 18px; padding: 12px; border-radius: 8px; }
        .btn-confirm:hover { background-color: #218838; }
        .promo-box { background-color: #fdfaf6; border: 1px dashed #d2a679; padding: 15px; border-radius: 8px; }
        .live-total-box { background-color: #fffaf0; border: 2px solid #8b5a2b; border-radius: 8px; padding: 15px; margin-top: 20px; }
    </style>
</head>
<body>

    <nav class="navbar navbar-dark" style="background-color: #8b5a2b; padding: 15px 30px;">
        <a class="navbar-brand fw-bold d-flex align-items-center" href="index.jsp">
            <img src="MainPhoto/SweetBite_Logo.png" alt="SweetBite Logo" style="width: 40px; height: 40px; border-radius: 50%; border: 2px solid white; margin-right: 12px; box-shadow: 0 2px 4px rgba(0,0,0,0.2);">
            ⬅ Back to Storefront
        </a>
    </nav>

    <div class="container pb-5">
        <div class="row justify-content-center">
            <div class="col-md-9">
                <div class="checkout-card">
                    <h2 class="text-center mb-4" style="color: #8b5a2b; font-weight: 900;">Complete Your Order</h2>
                    
                    <form action="CheckoutServlet" method="post" id="checkoutForm">
                        <div class="row mb-4">
                            <div class="col-md-6 border-end pe-4">
                                <h5 class="mb-3 text-muted border-bottom pb-2">Delivery Details</h5>
                                
                                <div class="mb-3">
                                    <label class="form-label">Full Name</label>
                                    <input type="text" class="form-control" value="<%= session.getAttribute("userName") %>" readonly>
                                </div>
                                
                                <div class="form-group mb-3">
                                    <label class="form-label">Phone Number</label>
                                    <input type="tel" id="phoneInput" name="phone" placeholder="012-3456789" required style="width: 100%; box-sizing: border-box; padding: 6px 12px; border: 1px solid #ced4da; border-radius: 4px;" onkeypress="return (event.charCode >= 48 && event.charCode <= 57) || event.charCode === 45">
                                    <small style="color: gray; font-size: 12px; margin-top: 4px; display: block;">Numbers and dashes only.</small>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">Full Address</label>
                                    <textarea class="form-control" rows="3" placeholder="Enter full delivery address..." required></textarea>
                                </div>
                                
                                <h5 class="mb-3 mt-4 text-muted border-bottom pb-2">Payment Method</h5>
                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="radio" name="paymentMethod" value="COD" id="payCOD" checked readonly>
                                    <label class="form-check-label fw-bold text-success" for="payCOD">
                                        <i class="fas fa-money-bill-wave me-1"></i> Cash on Delivery (COD)
                                    </label>
                                </div>
                                <small class="text-muted" style="font-size: 12px;">Pay conveniently when your cookies arrive!</small>
                            </div>

                            <div class="col-md-6 ps-4">
                                <h5 class="mb-3 text-muted border-bottom pb-2">Order Summary</h5>
                                
                                <div class="mb-3">
                                    <label class="form-label">Select Cookie</label>
                                    <select class="form-select" name="menuID" id="cookieSelect" onchange="calculateTotal()" required>
                                        <option value="" data-price="0">-- Choose a Flavor --</option>
                                        <% for (Menu m : availableCookies) { %>
                                            <option value="<%= m.getMenuID() %>" data-price="<%= m.getPrice() %>">
                                                <%= m.getItemName() %> (RM <%= String.format("%.2f", m.getPrice()) %>)
                                            </option>
                                        <% } %>
                                    </select>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">Quantity (Boxes)</label>
                                    <input type="number" name="quantity" id="qtyInput" class="form-control" value="1" min="1" onchange="calculateTotal()" onkeyup="calculateTotal()" required>
                                </div>

                                <div class="promo-box mb-4">
                                    <label class="form-label text-success">🎟️ Select Promo Code</label>
                                    <select class="form-select" name="promoCode" id="promoSelect" onchange="calculateTotal()">
                                        <option value="" data-discount="0">-- No Promo Code --</option>
                                        <% for (Promotion p : activePromos) { 
                                             int percent = (int)(p.getDiscountRate() * 100);
                                        %>
                                            <option value="<%= p.getPromoCode() %>" data-discount="<%= p.getDiscountRate() %>">
                                                <%= p.getTitle() %> (<%= percent %>% OFF)
                                            </option>
                                        <% } %>
                                    </select>
                                </div>

                                <div class="live-total-box text-center">
                                    <h5 class="text-muted mb-1">Total to Pay</h5>
                                    <h2 id="displayTotal" class="text-success fw-bold m-0">RM 0.00</h2>
                                </div>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-confirm w-100 mt-3">Confirm Secure Order</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Phone Formatter
        const phoneInput = document.getElementById('phoneInput');
        if(phoneInput) {
            phoneInput.addEventListener('input', function (e) {
                let value = e.target.value.replace(/\D/g, ''); 
                if (value.length > 3) {
                    value = value.slice(0, 3) + '-' + value.slice(3);
                }
                e.target.value = value.slice(0, 12); 
            });
        }

        // Pricing Calculator
        function calculateTotal() {
            var cookieDropdown = document.getElementById("cookieSelect");
            var qtyInput = document.getElementById("qtyInput");
            var promoDropdown = document.getElementById("promoSelect");
            
            var price = 0;
            if(cookieDropdown.selectedIndex > 0) {
                price = parseFloat(cookieDropdown.options[cookieDropdown.selectedIndex].getAttribute("data-price"));
            }
            
            var qty = parseInt(qtyInput.value) || 1;
            
            var discount = 0;
            if(promoDropdown.selectedIndex > 0) {
                discount = parseFloat(promoDropdown.options[promoDropdown.selectedIndex].getAttribute("data-discount"));
            }

            var subtotal = price * qty;
            var finalTotal = subtotal - (subtotal * discount);

            document.getElementById("displayTotal").innerText = "RM " + finalTotal.toFixed(2);
        }
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>