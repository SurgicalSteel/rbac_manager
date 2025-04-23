package service

import (
	"rbac_manager/service/application"
	"rbac_manager/service/module"
	"rbac_manager/service/role"
	"rbac_manager/service/user"
)

func Init() {
	application.Init()
	module.Init()
	role.Init()
	user.Init()
}
