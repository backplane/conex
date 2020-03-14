package main

import (
	"bytes"
	"flag"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"net/http"
	"os"

	"github.com/google/go-github/github"
)

// command-line option init & defaults
var secretPath = `/run/secrets/webhook_secret`
var fifoPath = `/out`
var listenAddr = `0.0.0.0:8000`
var secret []byte

// constants
const helpText = `usage: %s

HTTP endpoint receives and validates webhooks, writes message to fifo

`

func handleWebhook(w http.ResponseWriter, r *http.Request) {
	defer r.Body.Close()

	// Accepting HTTP POSTs only
	if r.Method != http.MethodPost {
		log.Printf("invalid request method! method=%s\n", r.Method)
		w.WriteHeader(http.StatusBadRequest)
		io.WriteString(w, "Invalid method\n")
		return
	}

	// path := strings.TrimPrefix(r.URL.EscapedPath(), "/")
	payload, err := github.ValidatePayload(r, secret)
	if err != nil {
		log.Printf("error validating request body! err=%s\n", err)
		w.WriteHeader(http.StatusBadRequest)
		io.WriteString(w, "Validation failed\n")
		return
	}

	err = ioutil.WriteFile(fifoPath, payload, 0600)
	if err != nil {
		log.Printf("error writing output! err=%s\n", err)
		w.WriteHeader(http.StatusBadRequest)
		io.WriteString(w, "Post-validation action failed\n")
		return
	}

	fmt.Fprintf(w, "OK")
}

func loadSecret(secretPath string) []byte {
	rawSecret, err := ioutil.ReadFile(secretPath)
	if err != nil {
		log.Fatalf("couldn't read the secret file: \"%s\", error: %v\n", secretPath, err)
	}

	return bytes.TrimSpace(rawSecret)
}

func init() {
	flag.Usage = func() {
		fmt.Fprintf(os.Stderr, helpText, os.Args[0])
		flag.PrintDefaults()
	}
	flag.StringVar(&listenAddr, "listen", listenAddr,
		"local address and port to listen on")
	flag.StringVar(&secretPath, "secretPath", secretPath,
		"path to the webhook validation secret")
	flag.StringVar(&fifoPath, "fifoPath", fifoPath,
		"path to the output fifo")
	flag.Parse()
}

func main() {
	// load the secret
	secret = loadSecret(secretPath)

	// setup webhook listener
	http.HandleFunc("/webhook", handleWebhook)

	// Serve forever
	log.Printf("Starting listener on %s.\n", listenAddr)
	err := http.ListenAndServe(listenAddr, nil)
	log.Fatal(err)
}
