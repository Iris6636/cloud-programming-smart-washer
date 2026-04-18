#!/bin/bash
# Package all Lambda functions from backend/lambda_functions/ into deployment/lambda/
# Usage: bash deployment/scripts/package_lambdas.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SRC_DIR="$PROJECT_ROOT/backend/lambda_functions"
OUT_DIR="$PROJECT_ROOT/deployment/lambda"

mkdir -p "$OUT_DIR"

echo "Packaging Lambda functions..."
echo "Source: $SRC_DIR"
echo "Output: $OUT_DIR"
echo ""

count=0
for py_file in "$SRC_DIR"/*.py; do
  if [ ! -f "$py_file" ]; then
    continue
  fi

  basename=$(basename "$py_file" .py)
  zip_file="$OUT_DIR/${basename}.zip"

  # Package the .py file into a zip (Lambda expects the handler file at the root of the zip)
  (cd "$SRC_DIR" && zip -j -q "$zip_file" "${basename}.py")

  echo "  Packaged: ${basename}.zip"
  count=$((count + 1))
done

echo ""
echo "Done. $count Lambda functions packaged to $OUT_DIR"
