#!/bin/bash
# Deploy frontend with Terraform output values injected into compiled JS.
#
# This script reads Terraform outputs (Cognito Client ID, API Gateway URLs),
# dynamically detects the current values in the compiled frontend JS,
# replaces them with new values, and uploads to S3.
#
# Usage:
#   bash deployment/scripts/deploy_frontend.sh
#
# Prerequisites:
#   - Terraform has been applied (terraform apply)
#   - AWS CLI configured with proper credentials
#
# Windows users: Run this script in Git Bash or WSL.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
INFRA_DIR="$PROJECT_ROOT/deployment/infra"
FRONTEND_DIR="$PROJECT_ROOT/web/frontend"

echo "=== Frontend Deployment Script ==="
echo ""

# --- Get Terraform outputs ---
echo "[1/5] Reading Terraform outputs..."
cd "$INFRA_DIR"

NEW_COGNITO_CLIENT_ID=$(terraform output -raw cognito_client_id 2>/dev/null) || {
  echo "ERROR: Failed to read cognito_client_id from terraform output."
  echo "       Have you run 'terraform apply' in $INFRA_DIR?"
  exit 1
}

NEW_IOT_API_URL=$(terraform output -raw api_gateway_invoke_url 2>/dev/null) || {
  echo "ERROR: Failed to read api_gateway_invoke_url from terraform output."
  exit 1
}

NEW_EXPRESS_API_URL=$(terraform output -raw express_api_invoke_url 2>/dev/null) || {
  echo "ERROR: Failed to read express_api_invoke_url from terraform output."
  exit 1
}

S3_BUCKET_WEBSITE=$(terraform output -raw s3_website_endpoint 2>/dev/null) || {
  echo "ERROR: Failed to read s3_website_endpoint from terraform output."
  exit 1
}

# --- Validate terraform outputs are non-empty ---
if [ -z "$NEW_COGNITO_CLIENT_ID" ]; then
  echo "ERROR: cognito_client_id is empty. Check your Terraform state."
  exit 1
fi
if [ -z "$NEW_IOT_API_URL" ]; then
  echo "ERROR: api_gateway_invoke_url is empty. Check your Terraform state."
  exit 1
fi
if [ -z "$NEW_EXPRESS_API_URL" ]; then
  echo "ERROR: express_api_invoke_url is empty. Check your Terraform state."
  exit 1
fi

# Strip trailing slash from API URLs for consistent matching
NEW_IOT_API_URL="${NEW_IOT_API_URL%/}"
NEW_EXPRESS_API_URL="${NEW_EXPRESS_API_URL%/}"

# Extract the S3 bucket name from the website endpoint URL
# e.g., http://team06website-temp.s3-website-us-east-1.amazonaws.com -> team06website-temp
S3_BUCKET_NAME=$(echo "$S3_BUCKET_WEBSITE" | sed 's|http://||' | sed 's|\.s3-website.*||')

echo "  New Cognito Client ID : $NEW_COGNITO_CLIENT_ID"
echo "  New IOT API URL       : $NEW_IOT_API_URL"
echo "  New Express API URL   : $NEW_EXPRESS_API_URL"
echo "  S3 Bucket             : $S3_BUCKET_NAME"
echo ""

# --- Find the JS bundle file ---
JS_FILE=$(ls "$FRONTEND_DIR"/assets/index-*.js 2>/dev/null | head -1)
if [ -z "$JS_FILE" ]; then
  echo "ERROR: No index-*.js file found in $FRONTEND_DIR/assets/"
  exit 1
fi

# --- Detect current values in JS (dynamic, not hardcoded) ---
echo "[2/5] Detecting current values in $JS_FILE ..."

# Extract current Cognito Client ID:
#   Pattern: after region:"<any-aws-region>"} ... ="CLIENT_ID"
#   The Cognito config has region:"us-east-1" (or other region), followed by minified code,
#   then a variable assignment like wy="CLIENT_ID"
CURRENT_COGNITO_ID=$(grep -oP 'region:"[a-z0-9-]+"\}[^"]*"\K[a-z0-9]{20,35}' "$JS_FILE" | sort -u | head -1)

# Extract current API Gateway base URLs:
#   Pattern: https://APIID.execute-api.REGION.amazonaws.com/prod
readarray -t CURRENT_API_URLS < <(grep -oP 'https://[a-z0-9]+\.execute-api\.[a-z0-9-]+\.amazonaws\.com/prod' "$JS_FILE" | sort -u)

# Distinguish IoT API from Express API by checking usage paths:
#   Express API is used with /washer, /user, /item paths
#   IoT API is used with /use, /unlock, /reserve paths
CURRENT_IOT_URL=""
CURRENT_EXPRESS_URL=""
for api_url in "${CURRENT_API_URLS[@]}"; do
  escaped_url=$(printf '%s' "$api_url" | sed 's/[.[\*^$()+?{|]/\\&/g')
  if grep -qP "${escaped_url}/washer" "$JS_FILE" 2>/dev/null || \
     grep -qP "${escaped_url}/user"   "$JS_FILE" 2>/dev/null || \
     grep -qP "${escaped_url}/item"   "$JS_FILE" 2>/dev/null; then
    CURRENT_EXPRESS_URL="$api_url"
  else
    CURRENT_IOT_URL="$api_url"
  fi
done

# Validate detection results
DETECT_OK=true
if [ -z "$CURRENT_COGNITO_ID" ]; then
  echo "  WARNING: Could not detect current Cognito Client ID in JS"
  DETECT_OK=false
else
  echo "  Current Cognito Client ID : $CURRENT_COGNITO_ID"
fi
if [ -z "$CURRENT_IOT_URL" ]; then
  echo "  WARNING: Could not detect current IoT API URL in JS"
  DETECT_OK=false
else
  echo "  Current IoT API URL       : $CURRENT_IOT_URL"
fi
if [ -z "$CURRENT_EXPRESS_URL" ]; then
  echo "  WARNING: Could not detect current Express API URL in JS"
  DETECT_OK=false
else
  echo "  Current Express API URL   : $CURRENT_EXPRESS_URL"
fi

if [ "$DETECT_OK" != "true" ]; then
  echo ""
  echo "ERROR: Failed to detect one or more current values in the JS file."
  echo "       The JS bundle format may have changed. Manual replacement required."
  exit 1
fi
echo ""

# --- Check if values already match ---
if [ "$CURRENT_COGNITO_ID" = "$NEW_COGNITO_CLIENT_ID" ] && \
   [ "$CURRENT_IOT_URL" = "$NEW_IOT_API_URL" ] && \
   [ "$CURRENT_EXPRESS_URL" = "$NEW_EXPRESS_API_URL" ]; then
  echo "[3/5] All values already match. No replacement needed."
  echo ""
else
  # --- Perform replacements ---
  echo "[3/5] Replacing values in JS bundle..."

  REPLACED=0
  if [ "$CURRENT_COGNITO_ID" != "$NEW_COGNITO_CLIENT_ID" ]; then
    sed -i "s|$CURRENT_COGNITO_ID|$NEW_COGNITO_CLIENT_ID|g" "$JS_FILE"
    echo "  Cognito Client ID : $CURRENT_COGNITO_ID -> $NEW_COGNITO_CLIENT_ID"
    REPLACED=$((REPLACED + 1))
  else
    echo "  Cognito Client ID : already up to date"
  fi

  if [ "$CURRENT_IOT_URL" != "$NEW_IOT_API_URL" ]; then
    sed -i "s|$CURRENT_IOT_URL|$NEW_IOT_API_URL|g" "$JS_FILE"
    echo "  IoT API URL       : $CURRENT_IOT_URL -> $NEW_IOT_API_URL"
    REPLACED=$((REPLACED + 1))
  else
    echo "  IoT API URL       : already up to date"
  fi

  if [ "$CURRENT_EXPRESS_URL" != "$NEW_EXPRESS_API_URL" ]; then
    sed -i "s|$CURRENT_EXPRESS_URL|$NEW_EXPRESS_API_URL|g" "$JS_FILE"
    echo "  Express API URL   : $CURRENT_EXPRESS_URL -> $NEW_EXPRESS_API_URL"
    REPLACED=$((REPLACED + 1))
  else
    echo "  Express API URL   : already up to date"
  fi

  echo "  Total replacements: $REPLACED"
  echo ""
fi

# --- Verify replacements ---
echo "[4/5] Verifying final values in JS..."
VERIFY_OK=true

if grep -q "$NEW_COGNITO_CLIENT_ID" "$JS_FILE"; then
  echo "  OK: Cognito Client ID present"
else
  echo "  FAIL: Cognito Client ID '$NEW_COGNITO_CLIENT_ID' not found in JS"
  VERIFY_OK=false
fi

if grep -q "$NEW_IOT_API_URL" "$JS_FILE"; then
  echo "  OK: IoT API URL present"
else
  echo "  FAIL: IoT API URL '$NEW_IOT_API_URL' not found in JS"
  VERIFY_OK=false
fi

if grep -q "$NEW_EXPRESS_API_URL" "$JS_FILE"; then
  echo "  OK: Express API URL present"
else
  echo "  FAIL: Express API URL '$NEW_EXPRESS_API_URL' not found in JS"
  VERIFY_OK=false
fi

if [ "$VERIFY_OK" != "true" ]; then
  echo ""
  echo "ERROR: Verification failed! Some values were not replaced correctly."
  echo "       The JS file may be corrupted. Check the file manually."
  exit 1
fi
echo ""

# --- Upload to S3 ---
echo "[5/5] Uploading frontend to S3..."
aws s3 sync "$FRONTEND_DIR/" "s3://$S3_BUCKET_NAME/" --delete
echo ""

echo "=== Deployment complete! ==="
echo "Website: $S3_BUCKET_WEBSITE"
