# SPDX-FileCopyrightText: 2022 "SAP SE or an SAP affiliate company and Gardener contributors"
#
# SPDX-License-Identifier: Apache-2.0

FROM golang:1.26.3-alpine3.22@sha256:be93003ee861b3b91b6ebcb22678524947e0cd786c2df3f32af520006b1e54f5

RUN apk add --no-cache --no-progress \
    bash \
    git \
    curl \
    openssl openssl-dev \
    expect \
    gcc \
    build-base \
    cargo \
    python3 python3-dev py3-pip  \
    libc-dev \
    libffi-dev

RUN curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash && \
    ln -s "$(which helm)" /bin/helm3

RUN curl -LO https://dl.k8s.io/release/v1.25.14/bin/linux/amd64/kubectl && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

RUN pip3 install --upgrade pip --break-system-packages && \
    pip3 install gardener-cicd-libs --break-system-packages