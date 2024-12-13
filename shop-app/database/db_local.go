package database

import (
	"fmt"
	"log"
	"net/url"
	"os"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

func ConnectLocalDB() *gorm.DB {
	dbuser := os.Getenv("LOCAL_POSTGRES_USER")
	dbpwd := os.Getenv("LOCAL_POSTGRES_PASSWORD")
	dbhost := os.Getenv("LOCAL_POSTGRES_HOST")
	dbport := os.Getenv("LOCAL_POSTGRES_PORT")
	dbname := os.Getenv("LOCAL_POSTGRES_DB")

	if dbuser == "" || dbpwd == "" || dbhost == "" || dbport == "" || dbname == "" {
		log.Fatalf("❌ Missing one or more required local Postgres environment variables")
	}

	dsn := fmt.Sprintf(
		"host=%s user=%s password=%s dbname=%s port=%s sslmode=disable TimeZone=Europe/Paris",
		url.QueryEscape(dbhost),
		url.QueryEscape(dbuser),
		url.QueryEscape(dbpwd),
		url.QueryEscape(dbname),
		url.QueryEscape(dbport),
	)

	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatalf("❌ Failed to connect to local database: %v", err)
	}

	log.Println("✅ Successfully connected to Local PostgreSQL")
	return db
}
