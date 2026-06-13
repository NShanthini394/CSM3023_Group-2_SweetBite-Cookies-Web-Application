-- 1. CLEAN SLATE: Delete the broken database and start fresh
DROP DATABASE IF EXISTS sweetbite_db;
CREATE DATABASE sweetbite_db;
USE sweetbite_db;

-- ==========================================
-- 2. PARENT TABLES (Must be created first)
-- ==========================================

CREATE TABLE Customer (
    customerID VARCHAR(50) NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    phoneNumber VARCHAR(20),
    address TEXT,
    PRIMARY KEY (customerID)
);

CREATE TABLE Staff (
    staffID VARCHAR(50) NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL,
    PRIMARY KEY (staffID)
);

-- Note: image and category columns are now included in the original table creation!
CREATE TABLE Menu (
    menuID VARCHAR(50) NOT NULL,
    itemName VARCHAR(100) NOT NULL,
    description TEXT,
    price DOUBLE NOT NULL,
    stockQuantity INT NOT NULL,
    image VARCHAR(255) DEFAULT 'SlideShow/cookies.jpg', 
    category VARCHAR(50) DEFAULT 'Classic Favorites',
    PRIMARY KEY (menuID)
);

-- Note: image column is included here as well!
CREATE TABLE Promotion (
    promoID VARCHAR(50) NOT NULL,
    title VARCHAR(100) NOT NULL,
    promoCode VARCHAR(50) NOT NULL,
    discountRate DOUBLE NOT NULL,
    startDate DATE NOT NULL,
    endDate DATE NOT NULL,
    image VARCHAR(255) DEFAULT 'MainPhoto/SweetBite_Logo.png',
    PRIMARY KEY (promoID)
);

-- ==========================================
-- 3. CHILD TABLES (Containing Foreign Keys)
-- ==========================================

CREATE TABLE `Order` (
    orderID VARCHAR(50) NOT NULL,
    customerID VARCHAR(50) NOT NULL, 
    date DATE NOT NULL,
    totalPrice DOUBLE NOT NULL,
    status VARCHAR(50) NOT NULL,
    PRIMARY KEY (orderID),
    FOREIGN KEY (customerID) REFERENCES Customer(customerID) ON DELETE CASCADE
);

CREATE TABLE Cart (
    cartID VARCHAR(50) NOT NULL,
    orderID VARCHAR(50) NOT NULL,
    menuID VARCHAR(50) NOT NULL,
    quantity INT NOT NULL,
    subtotal DOUBLE NOT NULL,
    PRIMARY KEY (cartID),
    FOREIGN KEY (orderID) REFERENCES `Order`(orderID) ON DELETE CASCADE,
    FOREIGN KEY (menuID) REFERENCES Menu(menuID) ON DELETE CASCADE
);

CREATE TABLE Order_Record (
    recordID VARCHAR(50) NOT NULL,
    orderID VARCHAR(50) NOT NULL,
    totalPrice DOUBLE NOT NULL,
    completionDate DATE NOT NULL,
    PRIMARY KEY (recordID),
    FOREIGN KEY (orderID) REFERENCES `Order`(orderID) ON DELETE CASCADE
);

-- ==========================================
-- 4. INSERT DEFAULT DATA
-- ==========================================

-- A. Active Promotions (Using dynamic dates)
INSERT INTO Promotion (promoID, title, promoCode, discountRate, startDate, endDate, image) VALUES
('PRM001', 'Grand Opening Special', 'SWEETSTART', 0.15, CURDATE() - INTERVAL 1 DAY, CURDATE() + INTERVAL 30 DAY, 'MainPhoto/SweetBite_Logo.png'),
('PRM002', 'Midterm Crunch Discount', 'STUDYBITE', 0.20, CURDATE(), CURDATE() + INTERVAL 14 DAY, 'MainPhoto/SweetBite_Logo.png'),
('PRM003', 'Weekend Flash Sale!', 'FLASH30', 0.30, CURDATE(), CURDATE() + INTERVAL 3 DAY, 'MainPhoto/SweetBite_Logo.png');

-- B. Dummy Accounts
INSERT INTO Staff (staffID, name, email, password, role) 
VALUES ('S001', 'Admin', 'admin@sweetbite.com', 'admin123', 'Manager');

INSERT INTO Customer (customerID, name, email, password, phoneNumber, address) 
VALUES ('C001', 'Valued Customer', 'customer@gmail.com', 'cust123', '011-2344325', 'Terengganu');

-- C. The 12 Cookie Menu Items
INSERT INTO Menu (menuID, itemName, description, price, stockQuantity, image, category) VALUES
('M001', 'Chocolate Chipless Cookies', 'Melty-gooey texture and bittersweet flavor', 12.00, 50, 'SlideShow/chocolatechiplesscookies.jpg', 'Classic Favorites'),
('M002', 'Oatmeal Chocolate Chip Cookies', 'Chewy cookies made with hearty oats and sweet chocolate chips.', 10.00, 50, 'SlideShow/OatmealChocChip.jpg', 'Classic Favorites'),
('M003', 'Cheesecake Brownie Cookies', 'Rich chocolate cookies swirled with creamy cheesecake filling.', 11.00, 50, 'SlideShow/Cheesecake Brownie Cookies.jpg', 'Classic Favorites'),
('M004', 'Vegan Chocolate Chip Cookies', 'Dairy and egg-free cookies filled with sweet chocolate chips.', 13.00, 50, 'SlideShow/Vegan Chocolate Chip Cookies.jpg', 'Classic Favorites'),
('M005', 'Peppermint Black & White Cookies', 'Soft chocolate cookies with peppermint white icing and dark chocolate topping.', 15.00, 50, 'SlideShow/Pappermintblack.jpg', 'Premium Selections'),
('M006', 'Peppermint Bark Cookies', 'Creamy white chocolate contrasting a delicate candy crunch.', 15.00, 50, 'SlideShow/PeppermintBarkCookies.jpg', 'Premium Selections'),
('M007', 'Gluten-Free Choc Chip Oat Cookies', 'Chewy oat-based cookies made without wheat.', 14.00, 50, 'SlideShow/Gluten-Free Chocolate Chip Oat Cookies.jpg', 'Premium Selections'),
('M008', 'Five-Spice Crackle Cookies', 'Chewy cookies infused with warm Chinese five-spice.', 15.00, 50, 'SlideShow/Five-Spice Crackle Cookies.jpg', 'Premium Selections'),
('M009', 'Hot Chocolate Cookies', 'Melts in your mouth like the silkiest hot chocolate.', 15.00, 50, 'SlideShow/hotchocolatecookies.jpg', 'Seasonal Specials'),
('M010', 'Obscenely Chocolatey Cookies', 'Ultra-rich, fudgy cookies loaded with intense chocolate flavor.', 15.00, 50, 'SlideShow/Obscenely Chocolatey Chocolate Cookies.jpg', 'Seasonal Specials'),
('M011', 'Phantom Green Cookies', 'Soft cookies topped with chocolate, vanilla, and green-tinted icing.', 15.00, 50, 'SlideShow/Black-and-White-and-Green Cookies.jpg', 'Seasonal Specials'),
('M012', 'Sparkly Red Velvet Cookies', 'Soft red velvet cookies coated in shimmering sugar.', 13.00, 50, 'SlideShow/Sparkly Red Velvet Cookies.jpg', 'Seasonal Specials');