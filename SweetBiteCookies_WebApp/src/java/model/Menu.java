package model;

public class Menu {
    
    // --- Attributes ---
    private String menuID;
    private String itemName;
    private String description;
    private double price;
    private int stockQuantity;
    private String image;
    private String category;

    // --- Constructors ---
    public Menu() {}

    public Menu(String menuID, String itemName, String description, double price, int stockQuantity, String image, String category) {
        this.menuID = menuID;
        this.itemName = itemName;
        this.description = description;
        this.price = price;
        this.stockQuantity = stockQuantity;
        this.image = image;
        this.category = category;
    }

    // --- Getters ---
    public String getMenuID() { 
        return menuID; 
    }
    
    public String getItemName() { 
        return itemName; 
    }
    
    public String getDescription() { 
        return description; 
    }
    
    public double getPrice() { 
        return price; 
    }
    
    public int getStockQuantity() { 
        return stockQuantity; 
    }
    
    public String getImage() { 
        return image; 
    }
    
    public String getCategory() { 
        return category; 
    }
}