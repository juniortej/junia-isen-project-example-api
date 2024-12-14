package main

import (
	"log"
	"os"

	"github.com/Amiche02/junia-isen-project-example-api/shop-app/api/controllers"
	"github.com/Amiche02/junia-isen-project-example-api/shop-app/api/middleware"
	"github.com/Amiche02/junia-isen-project-example-api/shop-app/database"
	"github.com/gin-gonic/gin"
)

func main() {
	
	database.ConnectDB()

	r := gin.Default()

	// Public routes
	r.GET("/", controllers.RootHandler)
	r.POST("/register", controllers.Register)
	r.POST("/login", controllers.Login)

	// Protected routes
	protected := r.Group("/", middleware.AuthMiddleware())
	protected.GET("/items", controllers.GetAllItems)
	protected.GET("/items/:id", controllers.GetItemByID)
	protected.POST("/items", controllers.CreateItem)
	protected.DELETE("/items/:id", controllers.DeleteItem)

	protected.GET("/baskets", controllers.GetBasket)
	protected.POST("/baskets", controllers.AddItemToBasket)
	protected.DELETE("/baskets/:item_id", controllers.RemoveItemFromBasket)

	protected.GET("/users", controllers.GetAllUsers)

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	log.Printf("🚀 Starting server on :%s\n", port)
	if err := r.Run(":" + port); err != nil {
		log.Fatalf("❌ Failed to start server: %v", err)
	}
}
