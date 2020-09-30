create-cluster:
	kind create cluster --config kind-config.yaml --name argo
	kubectl cluster-info --context kind-argo

deploy-nginx:
	kubectl apply -f nginx/deploy.yaml
	kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=90s

install-gitea:
	helm repo add k8s-land https://charts.k8s.land
	helm install gitea k8s-land/gitea -f gitea/values.yaml
	kubectl wait --timeout=180s -n default --for=condition=available deployments.apps/gitea-gitea
	kubectl wait --timeout=180s -n default --for=condition=ready pods/gitea-mariadb-0
	./gitea/install.sh

install-argocd:
	kubectl create namespace argocd
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
	kubectl apply -n argocd -f app-of-apps.yaml
	kubectl wait -n argocd --selector=app.kubernetes.io/part-of=argocd deployment --for=condition=available


setup-argo: create-cluster deploy-nginx install-gitea install-argocd
	@echo "Demo cluster is ready. Gitea url: http://gitea.127.0.0.1.xip.io"
	@echo "Gitea login. Username: demo Passord: Password#1"
	@echo "Argocd url: https://argocd.127.0.0.1.xip.io"
	@echo Argocd login. Username: admin Password: $(shell kubectl -n argocd get pods -l app.kubernetes.io/name=argocd-server -o template --template '{{ range .items }}{{ .metadata.name }} {{end}}')

## Cleanup
delete-argo:
	kind delete cluster --name argo