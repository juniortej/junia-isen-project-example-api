package models

import "time"

// Order represents a user's placed order.
type Order struct {
	OrderID    string    `json:"order_id" gorm:"primaryKey;type:uuid"`
	UserID     string    `json:"user_id" gorm:"type:uuid;not null"`
	CreatedAt  time.Time `json:"created_at" gorm:"autoCreateTime"`
	Status     string    `json:"status" gorm:"type:varchar(50);not null"`
	TotalPrice float64   `json:"total_price" gorm:"type:decimal(10,2);not null"`

	User       User        `json:"user" gorm:"foreignKey:UserID"`
	OrderItems []OrderItem `json:"order_items" gorm:"foreignKey:OrderID"`
}

// OrderItem represents the association between an order and an item.
type OrderItem struct {
	OrderID  string `json:"order_id" gorm:"primaryKey;type:uuid"`
	ItemID   string `json:"item_id" gorm:"primaryKey;type:uuid"`
	Quantity int    `json:"quantity" gorm:"type:int;not null"`

	Order Order `json:"order" gorm:"foreignKey:OrderID"`
	Item  Item  `json:"item" gorm:"foreignKey:ItemID"`
}
