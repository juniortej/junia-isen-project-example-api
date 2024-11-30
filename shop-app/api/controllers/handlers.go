package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

// RootHandler checks if the API is running
func RootHandler(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{"message": "API is running!"})
}

// ItemsHandler returns items from the database
func ItemsHandler(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"items": []string{"Item1", "Item2", "Item3"},
	})
}

// BasketsHandler returns the user's basket 
func BasketsHandler(c *gin.Context) {
	username := c.GetString("username") 
	c.JSON(http.StatusOK, gin.H{
		"username": username,
		"basket":   []string{"BasketItem1", "BasketItem2"},
	})
}

// UsersHandler returns the list of users 
func UsersHandler(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"users": []string{"User1", "User2", "User3"},
	})
}