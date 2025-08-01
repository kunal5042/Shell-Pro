login_ecr_public() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    type login_ecr_public | sed -n '/^#/,/^}/p'
    return 0
  fi

  local region="${1:-us-east-1}"
  local registry="${2:-public.ecr.aws/b3f8t4w3}"

  # Validate AWS CLI
  if ! command -v aws >/dev/null 2>&1; then
    echo "❌ Error: AWS CLI is not installed or not in PATH." >&2
    return 1
  fi

  # Validate Docker CLI
  if ! command -v docker >/dev/null 2>&1; then
    echo "❌ Error: Docker is not installed or not in PATH." >&2
    return 1
  fi

  echo "🔐 Logging into ECR public registry: $registry (region: $region)..."

  local login_password
  login_password=$(aws ecr-public get-login-password --region "$region" 2>/dev/null)

  if [[ -z "$login_password" ]]; then
    echo "❌ Error: Failed to retrieve ECR login password. Check your AWS credentials and region." >&2
    return 1
  fi

  echo "$login_password" | docker login --username AWS --password-stdin "$registry"
  if [[ $? -ne 0 ]]; then
    echo "❌ Error: Docker login failed. Check Docker is running and the registry URL is correct." >&2
    return 1
  fi

  echo "✅ Successfully logged in to $registry"
}