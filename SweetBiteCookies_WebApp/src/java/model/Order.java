package model;

import java.sql.Date;

public class Order {
    
    // --- Attributes ---
    private String orderID;
    private String customerID;
    private String customerName; // Pulled dynamically via SQL JOIN from the Customer table
    private Date date;
    private double totalPrice;
    private String status;

    // --- Constructors ---
    public Order() {}

    public Order(String orderID, String customerID, String customerName, Date date, double totalPrice, String status) {
        this.orderID = orderID;
        this.customerID = customerID;
        this.customerName = customerName;
        this.date = date;
        this.totalPrice = totalPrice;
        this.status = status;
    }

    // --- Getters ---
    public String getOrderID() { 
        return orderID; 
    }
    
    public String getCustomerID() { 
        return customerID; 
    }
    
    public String getCustomerName() { 
        return customerName; 
    }
    
    public Date getDate() { 
        return date; 
    }
    
    public double getTotalPrice() { 
        return totalPrice; 
    }
    
    public String getStatus() { 
        return status; 
    }
}