# Contributing

1. Get the package:
   `go get -d github.com/bptlab/chimera-webservice-mock`
1. Change into the checked out source:

   `cd $(go env GOPATH)/src/github.com/bptlab/chimera-webservice-mock`
1. Make changes, commit to your branch.
1. Send a pull request with your changes.

# Styleguides and Best Practices
* [Golang Style](https://blog.golang.org/go-fmt-your-code)
* [Changelog](https://keepachangelog.com/en/1.0.0/)
* [Github Workflow](https://guides.github.com/introduction/flow/)
* Feature, Hotfix, Master, Develop and Tag branches

# Testing
```
make test
```

# Local Docker
## Building
```
make build-local-docker
```

## Running
```
make docker-run
```
