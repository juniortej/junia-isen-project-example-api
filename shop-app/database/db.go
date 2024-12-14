package database

import (
	"fmt"
	"log"
	"os"

	"github.com/Amiche02/junia-isen-project-example-api/shop-app/models"
	"gorm.io/gorm"
)

var GlobalDb *gorm.DB

func ConnectDB() {
	connectionType := os.Getenv("DB_CONNECTION_TYPE")

	if connectionType == "azure" {
		log.Println("🌐 Using Azure PostgreSQL connection")
		GlobalDb = ConnectAzureDB()
	} else if connectionType == "local" {
		log.Println("🛠️ Using Local PostgreSQL connection")
		GlobalDb = ConnectLocalDB()
	} else {
		log.Fatalf("❌ Invalid DB_CONNECTION_TYPE: %s. Must be 'local' or 'azure'", connectionType)
	}

	if err := ensureUUIDExtension(GlobalDb); err != nil {
		log.Fatalf("Error ensuring uuid-ossp extension: %v", err)
	}

	err := GlobalDb.AutoMigrate(
		&models.User{},
		&models.ProductCategory{},
		&models.Item{},
		&models.Basket{},
		&models.BasketItem{},
		&models.Order{},
		&models.OrderItem{},
	)
	if err != nil {
		log.Fatalf("Error during migration: %v", err)
	}
}

func ensureUUIDExtension(db *gorm.DB) error {
	sqlDB, err := db.DB()
	if err != nil {
		return fmt.Errorf("failed to get sql.DB from gorm.DB: %w", err)
	}

	_, err = sqlDB.Exec(`CREATE EXTENSION IF NOT EXISTS "uuid-ossp";`)
	if err != nil {
		return fmt.Errorf("failed to create uuid-ossp extension: %w", err)
	}

	log.Println("uuid-ossp extension ensured")
	return nil
}
