# Flux2
This setup is by no means production ready and is only ment for testing fluxcd2 on your local machine.

## Resources
* [kind](https://kind.sigs.k8s.io/)
* [Gitea](https://gitea.io/en-us/)
* [Fluxcd](https://fluxcd.io/)

## Usage
### Prerequisites
* docker
* kind
* flux
* helm
* kubectl
* make

### Create cluster 
```shell
make create-cluster
```

This will install and initialize a kubernetes cluster with nginx-ingress, gitea and fluxcd installed and initialized.

Checkout the repo that is present in gitea (http://gitea.127.0.0.1.xip.io). The repo is a clone of this githubrepo

Add yaml files to the folder flux/apps to deploy them with flux. Flux will by default sync every five minutes, to force sync run: ```make flux-sync```

The applicaiton that is deployed is a simble go application. Sourcecode for the app is located here: https://github.com/tjololo/hello-go-web

### Delete cluster
```shell
make delete-cluster
```