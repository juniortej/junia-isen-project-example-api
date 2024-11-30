package models

import "time"

// User represents a user of the ShopApp.
type User struct {
	UserID    string    `json:"user_id" gorm:"primaryKey;type:uuid"`
	Name      string    `json:"name" gorm:"type:varchar(100);not null"`
	Email     string    `json:"email" gorm:"type:varchar(100);unique;not null"`
	Password  string    `json:"password" gorm:"type:varchar(255);not null"`
	CreatedAt time.Time `json:"created_at" gorm:"autoCreateTime"`

	Baskets []Basket `json:"baskets" gorm:"foreignKey:UserID"`
	Orders  []Order  `json:"orders" gorm:"foreignKey:UserID"`
	Items   []Item   `json:"items" gorm:"foreignKey:SellerID"`
}

// Basket represents a user's shopping basket.
type Basket struct {
	BasketID  string    `json:"basket_id" gorm:"primaryKey;type:uuid"`
	UserID    string    `json:"user_id" gorm:"type:uuid;not null"`
	CreatedAt time.Time `json:"created_at" gorm:"autoCreateTime"`

	User        User         `json:"user" gorm:"foreignKey:UserID"`
	BasketItems []BasketItem `json:"basket_items" gorm:"foreignKey:BasketID"`
}

// BasketItem represents the association between a basket and an item.
type BasketItem struct {
	BasketID string `json:"basket_id" gorm:"primaryKey;type:uuid"`
	ItemID   string `json:"item_id" gorm:"primaryKey;type:uuid"`
	Quantity int    `json:"quantity" gorm:"type:int;not null"`

	Basket Basket `json:"basket" gorm:"foreignKey:BasketID"`
	Item   Item   `json:"item" gorm:"foreignKey:ItemID"`
}
