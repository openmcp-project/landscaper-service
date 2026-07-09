# SPDX-FileCopyrightText: Copyright OpenControlPlane contributors.
#
# SPDX-License-Identifier: Apache-2.0

#### BASE ####
FROM gcr.io/distroless/static-debian12:nonroot@sha256:b7bb25d9f7c31d2bdd1982feb4dafcaf137703c7075dbe2febb41c24212b946f AS base

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
