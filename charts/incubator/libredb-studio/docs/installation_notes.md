---
title: Installation Notes
---

## First start

On first start the application writes an administrator account and prints the password
once. Read it back with:

```bash
kubectl logs -n <namespace> deploy/<release-name> | grep -i "admin"
```

The same credentials are stored at `/app/data/auth-bootstrap.json` inside the persistent
volume. Set `ADMIN_PASSWORD` yourself to choose the password instead.

## Single replica

Storage runs on SQLite, which takes a single writer, so this chart is meant for one
replica. Raising the replica count corrupts sessions and saved connections.

## Cookies over plain http

Auth cookies carry the `Secure` flag in production, and a browser rejects a `Secure`
cookie that arrives over plain http on a host that is not loopback, so the login form
posts, succeeds and comes straight back. The chart sets `AUTH_COOKIE_SECURE` to `false`
because most installs here are reached over plain http on a LAN address. Set it to
`true` when TLS terminates at an ingress or a load balancer.
