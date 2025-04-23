package repository

import (
	"rbac_manager/repository/application"
	"rbac_manager/repository/base"
	"rbac_manager/repository/module"
	"rbac_manager/repository/role"
	"rbac_manager/repository/user"
)

func Init() {
	base.Init()
	user.Init()
	role.Init()
	application.Init()
	module.Init()
}
