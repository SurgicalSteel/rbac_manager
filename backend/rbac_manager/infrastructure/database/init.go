package database

import (
	"fmt"
	"log"
	"rbac_manager/config"

	"github.com/jmoiron/sqlx"
	_ "github.com/lib/pq"
)

// TODO move to config
var dbAccount = config.DBAccount{
	Username: "postgres",
	Password: "password",
	URL:      "127.0.0.1",
	DBName:   "postgres",
	Port:     "5432",
	Timeout:  "10",
}

var (
	dbRead  *sqlx.DB
	dbWrite *sqlx.DB
)

func Init() {
	dbWrite, err := sqlx.Open("postgres", generatePostgreURL(dbAccount))
	if err != nil {
		log.Fatalf("Failed to open connection to DB Write! Error : %s\n", err.Error())
	}
	dbRead = dbWrite

	err = dbWrite.Ping()
	if err != nil {
		log.Fatalf("Failed to ping to DB Write! Error : %s\n", err.Error())
	}

}

func BeginTx() (*sqlx.Tx, error) {
	tx, err := dbWrite.Beginx()
	if err != nil {
		return nil, err
	}

	return tx, nil
}

func CloseConnection() error {
	if dbWrite != nil {
		return dbWrite.Close()
	}
	return nil
}

func GetDbRead() *sqlx.DB {
	return dbRead
}

func GetDbWrite() *sqlx.DB {
	return dbWrite
}

func generatePostgreURL(dbAcc config.DBAccount) string {
	return fmt.Sprintf("user=%s password=%s dbname=%s host=%s port=%s  sslmode=disable extra_float_digits=-1 connect_timeout=%s", dbAcc.Username, dbAcc.Password, dbAcc.DBName, dbAcc.URL, dbAcc.Port, dbAcc.Timeout)
}
