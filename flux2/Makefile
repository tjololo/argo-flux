setup-cluster:
	kind create cluster --config install/kind-config.yaml --name flux2
	kubectl cluster-info --context kind-flux2
	kubectl config use-context kind-flux2

deploy-nginx:
	kubectl apply -f install/nginx/deploy.yaml
	sleep 5
	kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=360s

install-gitea:
	helm repo add k8s-land https://charts.k8s.land
	helm install gitea k8s-land/gitea -f install/gitea/values.yaml
	sleep 5
	kubectl wait --timeout=360s -n default --for=condition=available deployments.apps/gitea-gitea
	kubectl wait --timeout=360s -n default --for=condition=ready pods/gitea-mariadb-0
	sleep 2
	./install/gitea/initialize.sh

install-flux:
	flux install --arch=amd64
	flux create source git applications \
	--url=http://gitea-gitea-http.default.svc.cluster.local:3000/demo/argo-flux \
	--branch=master \
	--interval=1m \
	--username=demo \
	--password=Password#1
	flux create kustomization apps \
	--source=applications \
	--path="./flux/apps" \
	--prune=true \
	--interval=1m \
	--validation=client
	
delete-flux:
	fluxctl install \
	--git-user=demo \
	--git-email=demo@example.local \
	--git-url=git@gitea-gitea-ssh.default.svc.cluster.local:demo/argo-flux \
	--git-path=flux2/apps \
	--namespace=flux | kubectl delete -f -

print-credentials:
	@echo "Demo cluster is ready. Gitea url: http://gitea.127.0.0.1.xip.io"
	@echo "Gitea login. Username: demo Passord: Password#1"


create-cluster: setup-cluster deploy-nginx install-gitea install-flux print-credentials


delete-cluster:
	kind delete cluster --name flux

flux-sync:
	flux reconcile kustomization apps