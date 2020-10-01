# Argocd
This setup is by no means production ready and is only ment for testing argocd on your local machine.

## Resources
* [kind](https://kind.sigs.k8s.io/)
* [Gitea](https://gitea.io/en-us/)
* [ArgoCD](https://argoproj.github.io/argo-cd/)
* [Automating Kubernetes Multi-Cluster Config With Argo CD](https://argoproj.github.io/argo-cd/)

## Usage
### Prerequisites
* docker
* kind
* helm
* kubectl
* make

### Create cluster with 
```shell
make create-cluster
```

This will install and initialize a kubernetes cluster with nginx-ingress, gitea and argocd installed and initialized.

Checkout the repo that is present in gitea (http://gitea.127.0.0.1.xip.io). The repo is a clone of this githubrepo

Inside the argo/argoapps folder you can deploy new argo applications

Inside the folder argo/k8s-config an argo application is already watching for changes. Make changes as you like, the repo will be reset when the cluster is destroyed

The applicaiton that is deployed is a simble go application. Sourcecode for the app is located here: https://github.com/tjololo/hello-go-web

### Delete cluster
```shell
make delete-cluster
```