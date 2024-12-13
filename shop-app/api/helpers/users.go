package helpers

import (
	"errors"

	"github.com/Amiche02/junia-isen-project-example-api/shop-app/database"
	"github.com/Amiche02/junia-isen-project-example-api/shop-app/models"
)

func GetUserByEmail(email string) (models.User, error) {
	var user models.User
	if err := database.GlobalDb.First(&user, "email = ?", email).Error; err != nil {
		return user, errors.New("user not found")
	}
	return user, nil
}
