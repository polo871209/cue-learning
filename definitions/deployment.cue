package definitions

import apps "cue.dev/x/k8s.io/api/apps/v1"

// Deployment provides a template with security best practices
// It's a Kubernetes Deployment with secure defaults that can be directly extended
#Deployment: apps.#Deployment & {
	apiVersion: "apps/v1"
	kind:       "Deployment"

	// Metadata with required fields
	metadata: {
		name:      string
		namespace: string & !="default"
		labels: app: string | *name
	}

	// Helper to get the app label
	let _appLabel = metadata.labels.app
	let _name = metadata.name

	spec: {
		replicas: *1 | int
		selector: matchLabels: app: _appLabel

		template: {
			metadata: labels: app: _appLabel

			spec: {
				// Security best practices at pod level
				securityContext: {
					// Run as non-root user with high UID (>10000)
					runAsNonRoot: *true | bool
					runAsUser:    *10009 | int
					runAsGroup:   *10009 | int
					fsGroup:      *10009 | int

					// Restrict filesystem access
					fsGroupChangePolicy: *"OnRootMismatch" | string

					// Set secure sysctls (if needed, otherwise empty)
					seccompProfile: type: *"RuntimeDefault" | string
				}

				// Use service account (defaults to "default")
				serviceAccountName: *"default" | string

				// Automatically mount service account token only if needed
				automountServiceAccountToken: *false | bool

				containers: [...] & [
					{
						name:  string | *_name
						image: string

						// Security best practices at container level
						securityContext: {
							// Prevent privilege escalation
							allowPrivilegeEscalation: *false | bool

							// Run as non-root with high UID (>10000)
							runAsNonRoot: *true | bool
							runAsUser:    *10009 | int
							runAsGroup:   *10009 | int

							// Drop all capabilities and only add required ones
							capabilities: drop: *["ALL"] | [...string]

							// Read-only root filesystem
							readOnlyRootFilesystem: *true | bool

							// Use seccomp profile
							seccompProfile: type: *"RuntimeDefault" | string
						}

						// Resource limits (should be adjusted per application)
						resources: {
							limits: {
								memory: string | *"128Mi"
								cpu:    string | *"200m"
							}
							requests: {
								memory: string | *"64Mi"
								cpu:    string | *"100m"
							}
						}
					},
					...,
				]
			}
		}
	}
}
