package infrastructure

import (
	"rbac_manager/infrastructure/database"
)

func Init() {
	database.Init()
}
