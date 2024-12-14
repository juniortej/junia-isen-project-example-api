package controllers

import (
	"net/http"

	"github.com/Amiche02/junia-isen-project-example-api/shop-app/database"
	"github.com/Amiche02/junia-isen-project-example-api/shop-app/models"
	"github.com/gin-gonic/gin"
)

func GetAllUsers(c *gin.Context) {
	var users []models.User
	if err := database.GlobalDb.Find(&users).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Could not retrieve users"})
		return
	}
	c.JSON(http.StatusOK, users)
}
