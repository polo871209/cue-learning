# List all available commands
default:
    @just --list

# Export all apps to YAML (native CUE multi-document format)
export-all:
    @cue export ./apps/... --out yaml

# Export nginx deployment to YAML with --- separators
export-nginx:
    @cue export ./apps/nginx/. --out text --expression stream

# Export api-service deployment to YAML with --- separators
export-api-service:
    @cue export ./apps/api-service/. --out text --expression stream

# Export specific app to YAML with --- separators
export app:
    @cue export ./apps/{{app}}/. --out text --expression stream

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
    @cue export ./apps/{{app}}/. --out text --expression stream | kubectl apply --dry-run=client -f -
