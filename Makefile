TEST_REPORT = "$(shell pwd)/gen/test_report.xml"
COVER_REPORT = "$(shell pwd)/gen/profile.cov"
REPO_NAME = "chimera-webservice-task"

all: fmt lint test build

test:
	mkdir -p gen
	if ! test -f ${GOPATH}/bin/go2xunit; then go get github.com/tebeka/go2xunit; fi
	go test -v ./... 2>&1 | ${GOPATH}/bin/go2xunit -output ${TEST_REPORT}

test_and_coverage:
	mkdir -p gen
	if ! test -f ${GOPATH}/bin/go2xunit; then go get github.com/tebeka/go2xunit; fi
	go test -v ./...  -covermode=count -coverprofile=${COVER_REPORT} | ${GOPATH}/bin/go2xunit -output ${TEST_REPORT}
	if ! test -f ${GOPATH}/bin/goveralls; then go get github.com/mattn/goveralls; fi
	${GOPATH}/bin/goveralls -repotoken ${COVERALLS_TOKEN} -service=travis-ci -coverprofile=${COVER_REPORT}

install:
	pip install -r requirements

build:
	CGO_ENABLED=0 go build -o ${REPO_NAME}

fmt:
	go fmt $$(go list ./... | grep -v /vendor/);

lint:
	if ! test -f ${GOPATH}/bin/golint; then go get golang.org/x/lint/golint; fi
	${GOPATH}/bin/golint .

build-local-docker:
	make install
	docker build . -t ${REPO_NAME}:local

docker-run:
	docker-compose -p ${REPO_NAME} up -d
