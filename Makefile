default: test

# Builds bosh-google-cpi for linux-amd64
build:
	go build -o out/cpi github.com/frodenas/bosh-google-cpi/main

# Build cross-platform binaries
build-all:
	gox -output="out/cpi_{{.OS}}_{{.Arch}}" github.com/frodenas/bosh-google-cpi/main

# Run gofmt on all code
fmt:
	gofmt -l -w .

# Run linter with non-stric checking
lint:
	@echo ls -d */ | grep -v vendor | xargs -L 1 golint
	ls -d */ | grep -v vendor | xargs -L 1 golint

# Vet code
vet:
	go tool vet $$(ls -d */ | grep -v vendor)

# Cleans up directory and source code with gofmt
clean:
	go clean ./...

# Prepration for tests
get-deps:
	# Go vet  and lint tools
	go get golang.org/x/tools/cmd/vet
	go get github.com/golang/lint/golint

	# Simplify cross-compiling
	go get github.com/mitchellh/gox

	# Ginkgo and omega test tools
	go get github.com/onsi/ginkgo/ginkgo 
	go get github.com/onsi/gomega

# Runs the unit tests with coverage
test: clean fmt vet build
	ginkgo -r -race .
