package models

import (
	"github.com/google/uuid"
)

type User struct {
	UserId         uuid.UUID `json:"id" gorm:"type:uuid;default:uuid_generate_v4();primaryKey"`
	FirstName      string
	LastName       string
	Email          string `gorm:"unique"`
	PasswordHash   string
	PasswordSalt   string
	Phone          string
	Address        string
}
