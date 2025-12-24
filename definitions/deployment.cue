package definitions

import apps "cue.dev/x/k8s.io/api/apps/v1"

// Config defines the required configuration for a deployment
#Config: {
	name:      string
	namespace: string & !="default"
	image:     string
	replicas:  *1 | int
	appLabel:  string | *name
}

// Deployment provides a template with security best practices
// Including non-root user, read-only filesystem, dropped capabilities, etc.
#Deployment: {
	// Config must be provided by users
	config: #Config

	// Output is the actual Kubernetes deployment
	output: apps.#Deployment & {
		apiVersion: "apps/v1"
		kind:       "Deployment"

		metadata: {
			name:      config.name
			namespace: config.namespace
			labels: app: config.appLabel
		}

		spec: {
			replicas: config.replicas
			selector: matchLabels: app: config.appLabel

			template: {
				metadata: labels: app: config.appLabel

				spec: {
					// Security best practices at pod level
					securityContext: {
						// Run as non-root user
						runAsNonRoot: true
						runAsUser:    1000
						runAsGroup:   1000
						fsGroup:      1000

						// Restrict filesystem access
						fsGroupChangePolicy: "OnRootMismatch"

						// Set secure sysctls (if needed, otherwise empty)
						seccompProfile: type: "RuntimeDefault"
					}

					// Automatically mount service account token only if needed
					automountServiceAccountToken: false

					containers: [{
						name:  config.name
						image: config.image

						// Security best practices at container level
						securityContext: {
							// Prevent privilege escalation
							allowPrivilegeEscalation: false

							// Run as non-root
							runAsNonRoot: true
							runAsUser:    10000

							// Drop all capabilities and only add required ones
							capabilities: drop: ["ALL"]

							// Read-only root filesystem
							readOnlyRootFilesystem: true

							// Use seccomp profile
							seccompProfile: type: "RuntimeDefault"
						}

						// Resource limits (should be adjusted per application)
						resources: limits: {
							memory: string | *"128Mi"
							cpu:    string | *"200m"
						}
						resources: requests: {
							memory: string | *"64Mi"
							cpu:    string | *"100m"
						}
					}]

					// Liveness and readiness probes should be defined per application
					// Example placeholder:
					// livenessProbe: {
					// 	httpGet: {
					// 		path: "/healthz"
					// 		port: 8080
					// 	}
					// 	initialDelaySeconds: 30
					// 	periodSeconds:       10
					// }

					// Volume mounts for writable directories (if needed)
					// volumeMounts: [{
					// 	name:      "tmp"
					// 	mountPath: "/tmp"
					// }]

					// Volumes for writable directories (if needed)
					// volumes: [{
					// 	name: "tmp"
					// 	emptyDir: {}
					// }]
				}
			}
		}
	}
}
