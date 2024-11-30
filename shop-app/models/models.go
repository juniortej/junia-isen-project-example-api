package models

import (
	"time"

	"github.com/google/uuid"
)

// User represents a user of the ShopApp.
type User struct {
	UserID    uuid.UUID `json:"user_id" gorm:"type:uuid;default:uuid_generate_v4();primaryKey"`
	Name      string    `json:"name" gorm:"type:varchar(100);not null"`
	Email     string    `json:"email" gorm:"type:varchar(100);unique;not null"`
	Password  string    `json:"password" gorm:"type:varchar(255);not null"`
	CreatedAt time.Time `json:"created_at" gorm:"autoCreateTime"`

	Baskets []Basket `json:"baskets" gorm:"foreignKey:UserID"`
	Orders  []Order  `json:"orders" gorm:"foreignKey:UserID"`
	Items   []Item   `json:"items" gorm:"foreignKey:SellerID"`
}

// ProductCategory represents a category to which items belong.
type ProductCategory struct {
	CategoryID uuid.UUID `json:"category_id" gorm:"type:uuid;default:uuid_generate_v4();primaryKey"`
	Name       string    `json:"name" gorm:"type:varchar(100);not null"`

	Items []Item `json:"items" gorm:"foreignKey:CategoryID"`
}

// Item represents a product available in the ShopApp.
type Item struct {
	ItemID      uuid.UUID `json:"item_id" gorm:"type:uuid;default:uuid_generate_v4();primaryKey"`
	Name        string    `json:"name" gorm:"type:varchar(100);not null"`
	Description string    `json:"description" gorm:"type:text"`
	Price       float64   `json:"price" gorm:"type:decimal(10,2);not null"`
	Stock       int       `json:"stock" gorm:"type:int;not null"`
	SellerID    uuid.UUID `json:"seller_id" gorm:"type:uuid;not null"`
	CategoryID  uuid.UUID `json:"category_id" gorm:"type:uuid;not null"`

	Seller   User            `json:"seller" gorm:"foreignKey:SellerID"`
	Category ProductCategory `json:"category" gorm:"foreignKey:CategoryID"`
	Orders   []OrderItem     `json:"orders" gorm:"foreignKey:ItemID"`
	Baskets  []BasketItem    `json:"baskets" gorm:"foreignKey:ItemID"`
}

// Basket represents a user's shopping basket.
type Basket struct {
	BasketID  uuid.UUID `json:"basket_id" gorm:"type:uuid;default:uuid_generate_v4();primaryKey"`
	UserID    uuid.UUID `json:"user_id" gorm:"type:uuid;not null"`
	CreatedAt time.Time `json:"created_at" gorm:"autoCreateTime"`

	User        User         `json:"user" gorm:"foreignKey:UserID"`
	BasketItems []BasketItem `json:"basket_items" gorm:"foreignKey:BasketID"`
}

// BasketItem represents the association between a basket and an item.
type BasketItem struct {
	BasketID uuid.UUID `json:"basket_id" gorm:"type:uuid;not null;primaryKey"`
	ItemID   uuid.UUID `json:"item_id" gorm:"type:uuid;not null;primaryKey"`
	Quantity int       `json:"quantity" gorm:"type:int;not null"`

	Basket Basket `json:"basket" gorm:"foreignKey:BasketID"`
	Item   Item   `json:"item" gorm:"foreignKey:ItemID"`
}

// Order represents a user's placed order.
type Order struct {
	OrderID    uuid.UUID `json:"order_id" gorm:"type:uuid;default:uuid_generate_v4();primaryKey"`
	UserID     uuid.UUID `json:"user_id" gorm:"type:uuid;not null"`
	CreatedAt  time.Time `json:"created_at" gorm:"autoCreateTime"`
	Status     string    `json:"status" gorm:"type:varchar(50);not null"`
	TotalPrice float64   `json:"total_price" gorm:"type:decimal(10,2);not null"`

	User       User        `json:"user" gorm:"foreignKey:UserID"`
	OrderItems []OrderItem `json:"order_items" gorm:"foreignKey:OrderID"`
}

// OrderItem represents the association between an order and an item.
type OrderItem struct {
	OrderID  uuid.UUID `json:"order_id" gorm:"type:uuid;not null;primaryKey"`
	ItemID   uuid.UUID `json:"item_id" gorm:"type:uuid;not null;primaryKey"`
	Quantity int       `json:"quantity" gorm:"type:int;not null"`

	Order Order `json:"order" gorm:"foreignKey:OrderID"`
	Item  Item  `json:"item" gorm:"foreignKey:ItemID"`
}
