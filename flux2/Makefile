setup-cluster:
	kind create cluster --config install/kind-config.yaml --name flux2
	kubectl cluster-info --context kind-flux2
	kubectl config use-context kind-flux2

deploy-nginx:
	kubectl apply -f install/nginx/deploy.yaml
	sleep 5
	kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=360s

install-gitea:
	helm repo add gitea-charts https://dl.gitea.io/charts/
	helm install gitea gitea-charts/gitea -f install/gitea/values.yaml
	sleep 5
	kubectl wait --namespace default --for=condition=ready pod --selector=app.kubernetes.io/name=gitea --timeout=360s
	sleep 2
	./install/gitea/initialize.sh
	kubectl apply -f install/gitea/gitea-svc.yaml

install-flux:
	flux install --arch=amd64
	flux create source git applications \
	--url=http://gitea-local.default.svc.cluster.local:3000/demo/argo-flux \
	--branch=master \
	--interval=1m \
	--username=demo \
	--password=Password#1
	flux create kustomization apps \
	--source=applications \
	--path="./flux2/apps" \
	--prune=true \
	--interval=1m \
	--validation=client
	
delete-flux:
	flux uninstall --crd

print-credentials:
	@echo "Demo cluster is ready. Gitea url: http://gitea.127.0.0.1.xip.io"
	@echo "Gitea login. Username: demo Passord: Password#1"
	@echo "Example application url: http://app-one.127.0.0.1.xip.io/hello"


create-cluster: setup-cluster deploy-nginx install-gitea install-flux print-credentials


delete-cluster:
	kind delete cluster --name flux2

flux-sync:
	flux reconcile kustomization apps

