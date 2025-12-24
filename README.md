# Kubernetes CUE Configuration

Secure Kubernetes deployment configurations using CUE with package-based imports.

## Project Structure

```
.
├── cue.mod/
│   └── module.cue              # Module: cue.example/kube
├── definitions/                # Reusable definitions (package: definitions)
│   └── deployment.cue          # #Config, #Deployment
└── apps/                       # Applications (package: app)
    ├── nginx/
    │   └── deployment.cue
    └── api-service/
        └── deployment.cue
```

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

## Adding New Applications

Create `apps/my-app/deployment.cue`:

```cue
package app

import base "cue.example/kube/definitions"

_deployment: base.#Deployment & {
    config: {
        name:      "my-app"
        namespace: "production"
        image:     "my-app:v1.0.0"
        replicas:  2
    }
}

_deployment.output
```

## Configuration

### Basic

```cue
package app

import base "cue.example/kube/definitions"

_deployment: base.#Deployment & {
    config: {
        name:      "my-app"        // Required
        namespace: "app"           // Required (not "default")
        image:     "my-app:latest" // Required
        replicas:  3               // Optional (default: 1)
        appLabel:  "my-app"        // Optional (default: name)
    }
}

_deployment.output
```

### Advanced

Extend the deployment by merging with `output`:

```cue
package app

import base "cue.example/kube/definitions"

_deployment: base.#Deployment & {
    config: {
        name:      "my-app"
        namespace: "app"
        image:     "my-app:latest"
        replicas:  3
    }

    output: spec: template: spec: {
        containers: [{
            env: [{
                name:  "LOG_LEVEL"
                value: "info"
            }]

            resources: {
                requests: {
                    memory: "256Mi"
                    cpu:    "250m"
                }
                limits: {
                    memory: "512Mi"
                    cpu:    "500m"
                }
            }

            livenessProbe: {
                httpGet: {
                    path: "/health"
                    port: 8080
                }
                initialDelaySeconds: 30
            }

            volumeMounts: [{
                name:      "tmp"
                mountPath: "/tmp"
            }]

            securityContext: capabilities: add: ["NET_BIND_SERVICE"]
        }]

        volumes: [{
            name: "tmp"
            emptyDir: {}
        }]
    }
}

_deployment.output
```

See `apps/api-service/deployment.cue` for a complete example.
