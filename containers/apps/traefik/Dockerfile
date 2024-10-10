FROM traefik:v3.1.6@sha256:f703a2ac2ddf75f6e06c9cccac7f158765e2ab42d642b04e79e2e3d7355c2ddc
# Above line used by CI to find tags etc

FROM alpine:3.20.3@sha256:beefdbd8a1da6d2915566fde36db9db0b524eb737fc57cd1367effd16dc0d06d as plugins

# FIXME: Find a way to keep versions up to date
# -- Use the following prefixes to specify plugins to clone
# - TC_PLUGIN_REPO_* for the repo/package name
# - TC_PLUGIN_VERSION_* for the version

# Theme Park
ARG TC_PLUGIN_REPO_THEME_PARK=github.com/packruler/traefik-themepark
ARG TC_PLUGIN_VERSION_THEME_PARK_VERSION=v1.4.0
# GeoBlock
ARG TC_PLUGIN_REPO_GEOBLOCK=github.com/PascalMinder/geoblock
ARG TC_PLUGIN_VERSION_GEOBLOCK_VERSION=v0.2.8
# RealIP
ARG TC_PLUGIN_REPO_REALIP=github.com/jramsgz/traefik-real-ip
ARG TC_PLUGIN_VERSION_REALIP_VERSION=v1.0.6
# Modsecurity
ARG TC_PLUGIN_REPO_MODSECURITY=github.com/acouvreur/traefik-modsecurity-plugin
ARG TC_PLUGIN_VERSION_MODSECURITY_VERSION=v1.3.0
# Crowdsec
ARG TC_PLUGIN_REPO_CROWDSEC_BOUNCER=github.com/maxlerebourg/crowdsec-bouncer-traefik-plugin
ARG TC_PLUGIN_VERSION_CROWDSEC_BOUNCER_VERSION=v1.3.0
# RewriteResponseHeaders
ARG TC_PLUGIN_REPO_REWRITERESPONSEHEADERS=github.com/XciD/traefik-plugin-rewrite-headers
ARG TC_PLUGIN_VERSION_REWRITERESPONSEHEADERS_VERSION=v0.0.4

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

# hadolint ignore=DL3018
RUN apk add --no-cache --update git

COPY --chmod=777 ./apps/traefik/clone-plugins.sh /clone-plugins.sh
RUN /clone-plugins.sh

FROM traefik:v3.1.6@sha256:f703a2ac2ddf75f6e06c9cccac7f158765e2ab42d642b04e79e2e3d7355c2ddc
# Copy the plugins from the previous stage
COPY --from=plugins /plugins-local /plugins-local

LABEL "org.opencontainers.image.source"="https://github.com/truecharts/containers"

ARG CONTAINER_NAME
ARG CONTAINER_VER
LABEL org.opencontainers.image.title="${CONTAINER_NAME}"
LABEL org.opencontainers.image.url="https://truecharts.org/docs/charts/${CONTAINER_NAME}"
LABEL org.opencontainers.image.version="${CONTAINER_VER}"
LABEL org.opencontainers.image.description="Container for ${CONTAINER_NAME} by TrueCharts"
LABEL org.opencontainers.image.authors="TrueCharts"
LABEL org.opencontainers.image.documentation="https://truecharts.org/docs/charts/${CONTAINER_NAME}"
