package controller

import (
	"fmt"

	"github.com/gin-gonic/gin"
)

func HandleHello(c *gin.Context) {
	name := c.Query("name")

	if len(name) == 0 {
		name = "world"
	}
	greeting := fmt.Sprintf("hello %s", name)
	c.Writer.Write([]byte(greeting))
}
