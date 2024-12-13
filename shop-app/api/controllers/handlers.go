package controllers

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

// RootHandler checks if the API is running
func RootHandler(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{"message": "API is running!"})
}
