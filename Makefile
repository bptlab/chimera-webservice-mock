REPO_NAME = "chimera-webservice-task"

all: lint test

test:
	echo "No tests."

install:
	pip install -r requirements

lint:
	echo "No linting configured."

build-local-docker:
	make install
	docker build . -t ${REPO_NAME}:local

docker-run:
	docker-compose -p ${REPO_NAME} up -d

