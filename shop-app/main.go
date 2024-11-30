package main

import (
	"shop-app/api/controllers"
	"shop-app/api/middleware"

	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()

	// Public routes
	r.GET("/", controllers.RootHandler)

	// Protected routes
	protected := r.Group("/", middleware.AuthMiddleware())
	protected.GET("/items", controllers.ItemsHandler)
	protected.GET("/baskets", controllers.BasketsHandler)
	protected.GET("/users", controllers.UsersHandler)

	r.Run(":8080") 
}