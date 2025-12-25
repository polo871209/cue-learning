package app

import core "cue.dev/x/k8s.io/api/core/v1"

_service: core.#Service & {
	apiVersion: "v1"
	kind:       "Service"

	metadata: {
		name:      _config.name
		namespace: _config.namespace
		labels: _config.labels & {
			"extra": "exmple"
		}
	}

	spec: {
		selector: _config.labels
		ports: [{
			protocol:   "TCP"
			port:       80
			targetPort: 80
		}]
		type: "ClusterIP"
	}
}
