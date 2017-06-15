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

That wrapper has the additional switches `--enable-webgl --ignore-gpu-blacklist` enabled, which are required for software WebGL rendering.

Example karma config:

```
browsers: ['/usr/bin/xvfb-chromium-webgl'],
```

## What about *-headless browsers
Mozilla Firefox and Google Chrome are in the process to provide headless browsers capable of executing integration tests.

Currently WebGL needs the mesa software renderer for Chrome, but it will change to the swift renderer, see https://bugs.chromium.org/p/chromium/issues/detail?id=617551

Mozilla is still working on headless support in Firefox: https://bugzilla.mozilla.org/show_bug.cgi?id=1338004
