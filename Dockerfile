# SPDX-FileCopyrightText: Copyright OpenControlPlane contributors.
#
# SPDX-License-Identifier: Apache-2.0

#### BASE ####
FROM gcr.io/distroless/static-debian12:nonroot@sha256:1b7b9f0f0e0a1d2155f531db587cc48ec26aaf97ab64364225f5bf18a054e66a AS base

#### Landscaper Service controller ####
FROM base AS landscaper-service-controller

ARG TARGETOS
ARG TARGETARCH
WORKDIR /
COPY bin/landscaper-service-controller.$TARGETOS-$TARGETARCH /landscaper-service-controller
USER 65532:65532

WORKDIR /

ENTRYPOINT ["/landscaper-service-controller"]

#### Landscaper Service webhooks server ####
FROM base AS landscaper-service-webhooks-server

ARG TARGETOS
ARG TARGETARCH
WORKDIR /
COPY bin/landscaper-service-webhooks-server.$TARGETOS-$TARGETARCH /landscaper-service-webhooks-server
USER 65532:65532

WORKDIR /

ENTRYPOINT ["/landscaper-service-webhooks-server"]

#### Landscaper Target-shoot Sidecar server ####
FROM base AS landscaper-service-target-shoot-sidecar-server

ARG TARGETOS
ARG TARGETARCH
WORKDIR /
COPY bin/landscaper-service-target-shoot-sidecar-server.$TARGETOS-$TARGETARCH /landscaper-service-target-shoot-sidecar-server
USER 65532:65532

WORKDIR /

ENTRYPOINT ["/landscaper-service-target-shoot-sidecar-server"]
