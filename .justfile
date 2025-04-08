set dotenv-filename := ".just.env"

PROJECT := "telemetry"

up +SERVICES="":
    docker compose \
    {{ if env_var('ENABLE_PROMETHEUS') == "1" { "--profile prometheus" } else { "" } }} \
    {{ if env_var('ENABLE_NGINX') == "1" { "--profile nginx" } else { "" } }} \
    --profile default \
    -p {{ PROJECT }} \
    up -d {{ SERVICES }}

down +SERVICES="":
    docker compose  \
    {{ if env_var('ENABLE_PROMETHEUS') == "1" { "--profile prometheus" } else { "" } }} \
    {{ if env_var('ENABLE_NGINX') == "1" { "--profile nginx" } else { "" } }} \
    --profile default \
    -p {{ PROJECT }} \
    down {{ SERVICES }}

restart +SERVICES="":
    just down {{ SERVICES }}
    just up {{ SERVICES }}

logs +ARGS:
    docker logs {{ ARGS }}

exec +ARGS:
    docker compose -p {{PROJECT}} exec {{ ARGS }}

justedit:
    editor .just.env

envedit:
    editor .just.env
