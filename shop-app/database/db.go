package database

import (
	"fmt"
	"log"
	"net/url"
	"os"

	"github.com/joho/godotenv"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"

	"github.com/Amiche02/junia-isen-project-example-api/shop-app/models"
)

var GlobalDb *gorm.DB

func ConnectDB() {
	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file")
	}
	dbuser := os.Getenv("POSTGRES_USER")
	dbpwd := os.Getenv("POSTGRES_PASSWORD")
	dbhost := os.Getenv("POSTGRES_HOST")
	dbport := os.Getenv("POSTGRES_PORT")
	dbname := os.Getenv("POSTGRES_DB")

	dsn := fmt.Sprintf(
		"host=%s user=%s password=%s dbname=%s port=%s sslmode=require TimeZone=Europe/Paris",
		url.QueryEscape(dbhost),
		url.QueryEscape(dbuser),
		url.QueryEscape(dbpwd),
		url.QueryEscape(dbname),
		url.QueryEscape(dbport),
	)
	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		panic(fmt.Sprintf("failed to connect database: %v", err))
	}

	GlobalDb = db

	err = ensureUUIDExtension(db)
	if err != nil {
		log.Fatalf("Error ensuring uuid-ossp extension: %v", err)
	}

	err = db.AutoMigrate(
		&models.User{},
		&models.Basket{},
		&models.BasketItem{},
		&models.Item{},
		&models.ProductCategory{},
		&models.Order{},
		&models.OrderItem{},
	)
	if err != nil {
		log.Fatalf("Error during migration: %v", err)
	}

	log.Println("Successfully connected to database")
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
