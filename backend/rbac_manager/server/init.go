package server

import (
	"rbac_manager/controller"
	"rbac_manager/infrastructure"
	"rbac_manager/repository"
	"rbac_manager/service"
)

func Init() {
	infrastructure.Init()
	repository.Init()
	service.Init()
	controller.Init()

}
