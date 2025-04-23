package user

import (
	"context"
	"database/sql"
	"rbac_manager/infrastructure/database"
)

type FnGetQuoteById func(ctx context.Context, id int64) (SongQuote, error)

func GetQuoteById(ctx context.Context, id int64) (SongQuote, error) {
	var result SongQuote

	dbRead := database.GetDbRead()
	err := dbRead.Get(&result, "SELECT id, quote_text, song_title, band_name FROM song_quotes WHERE id = $1", id)
	if err != nil {
		if err != sql.ErrNoRows {
			return result, err
		}
	}
	return result, nil
}
