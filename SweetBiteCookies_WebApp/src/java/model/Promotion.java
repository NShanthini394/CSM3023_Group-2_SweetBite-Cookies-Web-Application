package model;

import java.sql.Date;

public class Promotion {
    
    // --- Attributes ---
    private String promoID;
    private String title;
    private String promoCode;
    private double discountRate;
    private Date startDate;
    private Date endDate;
    private String image; 

    // --- Constructors ---
    public Promotion() {}

    public Promotion(String promoID, String title, String promoCode, double discountRate, Date startDate, Date endDate, String image) {
        this.promoID = promoID;
        this.title = title;
        this.promoCode = promoCode;
        this.discountRate = discountRate;
        this.startDate = startDate;
        this.endDate = endDate;
        this.image = image;
    }

    // --- Getters ---
    public String getPromoID() { 
        return promoID; 
    }
    
    public String getTitle() { 
        return title; 
    }
    
    public String getPromoCode() { 
        return promoCode; 
    }
    
    public double getDiscountRate() { 
        return discountRate; 
    }
    
    public Date getStartDate() { 
        return startDate; 
    }
    
    public Date getEndDate() { 
        return endDate; 
    }
    
    public String getImage() { 
        return image; 
    }
}