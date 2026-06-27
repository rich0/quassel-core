# quassel-core

Container image for the [Quassel IRC core](https://quassel-irc.org/) daemon (`quasselcore`).

Quassel is a distributed IRC client: this image runs only the **core** — the always-on server that maintains IRC connections. You connect with a separate [Quassel desktop client](https://quassel-irc.org/downloads/); no GUI or client components are included in the image.

## What is in the image

| Included | Not included |
|----------|--------------|
| `quasselcore` daemon (Alpine `quassel-core` package) | Quassel desktop/Qt client |
| Headless Qt/SQLite/PostgreSQL runtime libraries | s6, openrc, or other process managers |
| `openssl` (cert bootstrap only) | PUID/PGID mapping machinery |

The image is intentionally minimal: Alpine 3.24, the distro `quassel-core` package (0.14.0), a small entrypoint script, and nothing else.

## How it works

1. Container starts as user `quassel` (UID/GID **1000**).
2. `entrypoint.sh` checks for `/config/quasselCert.pem`. If absent, it generates a self-signed TLS certificate.
3. `quasselcore --configdir /config` is exec'd as PID 1.
4. State (SQLite database, config, certs) lives on the `/config` volume.

On first connection, use the Quassel desktop client to create an admin account and choose a storage backend (SQLite is typical for single-user setups).

## Usage

```bash
docker run -d \
  --name quassel-core \
  -p 4242:4242 \
  -v ./config:/config \
  ghcr.io/rich0/quassel-core:latest
```

Ensure the host directory (or PVC) is writable by UID 1000:

```bash
mkdir -p ./config
chown 1000:1000 ./config
```

### Environment variables

| Variable | Default | Description |
|----------|---------|-------------|
| `QUASSEL_CONFIG_DIR` | `/config` | Directory passed to `quasselcore --configdir` |
| `RUN_OPTS` | _(empty)_ | Additional arguments appended to the `quasselcore` command |

`RUN_OPTS` supports extra daemon flags, for example:

```bash
docker run -d \
  --name quassel-core \
  -e RUN_OPTS="--ident-daemon --ident-port 10113" \
  -p 4242:4242 \
  -p 10113:10113 \
  -v ./config:/config \
  ghcr.io/rich0/quassel-core:latest
```

### Ports

| Port | Description |
|------|-------------|
| 4242 | Quassel client protocol (primary) |
| 10113 | Ident protocol (optional; not started unless configured via `RUN_OPTS`) |

### Volumes

| Path | Description |
|------|-------------|
| `/config` | SQLite database, `quasselcore.conf`, TLS certificate, and all persistent state |

## Kubernetes

Built for non-root deployment (`runAsUser`/`fsGroup` 1000). When migrating from a prior root-owned deployment, existing PVC data must be ownership-corrected before cutover. See [k8s-flux-2#355](https://github.com/rich0/k8s-flux-2/issues/355).

## Build and publish

```bash
./build-push.sh
```

Or build locally:

```bash
docker build -t ghcr.io/rich0/quassel-core:latest .
```

Published tags: `ghcr.io/rich0/quassel-core:0.15.0`, `:latest`.

## License

Quassel is licensed under GPL-2.0-or-later. See [LICENSE](LICENSE).

## Acknowledgements

This image was originally derived from [linuxserver/docker-quassel-core](https://github.com/linuxserver/docker-quassel-core). The current image is an independent rebuild and is not affiliated with or supported by LinuxServer.io.
