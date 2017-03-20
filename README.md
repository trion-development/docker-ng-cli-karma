# docker-ng-cli-karma

Docker container to run Karma tests with Angular CLI inside Docker using Xvfb

Example usage
```
docker run -u $(id -u) --rm -v "$PWD":/app trion/ng-cli-karma ng new MyDemo
cd MyDemo
docker run -u $(id -u) --rm -v "$PWD":/app trion/ng-cli-karma ng serve -host 0.0.0.0
docker run -u $(id -u) --rm -v "$PWD":/app trion/ng-cli-karma ng build
```

Running karma unit tests in docker container
----
docker run -u $(id -u) --rm -v "$PWD":/app trion/ng-cli-karma ng test
----
