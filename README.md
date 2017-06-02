# docker-ng-cli-karma

Docker container to run Karma tests with Angular CLI inside Docker using Xvfb

## Example usage
```
docker run -u $(id -u) --rm -v "$PWD":/app trion/ng-cli-karma ng new MyDemo
cd MyDemo
docker run -u $(id -u) --rm -v "$PWD":/app trion/ng-cli-karma ng serve -host 0.0.0.0
docker run -u $(id -u) --rm -v "$PWD":/app trion/ng-cli-karma ng build
```

## Running karma unit tests in docker container
```
docker run -u $(id -u) --rm -v "$PWD":/app trion/ng-cli-karma ng test
```

## Using WebGL
WebGL is supported using Mesa software rendering. Since this is much slower it is not enabled by default.

In order to use the WebGL configuration, you need to use `xvfb-chromium-webgl` instead of using the regular chromium wrapper, called as `chrome` or `chromium`.

That wrapper has the additional switches `--use-gl=osmesa  --enable-webgl --ignore-gpu-blacklist` enabled, which are required for software WebGL rendering.
