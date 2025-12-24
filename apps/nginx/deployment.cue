package app

import base "github.com/polo871209/cue-learning/definitions"

_deployment: base.#Deployment & {
	config: {
		name:      "secure-nginx"
		namespace: "app"
		image:     "nginx:1.27-alpine"
		replicas:  3
	}
}

// Export only the Kubernetes manifest
_deployment.output
