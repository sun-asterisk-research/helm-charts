# Laravel Echo Server

[NodeJS server](https://github.com/tlaverdure/laravel-echo-server) for Laravel Echo broadcasting with Socket.io

## Install

```sh
helm repo add sunasteriskrnd https://sun-asterisk-research.github.io/helm-charts
helm install my-release sunasteriskrnd/laravel-echo-server
```

## Parameters

The following tables lists the configurable parameters and their default values.

### Global parameters

| Parameter                 | Description                                     | Default |
|---------------------------|-------------------------------------------------|---------|
| `global.imageRegistry`    | Global Docker image registry                    | `nil`   |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`    |

### Deployment parameters

| Parameter                               | Description                                                                                                 | Default                              |
|-----------------------------------------|-------------------------------------------------------------------------------------------------------------|--------------------------------------|
| `nameOverride`                          | String to partially override `common.names.fullname` template with a string (will prepend the release name) | `nil`                                |
| `fullnameOverride`                      | String to fully override `common.names.fullname` template with a string                                     | `nil`                                |
| `image.registry`                        | The image registry to be used                                                                               | `docker.io`                          |
| `image.repository`                      | The image repository to be used                                                                             | `sunasteriskrnd/laravel-echo-server` |
| `image.tag`                             | The image tag to be used                                                                                    | `{LARAVEL_ECHO_SERVER_VERSION}`      |
| `image.pullPolicy`                      | Image pull policy                                                                                           | `IfNotPresent`                       |
| `image.pullSecrets`                     | Specify docker-registry secret names as an array                                                            | `[]`                                 |
| `replicaCount`                          | Number of Pods to run                                                                                       | `1`                                  |
| `updateStrategy`                        | Set up update strategy                                                                                      | `RollingUpdate`                      |
| `podSecurityContext`                    | Specify security context for pods                                                                           | `{}`                                 |
| `securityContext`                       | Specify security context for laravel-echo-server container                                                  | `{}`                                 |
| `auth.host`                             | The host of the server that authenticates private and presence channels                                     | `nil`                                |
| `auth.endpoint`                         | The route that authenticates private channels                                                               | `/broadcasting/auth`                 |
| `subscribers.http.enabled`              | Enable the HTTP subscriber                                                                                  | `false`                              |
| `subscribers.http.clients`              | List of API cients for the HTTP subscriber                                                                  | `false`                              |
| `subscribers.redis.enabled`             | Enable the Redis subscriber                                                                                 | `true`                               |
| `subscribers.redis.host`                | Host of the external redis                                                                                  | `localhost`                          |
| `subscribers.redis.port`                | Port of the external redis                                                                                  | `6379`                               |
| `subscribers.redis.password`            | Password for the external redis (ignored if existing secret is set)                                         | `nil`                                |
| `subscribers.redis.passwordSecret.name` | Name of existing secret object for the external redis (for password authentication)                         | `nil`                                |
| `subscribers.redis.passwordSecret.key`  | Name of key containing password to be retrieved from the existing secret                                    | `nil`                                |
| `subscribers.redis.db`                  | Index for jobservice database                                                                               | `0`                                  |
| `subscribers.redis.keyPrefix`           | Prefix for Redis keys                                                                                       | `nil`                                |
| `cors.enabled`                          | Send CORS headers                                                                                           | `false`                              |
| `cors.allowOrigin`                      | Access-Control-Allow-Origin Header                                                                          | `nil`                                |
| `cors.allowMethods`                     | Access-Control-Allow-Methods Header                                                                         | `nil`                                |
| `cors.allowHeader`                      | Access-Control-Allow-Headers Header                                                                         | `nil`                                |
| `devMode`                               | Enable dev mode                                                                                             | `false`                              |
| `resources.limits`                      | The resources limits for the container                                                                      | `{}`                                 |
| `resources.requests`                    | The requested resources for the container                                                                   | `{"memory": "128Mi", "cpu": "100m"}` |
| `podAnnotations`                        | Pod annotations                                                                                             | `{}`                                 |
| `podAffinityPreset`                     | Pod affinity preset. Allowed values: `soft` or `hard`                                                       |                                      |
| `podAntiAffinityPreset`                 | Pod anti-affinity preset. Allowed values: `soft` or `hard`                                                  |                                      |
| `nodeAffinityPreset.type`               | Node affinity preset. Allowed values: `soft` or `hard`                                                      |                                      |
| `nodeAffinityPreset.key`                | Node label key to match                                                                                     |                                      |
| `nodeAffinityPreset.values`             | Node label values to match                                                                                  |                                      |
| `nodeSelector`                          | Node labels for pod assignment                                                                              | `{}`                                 |
| `tolerations`                           | Tolerations for pod assignment                                                                              | `[]`                                 |
| `affinity`                              | Affinity for pod assignment                                                                                 | `{}`                                 |
| `livenessProbe.enabled`                 | Enable/disable the liveness probe                                                                           | `true`                               |
| `livenessProbe.initialDelaySeconds`     | Delay before liveness probe is initiated                                                                    | `10`                                 |
| `livenessProbe.periodSeconds`           | How often to perform the probe                                                                              | `60`                                 |
| `livenessProbe.timeoutSeconds`          | When the probe times out                                                                                    | `5`                                  |
| `livenessProbe.successThreshold`        | Minimum consecutive successes for the probe to be considered successful after having failed                 | `1`                                  |
| `livenessProbe.failureThreshold`        | Minimum consecutive failures for the probe to be considered failed after having succeeded                   | `5`                                  |
| `readinessProbe.enabled`                | Enable/disable the readiness probe                                                                          | `true`                               |
| `readinessProbe.initialDelaySeconds`    | Delay before readiness probe is initiated                                                                   | `10`                                 |
| `readinessProbe.periodSeconds`          | How often to perform the probe                                                                              | `10`                                 |
| `readinessProbe.timeoutSeconds`         | When the probe times out                                                                                    | `5`                                  |
| `readinessProbe.successThreshold`       | Minimum consecutive successes for the probe to be considered successful after having failed                 | `1`                                  |
| `readinessProbe.failureThreshold`       | Minimum consecutive failures for the probe to be considered failed after having succeeded                   | `5`                                  |
| `service.type`                          | Kubernetes Service type                                                                                     | `ClusterIP`                          |
| `service.port`                          | Service HTTP port                                                                                           | `6001`                               |

### Ingress parameters

| Parameter             | Description                           | Default |
|-----------------------|---------------------------------------|---------|
| `ingress.enabled`     | Enable ingress controller resource    | `false` |
| `ingress.certManager` | Add annotations for cert-manager      | `false` |
| `ingress.hosts`       | Hosts config for the ingress resource | `[]`    |
| `ingress.tls`         | Create TLS Secret                     | `false` |
| `ingress.annotations` | Ingress annotations                   | `{}`    |
