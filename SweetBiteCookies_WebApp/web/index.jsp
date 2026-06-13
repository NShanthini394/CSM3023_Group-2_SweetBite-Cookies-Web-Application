<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, java.util.*, model.Promotion, model.Menu" %>
<%   
    // Prevent browser from caching the page after logout!
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
    
    // 1. Create lists to hold our dynamic data
    List<Promotion> activePromos = new ArrayList<>();
    List<Menu> classicMenu = new ArrayList<>();
    List<Menu> premiumMenu = new ArrayList<>();
    List<Menu> seasonalMenu = new ArrayList<>();
    
    // 2. Database credentials
    String jdbcURL = "jdbc:mysql://localhost:3306/sweetbite_db";
    String jdbcUsername = "root";
    String jdbcPassword = ""; 

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
        
        // --- A. FETCH PROMOTIONS ---
        String sqlPromo = "SELECT * FROM Promotion WHERE CURDATE() BETWEEN startDate AND endDate";
        PreparedStatement stmtPromo = conn.prepareStatement(sqlPromo);
        ResultSet rsPromo = stmtPromo.executeQuery();

        while (rsPromo.next()) {
            activePromos.add(new Promotion(
                rsPromo.getString("promoID"), rsPromo.getString("title"), rsPromo.getString("promoCode"),
                rsPromo.getDouble("discountRate"), rsPromo.getDate("startDate"), rsPromo.getDate("endDate"), rsPromo.getString("image")
            ));
        }

        // --- B. FETCH MENU ITEMS ---
        String sqlMenu = "SELECT * FROM Menu";
        PreparedStatement stmtMenu = conn.prepareStatement(sqlMenu);
        ResultSet rsMenu = stmtMenu.executeQuery();

        while (rsMenu.next()) {
            Menu m = new Menu(
                rsMenu.getString("menuID"), rsMenu.getString("itemName"), rsMenu.getString("description"),
                rsMenu.getDouble("price"), rsMenu.getInt("stockQuantity"), rsMenu.getString("image"), rsMenu.getString("category")
            );
            
            // Sort them into the correct categories for the UI
            if ("Classic Favorites".equals(m.getCategory())) {
                classicMenu.add(m);
            } else if ("Premium Selections".equals(m.getCategory())) {
                premiumMenu.add(m);
            } else if ("Seasonal Specials".equals(m.getCategory())) {
                seasonalMenu.add(m);
            }
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
    <title>SweetBite Cookies</title>
    <link rel="icon" href="MainPhoto/SweetBite_Logo.png" type="image/png">
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>   

    <nav class="navbar">
        <div class="logo-container">
            <img src="MainPhoto/SweetBite_Logo.png" alt="SweetBites Cookies Logo" class="logo-img">
            <span class="logo-text">SweetBite Cookies</span>
        </div>

        <div class="menu-toggle" onclick="toggleMenu()">☰</div>

        <ul class="nav-links m-0 ms-auto d-flex align-items-center" id="navLinks" style="list-style: none; gap: 20px;">
            <li><a href="#about">About Us</a></li>
            <li><a href="#menu">Menu</a></li>
            <li><a href="#promo">Promotions</a></li>
            <li><a href="order.jsp">Order</a></li>
            <li><a href="#gallery">Gallery</a></li>
            <li><a href="contactUs.jsp">Contact Us</a></li>
            
            <% if (session.getAttribute("userName") != null && session.getAttribute("userRole") != null && session.getAttribute("userRole").equals("Customer")) { %>
                <li class="nav-item dropdown">
                    <a class="nav-link d-flex align-items-center justify-content-center" href="#" id="accountDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false" style="background-color: transparent; border: none; color: white !important; transition: transform 0.3s ease; padding: 0;">
                        <i class="far fa-user-circle" style="font-size: 28px;"></i>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end mt-3 shadow" aria-labelledby="accountDropdown" style="border: 2px solid #8b5a2b; border-radius: 12px; background-color: #fdfaf6; min-width: 220px; padding: 0;">
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
            <% } else { %>
                <li style="list-style: none;"><a href="login.jsp" style="font-weight: bold; color: #fff !important; background-color: #8b5a2b; padding: 8px 20px; border-radius: 20px; text-decoration: none;">Login</a></li>
            <% } %>
        </ul>
    </nav>

    <div class="slideshow-container">
        <img class="slides" src="SlideShow/slide1.jpg" alt="Cookies 1">
        <img class="slides" src="SlideShow/slide2.jpg" alt="Cookies 2">
        <img class="slides" src="SlideShow/slide3.jpg" alt="Cookies 3">
        <div class="dots"><span class="dot"></span><span class="dot"></span><span class="dot"></span></div>
    </div>

    <div class="main-content">
        <div class="welcome-wrapper">
            <section class="welcome-section">
                <h1 class="welcome-title">Welcome to SweetBite Cookies</h1>
                <p class="welcome-text">At SweetBite Cookies, we bake happiness into every bite. Discover freshly baked cookies made with love, premium ingredients, and irresistible flavors just for you.</p>
                <a href="#menu" class="welcome-btn">Explore Our Cookies</a>
            </section>
        </div>

        <section id="about" class="section-header">
            <h1 class="text-brand-color">About Us</h1>
            <p>"Good bakes should make you feel good too."</p>

            <section class="promo decorated-promo">
                <div class="promo-image">
                    <img src="SlideShow/photo4.jpg" alt="Chocolate Chip Cookies">
                </div>
                <div class="promo-text">
                    <h2>Our Promise & Commitment</h2>
                    <p>At SweetBite Cookies, we are committed to delivering honesty, quality, and deliciousness in every bite.</p>
                    <div class="policy-cards">
                        <div class="policy-card"><h3>Quality Policy</h3><ul><li>Meet or exceed expectations.</li><li>Source from approved suppliers.</li><li>Follow strict GMP.</li></ul></div>
                        <div class="policy-card"><h3>Food Safety</h3><ul><li>HACCP-based system.</li><li>Hygiene programs.</li><li>Staff training.</li></ul></div>
                        <div class="policy-card"><h3>Halal Policy</h3><ul><li>Comply with JAKIM standards.</li><li>Approved ingredients.</li><li>Halal oversight.</li></ul></div>
                    </div>
                </div>
            </section>
        </section>

        <section id="menu" class="menu-intro">
            <h2>Our Delicious Menu</h2>
            <p>"Handcrafted cookies baked fresh daily. Explore our wide range of flavors and find your perfect treat!"</p>

            <section class="menu-category">
                <h2>Classic Favorites</h2>
                <div class="menu-grid">
                    <% for (Menu m : classicMenu) { %>
                    <div class="menu-item">
                        <img src="<%= m.getImage() %>" alt="<%= m.getItemName() %>">
                        <h3><%= m.getItemName() %></h3>
                        <p><%= m.getDescription() %></p>
                        <span class="price">RM<%= String.format("%.2f", m.getPrice()) %> / box</span>
                    </div>
                    <% } %>
                </div>
            </section>

            <section class="menu-category">
                <h2>Premium Selections</h2>
                <div class="menu-grid">
                    <% for (Menu m : premiumMenu) { %>
                    <div class="menu-item">
                        <img src="<%= m.getImage() %>" alt="<%= m.getItemName() %>">
                        <h3><%= m.getItemName() %></h3>
                        <p><%= m.getDescription() %></p>
                        <span class="price">RM<%= String.format("%.2f", m.getPrice()) %> / box</span>
                    </div>
                    <% } %>
                </div>
            </section>

            <section class="menu-category">
                <h2>Seasonal Specials</h2>
                <div class="menu-grid">
                    <% for (Menu m : seasonalMenu) { %>
                    <div class="menu-item">
                        <img src="<%= m.getImage() %>" alt="<%= m.getItemName() %>">
                        <h3><%= m.getItemName() %></h3>
                        <p><%= m.getDescription() %></p>
                        <span class="price">RM<%= String.format("%.2f", m.getPrice()) %> / box</span>
                    </div>
                    <% } %>
                </div>
            </section>
        </section>

        <section id="promo" class="promo-intro">
            <h2>Sweet Promotions</h2>
            <p>"Grab our seasonal specials and exclusive discounts! Sweeten your day with limited-time offers."</p>

            <div class="promotions-section" style="text-align: center; padding: 40px 20px; background-color: #fdfaf6;">
                <h2 style="color: #8b5a2b; margin-bottom: 30px;">Today's Active Deals</h2>
                
                <div style="display: flex; flex-wrap: wrap; justify-content: center; gap: 20px;">
                <% if (activePromos.isEmpty()) { %>
                    <p style="color: gray; width: 100%;">No active promotions at this time. Check back soon!</p>
                <% } else { 
                        for (Promotion p : activePromos) { 
                            int discountPercent = (int) (p.getDiscountRate() * 100);
                %>
                        <div style="display: flex; width: 450px; background: white; border-radius: 15px; box-shadow: 0 4px 15px rgba(0,0,0,0.08); overflow: hidden; text-align: left; transition: transform 0.3s ease;">
                            <div style="width: 40%; background-color: #f4e4d4;">
                                <img src="<%= p.getImage() %>" alt="Promo" style="width: 100%; height: 100%; object-fit: cover;">
                            </div>
                            <div style="width: 60%; padding: 20px; position: relative;">
                                <h3 style="color: #28a745; margin: 0; font-size: 24px; font-weight: 900;"><%= discountPercent %>% OFF</h3>
                                <h4 style="color: #8b5a2b; margin: 5px 0 10px 0; font-size: 16px;"><%= p.getTitle() %></h4>
                                <div style="display: flex; align-items: center; gap: 10px; margin-top: 15px;">
                                    <span style="background: #f8f9fa; border: 1px dashed #d2a679; padding: 5px 12px; border-radius: 8px; font-weight: bold; color: #8b5a2b; font-size: 14px;">Code: <%= p.getPromoCode() %></span>
                                </div>
                                <p style="margin-top: 15px; font-size: 12px; color: #888;"><i class="far fa-clock"></i> Valid until: <strong style="color: #dc3545;"><%= p.getEndDate() %></strong></p>
                            </div>
                        </div>
                <%      } 
                   } 
                %>
                </div>
            </div>
        </section>

        <section id="order" class="order-cta-section">
            <h2>Ready for a Sweet Treat?</h2>
            <p>"Hand-crafted cookies delivered straight to your doorstep."</p>
            <a href="order.jsp" class="order-btn">Make Your Order Now !</a>
        </section>

        <section id="gallery" class="gallery-intro">
            <h2>Cookie Gallery</h2>
            <p>"Take a peek at our baked delights and see the love we put into every cookie!"</p>

            <section class="gallery">
                <img src="SlideShow/kedaichococake.jpg" alt="Gallery 1">
                <img src="SlideShow/cookies.jpg" alt="Gallery 2">
                <img src="SlideShow/wallcookies.jpg" alt="Gallery 3">
                <img src="SlideShow/listcookies.jpg" alt="Gallery 4">
                <img src="SlideShow/kedai.jpg" alt="Gallery 5">
                <img src="SlideShow/cookies2.jpg" alt="Gallery 6">
                <img src="SlideShow/baking2.jpg" alt="Gallery 7">
                <img src="SlideShow/baking1.jpg" alt="Gallery 8">
                <img src="SlideShow/baking3.jpg" alt="Gallery 9">
            </section>
            
            <section class="gallery video-gallery">
                <div class="video-card">
                    <div class="video-wrapper">
                        <iframe src="https://player.vimeo.com/video/1939157?badge=0&autopause=0&player_id=0&app_id=58479" frameborder="0" allow="autoplay; fullscreen; picture-in-picture" allowfullscreen></iframe>
                    </div>
                    <h3>Behind the Scenes: Our Baking Process</h3>
                    <p>Watch how we bake our cookies fresh with love, quality ingredients, and passion.</p>
                </div>
            </section>
        </section>

        <section id="contact" class="contact-intro">
            <h2>Contact Us</h2>
            <p>"Find us anytime and anywhere"</p>
            <div class="contact-section">
                <div class="map-info-row">
                    <div class="map-container">
                        <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3972.078770613897!2d103.09548367364283!3d5.404971535152708!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31b7bdb47c8af3b3%3A0x45319ef0647abf10!2sChocacake!5e0!3m2!1sen!2smy!4v1765958214109!5m2!1sen!2smy" width="100%" height="300" class="map-frame" allowfullscreen="" loading="lazy"></iframe>
                    </div>
                    <div class="info-container">
                        <h2>Our Location</h2>
                        <p>Lot 31185 D, Jalan Pantai Tok Jembal,<br>Kampung Kubang Badak,<br>21300 Kuala Terengganu, Terengganu</p>
                        <h4>Email Us</h4>
                        <p>Email: <a href="mailto:sweetbite@gmail.com" class="text-black">sweetbite@gmail.com</a></p>
                        <h4>Call Us</h4>
                        <p>011-2344325</p>
                    </div>
                </div>
            </div>
        </section>

    </div> 
    <button id="topBtn" onclick="scrollToTop()">Go To Top</button>

    <footer class="footer">
        <div class="footer-content">
            <p>© 2026 SweetBite Cookies</p>
            <p>Email: <a href="mailto:sweetbite@gmail.com">sweetbite@gmail.com</a></p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="script.js"></script>
</body>
</html>