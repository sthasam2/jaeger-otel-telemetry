# Jaeger all-in-one OpenTelemetry

OTEL using Jaeger, OTEL Collector and Cassandra

## Useful Links

- **Docs**: <https://www.jaegertracing.io/docs/2.5/>
- **Architecture**: <https://www.jaegertracing.io/docs/2.5/architecture/#with-opentelemetry-collector>

## Running Steps

### Pre-requisites

1. Docker with docker compose
2. [Optional] Just for command recipes (Makes things easier to run)

### Steps

#### 1. Setup `.env` environment variables file

  This file contains all the required variables for configurations of services

  ```bash
  cp .env.example .env
  ```

#### 2. Setup `.just.env` variables file

  This file contains all the values for setting up services

  ```bash
  cp .just.env.example .just.env
  ```

#### 3. Optional: Update [jaeger config](/configs/config.yml) file for CORS

  Some services like browser clients require CORS to be enabled,
  for that we need to manually configure the [jaeger config](/configs/config.yml) file.

  Add your desired urls to config file

  ```diff
  receivers:
  otlp:
    protocols:
      grpc:
        endpoint: "${env:JAEGER_LISTEN_HOST:-0.0.0.0}:4317"
      http:
        endpoint: "${env:JAEGER_LISTEN_HOST:-0.0.0.0}:4318"
        cors:
          allowed_origins:
  +          - <protocol>://<host>[:<port>] # example https://myhost.domain:8443
  ```

#### 4. Run services

  ```bash
  just up
  ```
