package controllers

import (
	"net/http"

	"github.com/Amiche02/junia-isen-project-example-api/shop-app/api/helpers"
	"github.com/Amiche02/junia-isen-project-example-api/shop-app/database"
	"github.com/Amiche02/junia-isen-project-example-api/shop-app/models"
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

// GetAllItems returns all items from the database
func GetAllItems(c *gin.Context) {
	var items []models.Item
	if err := database.GlobalDb.Preload("Seller").Preload("Category").Find(&items).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not retrieve items"})
		return
	}
	c.JSON(http.StatusOK, items)
}

// GetItemByID returns a single item by ID
func GetItemByID(c *gin.Context) {
	id := c.Param("id")
	itemID, err := uuid.Parse(id)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid item ID"})
		return
	}

	var item models.Item
	if err := database.GlobalDb.Preload("Seller").Preload("Category").First(&item, "item_id = ?", itemID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Item not found"})
		return
	}

	c.JSON(http.StatusOK, item)
}

// CreateItem creates a new item
func CreateItem(c *gin.Context) {
	userEmail := c.GetString("username")
	user, err := helpers.GetUserByEmail(userEmail)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid user"})
		return
	}

	var body struct {
		Name        string  `json:"name"`
		Description string  `json:"description"`
		Price       float64 `json:"price"`
		Stock       int     `json:"stock"`
		CategoryName string `json:"category_name"`
	}

	if err := c.ShouldBindJSON(&body); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}

	var category models.ProductCategory
	if err := database.GlobalDb.First(&category, "name = ?", body.CategoryName).Error; err != nil {
		category = models.ProductCategory{
			Name: body.CategoryName,
		}
		if err := database.GlobalDb.Create(&category).Error; err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not create category"})
			return
		}
	}

	// Step 3: Create the new item
	item := models.Item{
		Name:        body.Name,
		Description: body.Description,
		Price:       body.Price,
		Stock:       body.Stock,
		SellerID:    user.UserID,
		CategoryID:  category.CategoryID, 
	}

	if err := database.GlobalDb.Create(&item).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not create item"})
		return
	}

	c.JSON(http.StatusCreated, item)
}

// DeleteItem removes an item from the database
func DeleteItem(c *gin.Context) {
	id := c.Param("id")
	itemID, err := uuid.Parse(id)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid item ID"})
		return
	}

	// Only the seller who owns the item or an admin (not implemented) could delete. 
	// For simplicity, we'll just allow the item owner to delete.
	userEmail := c.GetString("username")
	user, err := helpers.GetUserByEmail(userEmail)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid user"})
		return
	}

	var item models.Item
	if err := database.GlobalDb.First(&item, "item_id = ?", itemID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Item not found"})
		return
	}

	// Check ownership
	if item.SellerID != user.UserID {
		c.JSON(http.StatusForbidden, gin.H{"error": "You are not the seller of this item"})
		return
	}

	if err := database.GlobalDb.Delete(&item).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not delete item"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Item deleted"})
}
