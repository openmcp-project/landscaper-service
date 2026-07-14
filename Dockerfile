# SPDX-FileCopyrightText: Copyright OpenControlPlane contributors.
#
# SPDX-License-Identifier: Apache-2.0

#### BASE ####
FROM gcr.io/distroless/static-debian12:nonroot@sha256:aef9602f8710ec12bde19d593fed1f76c708531bb7aba205110f1029786ead7b AS base

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
