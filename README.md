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

  > [!Note]
  > When using the default cassandra image from <https://hub.docker.com/_/cassandra>, Use default username and password for cassandra. If you want to create a custom user and password it needs to be done manually (a init script can be made, but not done here for simplicity), follow the [guide](https://cassandra.apache.org/doc/stable/cassandra/operating/security.html#password-authentication)
  >
  > **1. Open csql console**
  >
  > ```bash
  > cqlsh -u cassandra -p cassandra
  >```
  >
  > **2. Create new user**
  >
  >```cql
  >CREATE ROLE <username> WITH SUPERUSER = true AND LOGIN = true AND PASSWORD = '<password>';
  >```
  >
  > **3. Optional: Disable default user**
  >
  >```cql
  >ALTER ROLE cassandra WITH SUPERUSER = false AND LOGIN = false;
  >```
  >
  
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

  > [!Note]
  > **Validating if cors is setting**
  >
  > Call a OPTION http request using curl and see the response headers
  >
  > ```bash
  > curl -X OPTIONS \
  > http://localhost:4318/v1/traces/ \
  > -H 'Origin: http://<url>:<port>' \
  > -H 'Access-Control-Request-Method: GET' \
  > -H 'Access-Control-Request-Headers: Content-Type' \
  > -i
  > ```
  >
  > **Response**
  >
  > ```bash
  > HTTP/1.1 204 No Content
  > Access-Control-Allow-Credentials: true
  > Access-Control-Allow-Headers: Content-Type
  > Access-Control-Allow-Methods: GET
  > Access-Control-Allow-Origin: http://<url>:<port>
  > Vary: Origin, Access-Control-Request-Method, Access-Control-Request-Headers
  > Date: Wed, 30 Apr 2025 14:23:37 GMT
  > ```
  >
  > The response should have your `Origin` as `Access-Control-Allow-Origin` header value
  > > Access-Control-Allow-Origin: `http://<url>:<port>`

#### 4. Run services

  ```bash
  just up
  ```
