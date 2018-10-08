package main

import (
	"fmt"
	"math/rand"
	"time"
	"bytes"
	"log"
	"os"
	"strconv"
)


func main() {
	var buffer bytes.Buffer
	var duplicate_map map[string]bool
	var dup_found bool
	var err error
	
	limit := 100
	slen := 4
	rnd := rand.New(rand.NewSource(time.Now().UnixNano()))
	duplicate_map = make(map[string]bool)
	logger := log.New(os.Stderr, "", 0)

	cargs := os.Args
	if len(cargs) == 3 {
		limit, err = strconv.Atoi(cargs[1])
		if err != nil {
			logger.Println("Bad argument 1")
			limit = 100
		}

		slen, err = strconv.Atoi(cargs[2])
		if err != nil {
			logger.Println("Bad argument 2")
			slen = 7
		}
	}
	
	for i := 0; i < limit; i++ {
		buffer.Reset()
		dup_found = true
		for dup_found == true {
			for j := 0; j < slen; j++ {
				ri := rnd.Int31n(9) + 1
				buffer.WriteString(fmt.Sprint(ri))
			}
			
			if rs := buffer.String(); duplicate_map[rs] {
				logger.Println("DUP: ", rs)
				buffer.Reset()
			} else {
				duplicate_map[rs] = true
				dup_found = false
				fmt.Println(rs)
			}
		}
	}
}
