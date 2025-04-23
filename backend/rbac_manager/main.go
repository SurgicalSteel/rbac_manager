package main

import (
	"context"
	"log"
	"net/http"
	"os"
	"os/signal"
	"rbac_manager/infrastructure/database"
	"rbac_manager/server"
	"syscall"
	"time"
)

var (
	timeWaiting = (5 * time.Second)
)

func main() {
	server.Init()
	httpServer := server.BuildHttpServer()
	runApp(httpServer, "RBAC Manager Back End")
}

func runApp(httpServer *http.Server, serverName string) {
	done := make(chan os.Signal, 1)
	signal.Notify(done, os.Interrupt, syscall.SIGINT, syscall.SIGTERM)

	go func() {
		if err := httpServer.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			log.Fatalf("[ERROR][httpServer] ListenAndServe: %s\n", err)
		}
	}()

	<-done
	log.Printf("Stopping %s\n", serverName)
	ctx, cancel := context.WithTimeout(context.Background(), timeWaiting)
	defer func() {
		err := database.CloseConnection()
		if err != nil {
			log.Fatalf("Failed to stop http service %s %+v\n", serverName, err)
		}
		cancel()
	}()

	if err := httpServer.Shutdown(ctx); err != nil {
		log.Fatalf("Failed to stop http service %s %+v\n", serverName, err)
	}

	log.Printf("%s stopped successfully\n", serverName)
}
