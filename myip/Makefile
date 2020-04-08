.PHONY: build lint clean test

build: lint test myip

myip: main.go
	@echo '==> Building $@'
	go build -o "$@" $<

lint: main.go
	@echo '==> Linting'
	go fmt
	go vet
	golint
	staticcheck

# test:
# 	@echo '==> Testing'
# 	go test -v

clean:
	@echo '==> Cleaning'
	rm -rf -- myip
