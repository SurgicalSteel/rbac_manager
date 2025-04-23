package utils

import (
	"strconv"
	"strings"
)

func ParseInt64(s string) int64 {
	if strings.TrimSpace(s) == "" {
		return 0
	}

	value, err := strconv.ParseInt(s, 10, 64)
	if err != nil {
		return 0
	}

	return value
}
