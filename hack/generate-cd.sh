#!/bin/bash
#
# SPDX-FileCopyrightText: Copyright OpenControlPlane contributors.
#
# SPDX-License-Identifier: Apache-2.0

# Builds, signs and publishes the component versions of the landscaper-service.
#
# Environment:
#   OCM              OCM CLI binary
#   OVERWRITE_COMPONENTS  "true" replaces an existing component version

set -euo pipefail

die() { echo "$@" >&2; exit 1; }

if [[ -z ${1:-} ]]; then
  die "provider argument is required"
fi

PROJECT_ROOT="$(realpath "$(dirname "$0")/..")"
OCM_CONFIG="$PROJECT_ROOT/.landscaper/ocm-config.yaml"
TARGET="$1"
COMPONENTS=(
  github.com/openmcp-project/landscaper-service
  github.com/openmcp-project/landscaper-service/landscaper-instance
  github.com/openmcp-project/landscaper-service/ingress-controller
)

export VERSION="$("$PROJECT_ROOT/hack/get-version.sh")"

# ocm replaces existing versions and has no flag to prevent it.
for component in "${COMPONENTS[@]}"; do
  target="$TARGET//$component:$VERSION"
  if output="$("$OCM" get cv "$target" 2>&1)"; then
    [[ "${OVERWRITE_COMPONENTS:-false}" == "true" ]] || die "$target already exists. Set OVERWRITE_COMPONENTS to 'true' to overwrite it."
  elif [[ "$output" != *"not found"* ]]; then
    echo "$output" >&2
    die "Cannot check whether $target exists."
  fi
done

echo "> Create Component Version"
export COMMIT_SHA="$(git -C "$PROJECT_ROOT" rev-parse HEAD)"
export PROVIDER="${PROVIDER:-$TARGET}"
export IMAGE_REGISTRY="${IMAGE_REGISTRY:-ghcr.io/openmcp-project/images}"
export LANDSCAPER_SERVICE_CHART_PATH=./charts/landscaper-service
export SHOOT_SIDECAR_CHART_PATH=./charts/landscaper-service-target-shoot-sidecar-server
export SHOOT_SIDECAR_RBAC_CHART_PATH=./charts/sidecar-rbac

echo -n "> Updating helm chart version"
"$PROJECT_ROOT/hack/update-helm-chart-version.sh" "$VERSION"

# Versions are read from ocm-settings.yaml, the same file the integration tests read.
while IFS='=' read -r key value; do
  export "$key=$value"
done < <(sed -nE 's/^([A-Z0-9_]+): (.*)$/\1=\2/p' "$PROJECT_ROOT/.landscaper/ocm-settings.yaml")

COMPONENT_ARCHIVE_PATH="$(mktemp -d)/ctf"

"$OCM" add cv --config "$OCM_CONFIG" \
  --constructor "$PROJECT_ROOT/.landscaper/components.yaml" \
  --working-directory "$PROJECT_ROOT" \
  --repository "ctf::$COMPONENT_ARCHIVE_PATH"

for component in "${COMPONENTS[@]}"; do
  "$OCM" sign cv --config "$OCM_CONFIG" "ctf::$COMPONENT_ARCHIVE_PATH//$component:$VERSION"
done

echo "> Transfer Component version ${VERSION} to ${TARGET}"
for component in "${COMPONENTS[@]}"; do
  "$OCM" transfer cv --config "$OCM_CONFIG" "ctf::$COMPONENT_ARCHIVE_PATH//$component:$VERSION" "$TARGET"
done

echo "> Remote Component Version Landscaper Service"
"$OCM" get cv "$TARGET//${COMPONENTS[0]}:$VERSION" -o yaml
