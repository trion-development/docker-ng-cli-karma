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
docker run -e CHROME_BIN=/usr/bin/xvfb-chromium-webgl -u $(id -u) --rm -v "$PWD":/app trion/ng-cli-karma ng test --watch false
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

## What about X-headless browsers
Google Chrome and Mozilla Firefox both provide headless modes, and Karma has launchers for them (`ChromeHeadless`, `FirefoxHeadless`).

With this image you do not depend on the headless mode:
The image provides Chrome (Chromium on arm64) wrapped in Xvfb, so the regular Chrome launcher runs without a display and no extra Karma configuration is required.
Firefox is not part of the image.

If you prefer `ChromeHeadless`, it can be used with the Chrome in this image.
Note that the `google-chrome` binary is the Xvfb wrapper, and Karma's headless launcher typically needs the `--no-sandbox` flag when running in a container as a non-root user.
Some versions of `karma-chrome-launcher` have been reported to hang after the test run with `ChromeHeadless`, see https://github.com/karma-runner/karma-chrome-launcher/issues/154.

WebGL still relies on Mesa software rendering, see [Using WebGL](#using-webgl).


## What if tests are not running (reliably)
Run the tests in interactive debugging mode (see above) and check the browser console.

If there are errors like `Failed to load resource: net::ERR_INSUFFICIENT_RESOURCES` or `An error was thrown in afterAll Error: Can't find ./some-file.ts] (required by other-file.ts) at require` it may be that the browser is running out of shared memory. Try to either increase the shared memory with the docker parameter `--shm-size 1G` or disable shared memory usage by specifying the flag `--disable-dev-shm-usage` for Chromium/Chrome.

