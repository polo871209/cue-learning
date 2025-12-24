# Kubernetes CUE Configuration

Secure Kubernetes deployment configurations using CUE.

## Project Structure

```
.
├── cue.mod/                    # CUE module configuration
│   └── module.cue
├── definitions/                # Reusable template definitions
│   └── deployment.cue          # Secure deployment template (#Deployment)
└── apps/                       # Application configurations
    ├── nginx/                  # Basic nginx example
    │   └── deployment.cue
    └── api-service/            # Advanced API service example
        └── deployment.cue
```

## Usage

### Export a deployment to YAML

```bash
# Basic nginx deployment
cue export apps/nginx/deployment.cue definitions/deployment.cue --out yaml

# Advanced API service deployment
cue export apps/api-service/deployment.cue definitions/deployment.cue --out yaml
```

### Apply to Kubernetes

```bash
# Export and apply nginx deployment
cue export apps/nginx/deployment.cue definitions/deployment.cue --out yaml | kubectl apply -f -

# Export and apply API service deployment
cue export apps/api-service/deployment.cue definitions/deployment.cue --out yaml | kubectl apply -f -
```

### Validate configurations

```bash
# Validate all configurations
cue vet ./...

# Validate specific app
cue vet apps/nginx/deployment.cue definitions/deployment.cue
```

## Security Features

All deployments use the `#Deployment` template which enforces security best practices:

- **Non-root user**: Runs as UID 10000 (container) and 1000 (pod)
- **Read-only root filesystem**: Prevents tampering with container filesystem
- **Dropped capabilities**: All Linux capabilities dropped by default
- **No privilege escalation**: Prevents containers from gaining additional privileges
- **Seccomp profile**: Uses RuntimeDefault seccomp profile
- **No default namespace**: Cannot deploy to "default" namespace (enforced by constraint)
- **Service account tokens**: Disabled by default

## Adding New Applications

1. Create a new directory under `apps/`:
   ```bash
   mkdir -p apps/my-app
   ```

2. Create a `deployment.cue` file:
   ```cue
   package kube

   #Deployment & {
       _config: {
           name:      "my-app"
           namespace: "production"  // Cannot be "default"
           image:     "my-app:v1.0.0"
           replicas:  2
       }
   }
   ```

3. Export and validate:
   ```bash
   cue export apps/my-app/deployment.cue definitions/deployment.cue --out yaml
   ```

## Template Configuration

The `#Deployment` template accepts the following configuration:

### Required Fields
- `name`: Deployment and container name
- `namespace`: Target namespace (cannot be "default")
- `image`: Container image

### Optional Fields
- `replicas`: Number of replicas (default: 1)
- `appLabel`: App label value (default: same as name)

### Overriding Defaults

You can override template defaults by extending the deployment spec:

```cue
#Deployment & {
    _config: {
        name:      "my-app"
        namespace: "app"
        image:     "my-app:latest"
    }

    // Override resource limits
    spec: template: spec: containers: [{
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
    }]
}
```

See `apps/api-service/deployment.cue` for a complete example with health checks, volumes, and custom resources.
