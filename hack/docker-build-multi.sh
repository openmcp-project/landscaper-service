#!/bin/bash
#
# SPDX-FileCopyrightText: Copyright OpenControlPlane contributors.
#
# SPDX-License-Identifier: Apache-2.0

set -euo pipefail

# Call with PUSH_IMAGES=true to push one multi-platform image per controller and sign it with cosign

PROJECT_ROOT="$(realpath $(dirname $0)/..)"
if [[ -z ${EFFECTIVE_VERSION:-} ]]; then
  EFFECTIVE_VERSION=$("$PROJECT_ROOT/hack/get-version.sh")
fi

DOCKER_BUILDER_NAME="laas-multiarch-builder"
if ! docker buildx ls | grep "$DOCKER_BUILDER_NAME" >/dev/null; then
	docker buildx create --name "$DOCKER_BUILDER_NAME"
fi

if [[ "${PUSH_IMAGES:-false}" == "true" ]]; then
  # Local builds must not push or sign, so this is opt-in.
  for img in landscaper-service-controller landscaper-service-webhooks-server landscaper-service-target-shoot-sidecar-server; do
    ref="${IMAGE_REGISTRY:-ghcr.io/openmcp-project/images}/${img}:${EFFECTIVE_VERSION}"
    if [[ "${OVERWRITE_COMPONENTS:-false}" != "true" ]] && docker buildx imagetools inspect "$ref" >/dev/null 2>&1; then
      echo "$ref already exists. Set OVERWRITE_COMPONENTS to 'true' to overwrite it." >&2
      exit 1
    fi
    docker buildx build --builder ${DOCKER_BUILDER_NAME} --push --build-arg EFFECTIVE_VERSION=${EFFECTIVE_VERSION} --platform ${PLATFORMS} -t "$ref" -f Dockerfile --target ${img} "${PROJECT_ROOT}"
    digest=$(docker buildx imagetools inspect "$ref" --format '{{.Manifest.Digest}}')
    cosign sign --yes "${ref%:*}@${digest}"
  done
  docker buildx rm "$DOCKER_BUILDER_NAME"
  exit 0
fi

for pf in ${PLATFORMS//,/ }; do
  echo "> Building docker images for $pf in version $EFFECTIVE_VERSION ..."
	os=${pf%/*}
	arch=${pf#*/}
	docker buildx build --builder ${DOCKER_BUILDER_NAME} --load --build-arg EFFECTIVE_VERSION=${EFFECTIVE_VERSION} --platform ${pf} -t landscaper-service-controller:${EFFECTIVE_VERSION}.${os}-${arch} -f Dockerfile --target landscaper-service-controller "${PROJECT_ROOT}"
	docker buildx build --builder ${DOCKER_BUILDER_NAME} --load --build-arg EFFECTIVE_VERSION=${EFFECTIVE_VERSION} --platform ${pf} -t landscaper-service-webhooks-server:${EFFECTIVE_VERSION}.${os}-${arch} -f Dockerfile --target landscaper-service-webhooks-server "${PROJECT_ROOT}"
	docker buildx build --builder ${DOCKER_BUILDER_NAME} --load --build-arg EFFECTIVE_VERSION=${EFFECTIVE_VERSION} --platform ${pf} -t landscaper-service-target-shoot-sidecar-server:${EFFECTIVE_VERSION}.${os}-${arch} -f Dockerfile --target landscaper-service-target-shoot-sidecar-server "${PROJECT_ROOT}"
done

docker buildx rm "$DOCKER_BUILDER_NAME"