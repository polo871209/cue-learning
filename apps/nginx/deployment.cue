package app

import base "github.com/polo871209/cue-learning/definitions"

_deployment: base.#Deployment & {
	metadata: {
		name:      "secure-nginx"
		namespace: "app"
		labels: {
			test: "hello-world"
		}
	}
	spec: {
		replicas: 3
		template: spec: containers: [{
			image: "nginx:1.27-alpine"
		}]
	}
}
