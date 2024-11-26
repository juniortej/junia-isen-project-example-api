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

	dsn := "host=" + url.QueryEscape(dbhost) + " user=" + url.QueryEscape(dbuser) + " password=" + url.QueryEscape(dbpwd) + " dbname=postgres port=" + url.QueryEscape(dbport) + " sslmode=disable TimeZone=Europe/Paris"
	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		panic("failed to connect database")
	}

	GlobalDb = db

	err = ensureUUIDExtension(db)
	if err != nil {
		log.Fatalf("Error ensuring uuid-ossp extension: %v", err)
	}

	err = db.AutoMigrate(
		&models.User{},

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

	_, err = sqlDB.Exec("CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\";")
	if err != nil {
		return fmt.Errorf("failed to create uuid-ossp extension: %w", err)
	}

	log.Println("uuid-ossp extension ensured")
	return nil
}
