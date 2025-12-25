package app

import "encoding/yaml"

// Collect all Kubernetes resources into a list
_resources: [
	_deployment,
	_service,
]

// Export as YAML stream with --- separators
stream: yaml.MarshalStream(_resources)
