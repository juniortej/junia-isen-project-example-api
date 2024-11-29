package models

// Item represents a product available in the ShopApp.
type Item struct {
    ItemID      string           `json:"item_id" gorm:"primaryKey;type:uuid"`
    Name        string           `json:"name" gorm:"type:varchar(100);not null"`
    Description string           `json:"description" gorm:"type:text"`
    Price       float64          `json:"price" gorm:"type:decimal(10,2);not null"`
    Stock       int              `json:"stock" gorm:"type:int;not null"`
    SellerID    string           `json:"seller_id" gorm:"type:uuid;not null"`
    CategoryID  string           `json:"category_id" gorm:"type:uuid;not null"`
    
    Seller      User             `json:"seller" gorm:"foreignKey:SellerID"`
    Category    ProductCategory  `json:"category" gorm:"foreignKey:CategoryID"`
    Baskets     []BasketItem     `json:"baskets" gorm:"foreignKey:ItemID"`
    Orders      []OrderItem      `json:"orders" gorm:"foreignKey:ItemID"`
}

// ProductCategory represents a category to which items belong.
type ProductCategory struct {
    CategoryID string `json:"category_id" gorm:"primaryKey;type:uuid"`
    Name       string `json:"name" gorm:"type:varchar(100);not null"`
    
    Items      []Item `json:"items" gorm:"foreignKey:CategoryID"`
}
