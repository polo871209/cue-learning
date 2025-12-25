package app

import "encoding/yaml"

// Export as YAML stream with --- separators
stream: yaml.MarshalStream([_deployment])
