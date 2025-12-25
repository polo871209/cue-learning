package app

import base "github.com/polo871209/cue-learning/definitions"

_deployment: base.#Deployment & {
	metadata: {
		name:      _config.name
		namespace: _config.namespace
		labels: _config.labels & {
			"managed-by": "cue"
		}
	}
	spec: {
		replicas: 3
		template: spec: {
			containers: [{
				image: "nginx:1.27-alpine"
				volumeMounts: [
					{
						name:      "cache"
						mountPath: "/var/cache/nginx"
					},
					{
						name:      "run"
						mountPath: "/var/run"
					},
				]
			}]
			volumes: [
				{
					name: "cache"
					emptyDir: {}
				},
				{
					name: "run"
					emptyDir: {}
				},
			]
		}
	}
}
