#!/bin/bash
DB_PASSWORD=$(kubectl get secrets gitea-mariadb -o template --template '{{ index .data "mariadb-password" }}' | base64 -d)

curl -X POST \
--data "db_type=MySQL&db_host=gitea-mariadb%3A3306&db_user=gitea&db_passwd=$DB_PASSWORD&db_name=gitea&ssl_mode=disable&charset=utf8&db_path=data%2Fgitea.db&app_name=Gitea%3A+Git+with+a+cup+of+tea&repo_root_path=%2Fdata%2Fgit%2Fgitea-repositories&lfs_root_path=%2Fapp%2Fgitea%2Fdata%2Flfs&run_user=git&domain=gitea.127.0.0.1.xip.io&ssh_port=8022&http_port=3000&app_url=http%3A%2F%2Fgitea.127.0.0.1.xip.io%2F&log_root_path=%2Fapp%2Fgitea%2Flog&smtp_host=&smtp_from=&smtp_user=&smtp_passwd=&enable_open_id_sign_in=on&enable_open_id_sign_up=on&default_allow_create_organization=on&default_enable_timetracking=on&no_reply_address=noreply.example.org&admin_name=&admin_passwd=&admin_confirm_passwd=&admin_email=" \
"http://gitea.127.0.0.1.xip.io/install"

curl -X POST \
--data "_csrf=zWR1pCIsvgtrnOK-NI9GOSBqvBc6MTYwMTQ2NzA5NTY0NzMxMjUwMA&user_name=demo&email=demo%40example.local&password=Password%231&retype=Password%231" \
"http://gitea.127.0.0.1.xip.io/user/sign_up"

curl -X POST \
-u "demo:Password#1" \
-H "Content-Type: application/json" \
--data '{"uid":1,"clone_addr":"https://github.com/tjololo/argo-flux.git","repo_name":"argo-flux"}' \
"http://gitea.127.0.0.1.xip.io/api/v1/repos/migrate"
