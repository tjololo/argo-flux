#/bin/sh
key=$(fluxctl identity --k8s-fwd-ns flux)
curl -X POST \
-u "demo:Password#1" \
-H "Content-Type: application/json" \
--data "{\"key\":\"${key}\",\"read_only\":false,\"title\":\"flux\"}" \
"http://gitea.127.0.0.1.xip.io/api/v1/admin/users/demo/keys"

pod=$(kubectl get pods -n flux -l name=flux -oname)
hosts=$(kubectl -n flux exec ${pod} -- ssh-keyscan gitea-gitea-ssh.default.svc.cluster.local)
kubectl create configmap flux-ssh-config -n flux --from-literal=known_hosts="${hosts}"
kubectl patch deployment flux -n flux --patch "$(cat install/flux/config-patch.yaml)"