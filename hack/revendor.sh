#!/bin/bash

# SPDX-FileCopyrightText: Copyright OpenControlPlane contributors.
#
# SPDX-License-Identifier: Apache-2.0

set -euo pipefail

PROJECT_ROOT="$(realpath $(dirname $0)/..)"

function revendor() {
  go mod tidy
}

echo "Revendor integration-test module ..."
(
  cd "$PROJECT_ROOT/integration-test"
  revendor
)

echo "Revendor root module ..."
(
  cd "$PROJECT_ROOT"
  revendor
)
