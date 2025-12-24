package kube

#Deployment & {
	_config: {
		name:      "secure-nginx"
		namespace: "app"
		image:     "nginx:1.27-alpine"
		replicas:  3
	}
}
