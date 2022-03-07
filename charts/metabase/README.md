# Metabase

[Metabase](http://metabase.com) is the simplest, fastest way to get business intelligence and analytics to everyone in your company.

## Install

```sh
helm repo add sunasteriskrnd https://sun-asterisk-research.github.io/helm-charts
helm install my-release sunasteriskrnd/metabase
```

## Configuration parameters

The following tables lists the configurable parameters and their default values.

### Global parameters

| Parameter                 | Description                                     | Default |
|---------------------------|-------------------------------------------------|---------|
| `global.imageRegistry`    | Global Docker image registry                    | `nil`   |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`    |

### Deployment parameters

| Parameter                                 | Description                                                                                                                         | Default              |
|-------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------|----------------------|
| `nameOverride`                            | String to partially override `common.names.fullname` template with a string (will prepend the release name)                         | `""`                 |
| `fullnameOverride`                        | String to fully override `common.names.fullname` template with a string                                                             | `""`                 |
| `image.registry`                          | The image registry to be used                                                                                                       | `docker.io`          |
| `image.repository`                        | The image repository to be used                                                                                                     | `metabase/metabase`  |
| `image.tag`                               | The image tag to be used                                                                                                            | `{METABASE_VERSION}` |
| `image.pullPolicy`                        | Image pull policy                                                                                                                   | `IfNotPresent`       |
| `image.pullSecrets`                       | Specify docker-registry secret names as an array                                                                                    | `[]`                 |
| `replicaCount`                            | Number of Pods to run                                                                                                               | `1`                  |
| `updateStrategy`                          | Set up update strategy                                                                                                              | `RollingUpdate`      |
| `podSecurityContext`                      | Specify security context for pods                                                                                                   | `{}`                 |
| `securityContext`                         | Specify security context for Metabase container                                                                                     | `{}`                 |
| `encryptionKey`                           | The key used to encrypt database credentials stored in the application database                                                     | `nil`                |
| `adminEmail`                              | The email address users should be referred to if they encounter a problem                                                           | `nil`                |
| `database.type`                           | Possible values are `h2`, `postgresql` and `mysql`                                                                                  | `h2`                 |
| `database.host`                           | The host name or IP address of the application database, only used when db type is not `h2`                                         | `localhost`          |
| `database.port`                           | The port for `database.host`                                                                                                        | `nil`                |
| `database.dbName`                         | The database name of the application database used with `database.host`                                                             | `nil`                |
| `database.username`                       | The username for `database.host`                                                                                                    | `nil`                |
| `database.password`                       | The password for `database.host`                                                                                                    | `nil`                |
| `dw.maxConnectionPoolSize`                | Maximum number of connections to a data warehouse                                                                                   | `15`                 |
| `googleSignIn.clientID`                   | Client ID for Google Auth SSO                                                                                                       | `nil`                |
| `googleSignIn.autoCreateAccountForDomain` | Allows users to automatically create their Metabase account by logging in if their Google account email address is from this domain | `nil`                |
| `passwordComplexity`                      | Password strength. Possible values are `weak`, `normal`, `strong`                                                                   | `normal`             |
| `passwordLength`                          | Minimum password length                                                                                                             | `6`                  |
| `mail.from`                               | Address you want to use as the sender of emails generated by Metabase, such as pulses or account invitations                        | `nil`                |
| `mail.smtp.host`                          | The address of the SMTP server that handles your emails                                                                             | `nil`                |
| `mail.smtp.port`                          | The port your SMTP server uses for outgoing emails                                                                                  | `587`                |
| `mail.smtp.username`                      |                                                                                                                                     | `nil`                |
| `mail.smtp.password`                      | SMTP password                                                                                                                       | `nil`                |
| `mail.smtp.encryption`                    | SMTP secure connection protocol (`tls`, `ssl`, `starttls`, `none`)                                                                  | `none`               |
| `site.name`                               | The name used for this instance of Metabase                                                                                         | `Metabase`           |
| `site.url`                                | The base URL where users access Metabase, useful when serving in a sub path                                                         | `nil`                |
| `site.locale`                             | The default language for this Metabase instance (for emails, Pulses, etc.)                                                          | `en`                 |
| `jetty.host`                              | Hostname or IP address to listen on                                                                                                 | `0.0.0.0`            |
| `jetty.port`                              | Port to listen on                                                                                                                   | `3000`               |
| `jetty.maxThreads`                        | Maximum number of threads for jetty                                                                                                 | `50`                 |
| `jetty.minThreads`                        | Minimum number of threads for jetty                                                                                                 | `8`                  |
| `telemetry`                               | Enable the collection of anonymous usage data                                                                                       | `false`              |
| `timezone`                                | Application timezone                                                                                                                | `UTC`                |
| `javaOpts`                                | JVM arguments                                                                                                                       | `nil`                |
| `resources.limits`                        | The resources limits for the container                                                                                              | `{}`                 |
| `resources.requests`                      | The requested resources for the container                                                                                           | `{}`                 |
| `podAnnotations`                          | Pod annotations                                                                                                                     | `{}`                 |
| `podAffinityPreset`                       | Pod affinity preset. Allowed values: `soft` or `hard`                                                                               | `""`                 |
| `podAntiAffinityPreset`                   | Pod anti-affinity preset. Allowed values: `soft` or `hard`                                                                          | `soft`               |
| `nodeAffinityPreset.type`                 | Node affinity preset. Allowed values: `soft` or `hard`                                                                              | `""`                 |
| `nodeAffinityPreset.key`                  | Node label key to match                                                                                                             | `""`                 |
| `nodeAffinityPreset.values`               | Node label values to match                                                                                                          | `[]`                 |
| `nodeSelector`                            | Node labels for pod assignment                                                                                                      | `{}`                 |
| `tolerations`                             | Tolerations for pod assignment                                                                                                      | `[]`                 |
| `affinity`                                | Affinity for pod assignment                                                                                                         | `{}`                 |
| `livenessProbe.enabled`                   | Enable/disable the liveness probe                                                                                                   | `true`               |
| `livenessProbe.initialDelaySeconds`       | Delay before liveness probe is initiated                                                                                            | `120`                |
| `livenessProbe.periodSeconds`             | How often to perform the probe                                                                                                      | `10`                 |
| `livenessProbe.timeoutSeconds`            | When the probe times out                                                                                                            | `5`                  |
| `livenessProbe.successThreshold`          | Minimum consecutive successes for the probe to be considered successful after having failed                                         | `1`                  |
| `livenessProbe.failureThreshold`          | Minimum consecutive failures for the probe to be considered failed after having succeeded                                           | `5`                  |
| `readinessProbe.enabled`                  | Enable/disable the readiness probe                                                                                                  | `true`               |
| `readinessProbe.initialDelaySeconds`      | Delay before readiness probe is initiated                                                                                           | `30`                 |
| `readinessProbe.periodSeconds`            | How often to perform the probe                                                                                                      | `10`                 |
| `readinessProbe.timeoutSeconds`           | When the probe times out                                                                                                            | `5`                  |
| `readinessProbe.successThreshold`         | Minimum consecutive successes for the probe to be considered successful after having failed                                         | `1`                  |
| `readinessProbe.failureThreshold`         | Minimum consecutive failures for the probe to be considered failed after having succeeded                                           | `5`                  |
| `service.type`                            | Kubernetes Service type                                                                                                             | `ClusterIP`          |
| `service.port`                            | Service HTTP port                                                                                                                   | `80`                 |
| `persistence.enabled`                     | Enable persistence using PVC (only when `db.type` is `h2`)                                                                          | `false`              |
| `persistence.annotations`                 | Annotations for the PVC                                                                                                             | `{}`                 |
| `persistence.hostPath`                    | Host path to use as volume instead of PVC                                                                                           | `nil`                |
| `persistence.storageClass`                | PVC Storage Class                                                                                                                   | `nil`                |
| `persistence.accessModes`                 | PVC Access Modes                                                                                                                    | `[]`                 |
| `persistence.size`                        | PVC Storage Request                                                                                                                 | `1Gi`                |

### Ingress parameters

| Parameter             | Description                           | Default |
|-----------------------|---------------------------------------|---------|
| `ingress.enabled`     | Enable ingress controller resource    | `false` |
| `ingress.certManager` | Add annotations for cert-manager      | `false` |
| `ingress.hosts`       | Hosts config for the ingress resource | `[]`    |
| `ingress.tls`         | Create TLS Secret                     | `false` |
| `ingress.annotations` | Ingress annotations                   | `{}`    |
