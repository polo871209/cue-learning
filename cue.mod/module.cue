module: "cue.example/kube"
language: {
	version: "v0.15.1"
}
deps: {
	"cue.dev/x/k8s.io@v0": {
		v:       "v0.6.0"
		default: true
	}
}
