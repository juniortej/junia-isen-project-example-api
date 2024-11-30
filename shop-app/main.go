package main

import (
	"github.com/Amiche02/junia-isen-project-example-api/shop-app/api/controllers"
	"github.com/Amiche02/junia-isen-project-example-api/shop-app/api/middleware"

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
