<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Contact Us - SweetBite Cookies</title>
    <link rel="icon" href="MainPhoto/SweetBite_Logo.png" type="image/png">
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="contact-page">

    <nav class="navbar" style="padding: 15px 10% !important;">
        <div class="logo-container">
            <img src="MainPhoto/SweetBite_Logo.png" alt="SweetBites Cookies Logo" class="logo-img">
            <a href="index.jsp" style="text-decoration: none;"><span class="logo-text">SweetBite Cookies</span></a>
        </div>

        <div class="menu-toggle" onclick="toggleMenu()">☰</div>

        <ul class="nav-links m-0 ms-auto d-flex align-items-center" id="navLinks" style="list-style: none; gap: 20px;">
            <li><a href="index.jsp" style="color: white !important; font-weight: bold; font-size: 16px; text-decoration: none;">Home</a></li>
            
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

    <div class="contact-hero">
        <h1>Our Location</h1>
    </div>

    <div class="contact-container">
        <div class="contact-grid">
            <div class="info-card">
                <div class="info-item">
                    <div class="icon-box"><i class="fas fa-map-marker-alt"></i></div>
                    <div>
                        <h3>Our Bakery</h3>
                        <p>Lot 31185 D, Jalan Pantai Tok Jembal,<br>Kampung Kubang Badak,<br>21300 Kuala Terengganu, Terengganu</p>
                    </div>
                </div>
                <div class="info-item">
                    <div class="icon-box"><i class="fas fa-envelope"></i></div>
                    <div>
                        <h3>Email Us</h3>
                        <p>Email: <a href="mailto:sweetbite@gmail.com" class="text-white">sweetbite@gmail.com</a></p>
                    </div>
                </div>
                <div class="info-item">
                    <div class="icon-box"><i class="fas fa-phone-alt"></i></div>
                    <div>
                        <h3>Call Us</h3>
                        <p>011-2344325</p>
                    </div>
                </div>
                <div class="social-links">
                    <a href="#"><i class="fab fa-instagram"></i></a>
                    <a href="#"><i class="fab fa-facebook-f"></i></a>
                    <a href="#"><i class="fab fa-whatsapp"></i></a>
                </div>
            </div>
            <div class="map-card">
                <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3972.078770613897!2d103.09548367364283!3d5.404971535152708!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31b7bdb47c8af3b3%3A0x45319ef0647abf10!2sChocacake!5e0!3m2!1sen!2smy!4v1765958214109!5m2!1sen!2smy" width="100%" height="100%" class="map-frame" allowfullscreen="" loading="lazy"></iframe>
            </div>
        </div>
    </div>

    <footer class="footer">
        <div class="footer-content">
            <p>© 2026 SweetBite Cookies</p>
            <p>Email: <a href="mailto:sweetbite@gmail.com">sweetbite@gmail.com</a></p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>