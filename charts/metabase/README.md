# Metabase

[Metabase](http://metabase.com) is the simplest, fastest way to get business intelligence and analytics to everyone in your company.

## Install

```sh
helm repo add sunasteriskrnd https://sun-asterisk-research.github.io/helm-charts
helm install metabase sunasteriskrnd/metabase
```

## Parameters

### Global parameters

| Name                      | Description               | Value |
| ------------------------- | ------------------------- | ----- |
| `global.imagePullSecrets` | Global image pull secrets | `[]`  |

### Common parameters

| Name                | Description                                          | Value               |
| ------------------- | ---------------------------------------------------- | ------------------- |
| `nameOverride`      | String to partially override `common.names.fullname` | `""`                |
| `fullnameOverride`  | String to fully override `common.names.fullname`     | `""`                |
| `image.registry`    | Image registry                                       | `docker.io`         |
| `image.repository`  | Image repository                                     | `metabase/metabase` |
| `image.tag`         | Image tag (default to `.Chart.AppVersion`)           | `""`                |
| `image.pullPolicy`  | Image pull policy                                    | `IfNotPresent`      |
| `image.pullSecrets` | Image pull secrets                                   | `[]`                |

### Deployment parameters

| Name                                 | Description                                                                               | Value   |
| ------------------------------------ | ----------------------------------------------------------------------------------------- | ------- |
| `replicaCount`                       | Number of deployment replicas                                                             | `1`     |
| `livenessProbe.enabled`              | Enable livenessProbe                                                                      | `true`  |
| `livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                   | `120`   |
| `livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                          | `10`    |
| `livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                         | `5`     |
| `livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                       | `5`     |
| `livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                       | `1`     |
| `readinessProbe.enabled`             | Enable readinessProbe                                                                     | `true`  |
| `readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                  | `30`    |
| `readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                         | `10`    |
| `readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                        | `5`     |
| `readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                      | `5`     |
| `readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                      | `1`     |
| `resources.limits`                   | Resource limits for containers                                                            | `{}`    |
| `resources.requests`                 | Resource requests for containers                                                          | `{}`    |
| `podLabels`                          | Extra labels for pod                                                                      | `{}`    |
| `podAnnotations`                     | Annotations for pod                                                                       | `{}`    |
| `podSecurityContext.enabled`         | Enable pod SecurityContext                                                                | `false` |
| `containerSecurityContext.enabled`   | Enable container SecurityContext                                                          | `false` |
| `podAffinityPreset`                  | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`    |
| `podAntiAffinityPreset`              | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`  |
| `nodeAffinityPreset.type`            | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`    |
| `nodeAffinityPreset.key`             | Node label key to match. Ignored if `affinity` is set                                     | `""`    |
| `nodeAffinityPreset.values`          | Node label values to match. Ignored if `affinity` is set                                  | `[]`    |
| `affinity`                           | Affinity for pod assignment. Evaluated as a template.                                     | `{}`    |
| `nodeSelector`                       | Node labels for pod assignment. Evaluated as a template.                                  | `{}`    |
| `tolerations`                        | Tolerations for pod assignment. Evaluated as a template.                                  | `[]`    |
| `topologySpreadConstraints`          | Topology Spread Constraints for pod assignment. Evaluated as a template                   | `[]`    |

### Metabase configuration parameters

| Name                                      | Description                                                                                                                                    | Value       |
| ----------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| `site.name`                               | The name used for this instance of Metabase                                                                                                    | `Metabase`  |
| `site.url`                                | The base URL where users access Metabase                                                                                                       | `""`        |
| `site.locale`                             | The default language for this Metabase instance                                                                                                | `en`        |
| `encryptionKey`                           | When set, this will encrypt database credentials stored in the application database. Requirement: minimum 16 characters base64-encoded string. | `""`        |
| `adminEmail`                              | The email address users should be referred to if they encounter a problem                                                                      | `""`        |
| `database.type`                           | Database type (`h2`, `postgres` or `mysql`)                                                                                                    | `h2`        |
| `database.host`                           | The host name or IP address of the application database (when `database.type` is not `h2`)                                                     | `localhost` |
| `database.port`                           | The port for `database.host`                                                                                                                   | `""`        |
| `database.dbname`                         | The database name of the application database used with `database.host`                                                                        | `""`        |
| `database.username`                       | The username for `database.host`                                                                                                               | `""`        |
| `database.password`                       | The password for `database.host`                                                                                                               | `""`        |
| `database.maxConnectionPoolSize`          | Maximum number of connections to the Metabase application database                                                                             | `15`        |
| `dataWarehouse.maxConnectionPoolSize`     | Maximum number of connections to the data source databases (for each database)                                                                 | `15`        |
| `googleSignIn.clientID`                   | Client ID for Google Auth SSO. If this is set, Google Auth is considered to be enabled                                                         | `""`        |
| `googleSignIn.autoCreateAccountForDomain` | When set, allows users to automatically create their Metabase account by logging in if their Google account email address is from this domain  | `""`        |
| `passwordComplexity`                      | Enforce a password complexity rule to increase security for regular logins (`weak`, `normal` or `strong`)                                      | `normal`    |
| `passwordLength`                          | Set a minimum password length to increase security for regular logins                                                                          | `6`         |
| `mail.from.address`                       | Address you want to use as the sender of emails generated by Metabase, such as pulses or account invitations                                   | `""`        |
| `mail.from.name`                          | Use the defined name in emails                                                                                                                 | `""`        |
| `mail.replyTo`                            | Include a Reply-To address in emails                                                                                                           | `""`        |
| `mail.smtp.host`                          | The address of the SMTP server that handles your emails                                                                                        | `""`        |
| `mail.smtp.port`                          | The port your SMTP server uses for outgoing emails                                                                                             | `587`       |
| `mail.smtp.username`                      | SMTP username                                                                                                                                  | `""`        |
| `mail.smtp.password`                      | SMTP password                                                                                                                                  | `""`        |
| `mail.smtp.encryption`                    | SMTP secure connection protocol (`tls`, `ssl`, `starttls`, `none`)                                                                             | `none`      |
| `jetty.maxThreads`                        | Maximum number of threads                                                                                                                      | `50`        |
| `jetty.minThreads`                        | Minimum number of threads                                                                                                                      | `8`         |
| `telemetry`                               | Enable the collection of anonymous usage data in order to help Metabase improve                                                                | `false`     |
| `timezone`                                | Connection timezone to use when executing queries. Defaults to system timezone                                                                 | `UTC`       |
| `javaOpts`                                | `JAVA_OPTS` environment variable                                                                                                               | `""`        |
| `extraEnvVars`                            | Extra environment variables for containers                                                                                                     | `{}`        |

### Traffic exposure parameters

| Name                               | Description                                                                     | Value            |
| ---------------------------------- | ------------------------------------------------------------------------------- | ---------------- |
| `service.annotations`              | Service annotations                                                             | `[]`             |
| `service.type`                     | Kubernetes Service type                                                         | `ClusterIP`      |
| `service.port`                     | Kubernetes Service port                                                         | `80`             |
| `service.nodePort`                 | NodePort if Service type is `LoadBalancer` or `NodePort`                        | `""`             |
| `service.externalTrafficPolicy`    | Whether to route external traffic to node-local or cluster-wide endpoints       | `Cluster`        |
| `service.clusterIP`                | Service Cluster IP                                                              | `""`             |
| `service.loadBalancerSourceRanges` | Limit which client IP's can access the Network Load Balancer                    | `[]`             |
| `ingress.enabled`                  | Enable ingress resource generation                                              | `false`          |
| `ingress.annotations`              | Additional annotations for the Ingress resource                                 | `{}`             |
| `ingress.ingressClassName`         | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)   | `nil`            |
| `ingress.hostname`                 | Default host's hostname for the ingress resource                                | `metabase.local` |
| `ingress.path`                     | Default host's path for the ingress resource                                    | `/`              |
| `ingress.tls`                      | Ingress Enable TLS configuration for the hostname defined at `ingress.hostname` | `false`          |
| `ingress.selfSigned`               | Create a self-signed certificate for the hostname defined at `ingress.hostname` | `false`          |
| `ingress.existingSecret`           | Use an existing secret for the hostname defined at `ingress.hostname`           | `""`             |
| `ingress.secrets`                  | Create extra TLS secrets                                                        | `[]`             |
| `ingress.extraHosts`               | List of additional hostnames                                                    | `[]`             |
| `ingress.extraPaths`               | Additional paths for default host                                               | `[]`             |
| `ingress.extraTls`                 | Extra TLS configuration for default host                                        | `[]`             |
| `ingress.extraRules`               | Additional ingress rules                                                        | `[]`             |

### Persistence parameter

| Name                       | Description                                     | Value               |
| -------------------------- | ----------------------------------------------- | ------------------- |
| `persistence.enabled`      | Enable persistence, only when using h2 database | `false`             |
| `persistence.annotations`  | Additional custom annotations for the PVC       | `{}`                |
| `persistence.storageClass` | Persistent Volume storage class                 | `""`                |
| `persistence.accessModes`  | Persistent Volume access modes                  | `["ReadWriteOnce"]` |
| `persistence.size`         | Persistent Volume size                          | `1Gi`               |

### ServiceAccount parameters

| Name                                          | Description                                               | Value   |
| --------------------------------------------- | --------------------------------------------------------- | ------- |
| `serviceAccount.create`                       | Enable creation of ServiceAccount                         | `false` |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                    | `""`    |
| `serviceAccount.annotations`                  | Annotations for service account. Evaluated as a template. | `{}`    |
| `serviceAccount.automountServiceAccountToken` | Whether to auto mount the service account token           | `true`  |

