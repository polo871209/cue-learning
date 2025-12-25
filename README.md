# Kubernetes CUE learning 

Secure Kubernetes deployment configurations using CUE with package-based imports. This repository provides reusable CUE definitions for creating Kubernetes deployments with security best practices built-in.

## Usage

### List available commands

```bash
just
```

### Export to YAML

```bash
# Export all apps
just export-all

# Export specific app
just export-nginx
just export-api-service

# Or use the generic command
just export nginx
just export api-service
```

### Validate

```bash
# Validate all configurations
just validate

# Validate specific app
just validate-app nginx
```

### Apply to Kubernetes

```bash
# Apply specific app
just apply-nginx
just apply-api-service

# Or use the generic command
just apply nginx

# Dry-run first
just dry-run nginx
```

## Security Features

- Non-root user (UID 10000 container, 1000 pod)
- Read-only root filesystem
- All capabilities dropped by default
- No privilege escalation
- RuntimeDefault seccomp profile
- Cannot deploy to "default" namespace
- Service account tokens disabled
