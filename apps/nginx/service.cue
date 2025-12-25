package app

import core "cue.dev/x/k8s.io/api/core/v1"

_service: core.#Service & {
	apiVersion: "v1"
	kind:       "Service"

	metadata: {
		name:      "secure-nginx-service"
		namespace: "app"
		labels: app: "secure-nginx"
	}

	spec: {
		selector: app: "secure-nginx"
		ports: [{
			protocol:   "TCP"
			port:       80
			targetPort: 80
		}]
		type: "ClusterIP"
	}
}

