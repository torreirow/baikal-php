# baikal-php

Baïkal 0.10.1 (CalDAV/CardDAV server) with a patched PHP runtime: **PHP 8.3 ≥ 8.3.36**, which contains the fix for PHP2Shell
(CVE-2026-109618/109619, multipart `POST` parsing).

The upstream image runs PHP 8.1, which is end-of-life and does not get this fix; upstream does not publish an image with a patched PHP. This image replaces the PHP 8.1 packages (packages.sury.org) with PHP 8.3.

The application itself is taken unchanged from the pinned upstream image
(`ckulka/baikal:nginx`, digest in the `Dockerfile`); only the PHP runtime underneath is replaced. It is a
drop-in replacement: same ports, volumes, entrypoint and environment variables as upstream.
See [https://github.com/ckulka/baikal-docker](https://github.com/ckulka/baikal-docker) for usage.

## Image

```
ghcr.io/torreirow/baikal-phpatest
ghcr.io/torreirow/baikal-php:<upstream-version>
ghcr.io/torreirow/baikal-php:<upstream-version>-<commit>
```

Pin by digest in production.

## Build

```sh
docker build -t baikal-php .
```

The build fails if the installed PHP is older than `PHP_MIN` (build argument, default
`8.3.36`).

## CI

`.github/workflows/build.yml` builds the image, smoke-tests it (HTTP endpoints, PHP version
≥ `PHP_MIN`) and pushes to ghcr.io on `main`. A weekly scheduled run rebuilds without cache so
new PHP patch releases from the distribution packages end up in the image.

## Upgrading upstream

1. Update the `UPSTREAM` digest in the `Dockerfile` and the version in `UPSTREAM_VERSION`.
2. Push; CI builds, tests and publishes.

Retire this repository once upstream ships an image with PHP ≥ 8.3.36 (or another patched
branch).

## License

MIT for the files in this repository. Baïkal 0.10.1 (CalDAV/CardDAV server) itself is licensed by its authors; see upstream.
