package user

type SongQuote struct {
	Id        int64  `json:"id" db:"id"`
	QuoteText string `json:"quoteText" db:"quote_text"`
	SongTitle string `json:"songTitle" db:"song_title"`
	BandName  string `json:"bandName" db:"band_name"`
}
