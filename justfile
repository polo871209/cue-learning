# List all available commands
default:
    @just --list

# Export all apps to YAML (native CUE multi-document format)
export-all:
    @cue export ./apps/... --out yaml

# Export nginx deployment to YAML
export-nginx:
    @cue export apps/nginx/deployment.cue --out yaml

# Export api-service deployment to YAML
export-api-service:
    @cue export apps/api-service/deployment.cue --out yaml

# Export specific app to YAML
export app:
    @cue export apps/{{app}}/deployment.cue --out yaml

# Validate all configurations
validate:
    @cue vet ./...
    @echo "✓ All configurations valid"

# Validate specific app
validate-app app:
    @cue vet apps/{{app}}/deployment.cue
    @echo "✓ {{app}} configuration valid"

# Dry-run apply for specific app
dry-run app:
    @cue export apps/{{app}}/deployment.cue --out yaml | kubectl apply --dry-run=client -f -
