# docker-ng-cli-karma

Docker container to run Karma tests with Angular CLI inside Docker using Xvfb

This image is sponsored and maintained by https://www.trion.de/ - trion offers commercial training and consulting for all things Docker and Angular.

## Example usage
```
docker run -u $(id -u) --rm -v "$PWD":/app trion/ng-cli-karma ng new MyDemo
cd MyDemo
docker run -u $(id -u) --rm -v "$PWD":/app trion/ng-cli-karma ng serve --host 0.0.0.0
docker run -u $(id -u) --rm -v "$PWD":/app trion/ng-cli-karma ng serve --host :: #ipv6
docker run -u $(id -u) --rm -v "$PWD":/app trion/ng-cli-karma ng build
```

If you want to clone additional git repositories, f.e. from package.json, and you run with a different user than uid 1000 you need to mount the passwd since git requires to resolve the uid.

```
docker run -u $(id -u) --rm -p 4200:4200 -v /etc/passwd:/etc/passwd -v "$PWD":/app trion/ng-cli npm install
```


## Running karma unit tests in docker container
```
docker run -u $(id -u) --rm -v "$PWD":/app trion/ng-cli-karma ng test
```

## Running karma unit tests in docker container, exiting after test run
```
docker run -u $(id -u) --rm -v "$PWD":/app trion/ng-cli-karma ng test --watch false
```

## Using WebGL
WebGL is supported using Mesa software rendering. Since this is much slower it is not enabled by default.

In order to use the WebGL configuration, you need to use `xvfb-chromium-webgl` instead of using the regular chromium wrapper, called as `chrome` or `chromium`.

That wrapper has the additional switches `--enable-webgl --ignore-gpu-blacklist` enabled, which are required for software WebGL rendering.

This can be configured in the karma configuration, f.e.

```
browsers: ['/usr/bin/xvfb-chromium-webgl'],
```

or you can specify the chrome excutable using the `CHROME_BIN` environment variable like

```
docker run -e CHROME_BIN=/usr/bin/xvfb-chromium-webgl -u $(id -u) --rm -v "$PWD":/app trion/ng-cli-karma ng test
```

## Interactive debugging
Instead of running on the hidden Xvfb, you can also run the provided Chrome on a real display.
To do so you need to export the display, bind the /tmp sockets, and select the provided `display-chromium`
startup wrapper via the `CHROME_BIN` environment variable:

```
docker run -e DISPLAY=:0 -e CHROME_BIN=/usr/bin/display-chromium -u $(id -u) --rm -v /tmp:/tmp -v "$PWD":/app trion/ng-cli-karma ng test
```

If you forget to expose the /tmp/.X* socket you'll get an error message like:
```
ERROR:nacl_helper_linux.cc(310)] NaCl helper process running without a sandbox!
```

## What about *-headless browsers
Mozilla Firefox and Google Chrome are in the process to provide headless browsers capable of executing integration tests.

Currently WebGL needs the mesa software renderer for Chrome, but it will change to the swift renderer, see https://bugs.chromium.org/p/chromium/issues/detail?id=617551

Mozilla is still working on headless support in Firefox: https://bugzilla.mozilla.org/show_bug.cgi?id=1338004

## What if tests are not running (reliably)
Run the tests in interactive debugging mode (see above) and check the browser console.

If there are errors like `Failed to load resource: net::ERR_INSUFFICIENT_RESOURCES` or `An error was thrown in afterAll Error: Can't find ./some-file.ts] (required by other-file.ts) at require` it may be that the browser is running out of shared memory. Try to either increase the shared memory with the docker parameter `--shm-size 1G` or disable shared memory usage by specifying the flag `--disable-dev-shm-usage` for Chromium/Chrome.

