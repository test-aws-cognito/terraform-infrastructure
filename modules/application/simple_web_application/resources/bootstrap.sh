#!/bin/bash

yum update -y
amazon-linux-extras install docker
service docker start
usermod -a -G docker ec2-user
chkconfig docker on

docker run \
    -p 443:12345 \
    --env APPLICATION_HOSTNAME=localhost \
    --env APPLICATION_PORT=12345 \
    --env APPLICATION_COGNITO_AWS_REGION=${cognito_aws_region} \
    --env APPLICATION_COGNITO_USER_POOL_ID=${cognito_user_pool_id} \
    --env APPLICATION_COGNITO_CLIENT_ID=${cognito_client_id} \
    --env APPLICATION_COGNITO_CLIENT_SECRET=${cognito_client_secret} \
    --env APPLICATION_COGNITO_REDIRECT_URI=${cogito_login_redirect_uri} \
    --env APPLICATION_REDIS_HOSTNAME=${redis_hostname} \
    --env APPLICATION_REDIS_PORT=${redis_port} \
    --env APPLICATION_POSTGRESQL_HOSTNAME=${postgresql_hostname} \
    --env APPLICATION_POSTGRESQL_PORT=${postgresql_port} \
    --env APPLICATION_POSTGRESQL_DB=${postgresql_db} \
    --env APPLICATION_POSTGRESQL_USER=${postgresql_user} \
    --env APPLICATION_POSTGRESQL_PASSWORD=${postgresql_password} \
    testawscognito/simple-web-app:1.0.0
