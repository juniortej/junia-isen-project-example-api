package database

import (
	"fmt"
	"log"
	"net/url"
	"os"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

func ConnectAzureDB() *gorm.DB {

	dbuser := os.Getenv("AZURE_POSTGRES_USER")
	dbpwd := os.Getenv("AZURE_POSTGRES_PASSWORD")
	dbhost := os.Getenv("AZURE_POSTGRES_HOST")
	dbport := os.Getenv("AZURE_POSTGRES_PORT")
	dbname := os.Getenv("AZURE_POSTGRES_DB")

	vpnGateway := os.Getenv("VPN_GATEWAY_PUBLIC_IP")
	if vpnGateway != "" {
		log.Printf("ℹ️ VPN Gateway detected: %s. Ensure VPN connection is active if required.", vpnGateway)
	}

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
		log.Fatalf("❌ Failed to connect to Azure PostgreSQL: %v", err)
	}

	log.Println("✅ Successfully connected to Azure PostgreSQL")
	return db
}
