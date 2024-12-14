package controllers

import (
	"net/http"

	"github.com/Amiche02/junia-isen-project-example-api/shop-app/api/helpers"
	"github.com/Amiche02/junia-isen-project-example-api/shop-app/database"
	"github.com/Amiche02/junia-isen-project-example-api/shop-app/models"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

// GetBasket returns the current user's basket
func GetBasket(c *gin.Context) {
	userEmail := c.GetString("username")
	user, err := helpers.GetUserByEmail(userEmail)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid user"})
		return
	}

	var basket models.Basket
	err = database.GlobalDb.Preload("BasketItems.Item").Preload("BasketItems.Item.Seller").First(&basket, "user_id = ?", user.UserID).Error
	if err != nil {
		// If no basket found, return an empty basket (create one if you'd like)
		basket = models.Basket{
			UserID: user.UserID,
		}
		if err := database.GlobalDb.Create(&basket).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not create basket"})
			return
		}
	}

	c.JSON(http.StatusOK, basket)
}

// AddItemToBasket adds an existing item to the user's basket
func AddItemToBasket(c *gin.Context) {
	userEmail := c.GetString("username")
	user, err := helpers.GetUserByEmail(userEmail)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid user"})
		return
	}

	var body struct {
		ItemID   string `json:"item_id"`
		Quantity int    `json:"quantity"`
	}

	if err := c.ShouldBindJSON(&body); err != nil || body.Quantity <= 0 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}

	itemID, err := uuid.Parse(body.ItemID)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid item_id format"})
		return
	}

	var item models.Item
	if err := database.GlobalDb.First(&item, "item_id = ?", itemID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Item not found"})
		return
	}

	// Get or create basket
	var basket models.Basket
	if err := database.GlobalDb.First(&basket, "user_id = ?", user.UserID).Error; err != nil {
		// Create a new basket if not found
		basket = models.Basket{UserID: user.UserID}
		if err := database.GlobalDb.Create(&basket).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not create basket"})
			return
		}
	}

	// Check if item already in basket
	var basketItem models.BasketItem
	if err := database.GlobalDb.First(&basketItem, "basket_id = ? AND item_id = ?", basket.BasketID, itemID).Error; err == nil {
		// Item already in basket, update quantity
		basketItem.Quantity += body.Quantity
		if err := database.GlobalDb.Save(&basketItem).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not update basket item"})
			return
		}
	} else {
		// Add new basket item
		basketItem = models.BasketItem{
			BasketID: basket.BasketID,
			ItemID:   itemID,
			Quantity: body.Quantity,
		}
		if err := database.GlobalDb.Create(&basketItem).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not add item to basket"})
			return
		}
	}

	c.JSON(http.StatusOK, gin.H{"message": "Item added to basket"})
}

// RemoveItemFromBasket removes an item from the basket
func RemoveItemFromBasket(c *gin.Context) {
	userEmail := c.GetString("username")
	user, err := helpers.GetUserByEmail(userEmail)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid user"})
		return
	}

	itemIDStr := c.Param("item_id")
	itemID, err := uuid.Parse(itemIDStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid item_id format"})
		return
	}

	var basket models.Basket
	if err := database.GlobalDb.First(&basket, "user_id = ?", user.UserID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Basket not found"})
		return
	}

	var basketItem models.BasketItem
	if err := database.GlobalDb.First(&basketItem, "basket_id = ? AND item_id = ?", basket.BasketID, itemID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Item not in basket"})
		return
	}

	if err := database.GlobalDb.Delete(&basketItem).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not remove item from basket"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Item removed from basket"})
}
