package app

import base "github.com/polo871209/cue-learning/definitions"

// Advanced deployment example with health checks, volumes, and custom resources
_deployment: base.#Deployment & {
	config: {
		name:      "api-service"
		namespace: "production"
		image:     "myregistry/api:v1.2.3"
		replicas:  2
		appLabel:  "api-backend"
	}

	// Override or extend the template output
	output: spec: template: spec: {
		// Add writable tmp directory since we use read-only root filesystem
		containers: [{
			// Add environment variables
			env: [{
				name:  "LOG_LEVEL"
				value: "info"
			}, {
				name:  "PORT"
				value: "8080"
			}]

			// Add health checks
			livenessProbe: {
				httpGet: {
					path: "/health"
					port: 8080
				}
				initialDelaySeconds: 30
				periodSeconds:       10
				timeoutSeconds:      5
				failureThreshold:    3
			}

			readinessProbe: {
				httpGet: {
					path: "/ready"
					port: 8080
				}
				initialDelaySeconds: 5
				periodSeconds:       5
				timeoutSeconds:      3
				failureThreshold:    2
			}

			// Override resource limits for this specific app
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

			// Add volume mounts for writable directories
			volumeMounts: [{
				name:      "tmp"
				mountPath: "/tmp"
			}, {
				name:      "cache"
				mountPath: "/app/cache"
			}]

			// If you need specific capabilities, add them
			securityContext: capabilities: add: ["NET_BIND_SERVICE"]
		}]

		// Add volumes for writable directories
		volumes: [{
			name: "tmp"
			emptyDir: {}
		}, {
			name: "cache"
			emptyDir: sizeLimit: "100Mi"
		}]
	}
}

// Export only the Kubernetes manifest
_deployment.output
