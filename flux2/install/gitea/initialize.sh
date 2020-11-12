curl -X POST \
-u "demo:Password#1" \
-H "Content-Type: application/json" \
--data '{"uid":1,"clone_addr":"https://github.com/tjololo/argo-flux.git","repo_name":"argo-flux"}' \
"http://gitea.127.0.0.1.xip.io/api/v1/repos/migrate"
