# quassel-core

Lightweight container image for [Quassel IRC core](https://quassel-irc.org/). Forked from the deprecated [linuxserver/quassel-core](https://github.com/linuxserver/docker-quassel-core) image and rebuilt as a minimal Alpine container with no embedded service manager.

Runs as **UID/GID 1000** for Kubernetes non-root workloads ([k8s-flux-2#355](https://github.com/rich0/k8s-flux-2/issues/355)).

## Image

- **Base:** Alpine 3.24
- **Quassel:** `quassel-core` distro package (0.14.0)
- **Process:** `quasselcore --configdir /config` via `entrypoint.sh`
- **User:** `quassel` (1000:1000)

## Usage

```bash
docker run -d \
  --name quassel-core \
  -p 4242:4242 \
  -v ./config:/config \
  ghcr.io/rich0/quassel-core:latest
```

Connect with a [Quassel desktop client](https://quassel-irc.org/downloads/) to port 4242.

On first start with an empty `/config` volume, the entrypoint generates a self-signed TLS certificate at `/config/quasselCert.pem`.

### Environment

| Variable | Default | Description |
|----------|---------|-------------|
| `QUASSEL_CONFIG_DIR` | `/config` | Quassel configuration directory |
| `RUN_OPTS` | _(empty)_ | Extra arguments passed to `quasselcore` (legacy linuxserver compat) |

### Ports

| Port | Description |
|------|-------------|
| 4242 | Quassel client protocol |
| 10113 | Ident (optional; enable via `RUN_OPTS`) |

## Kubernetes

Designed for non-root StatefulSet deployment. Existing root-owned PVC data must be `chown`ed to UID 1000 before cutover — see [k8s-flux-2#355](https://github.com/rich0/k8s-flux-2/issues/355).

## Build

```bash
./build-push.sh
```

Or manually:

```bash
docker build -t ghcr.io/rich0/quassel-core:latest .
```

## License

GPL-2.0-or-later (Quassel upstream). See [LICENSE](LICENSE).
