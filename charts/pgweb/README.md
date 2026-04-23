# pgweb

A simple web-based PostgreSQL database browser written in Go

## Parameters

### Common parameters

| Name                | Description                                        | Value |
| ------------------- | -------------------------------------------------- | ----- |
| `nameOverride`      | String to partially override common.names.fullname | `""`  |
| `fullnameOverride`  | String to fully override common.names.fullname     | `""`  |
| `commonLabels`      | Labels to add to all deployed objects              | `{}`  |
| `commonAnnotations` | Annotations to add to all deployed objects         | `{}`  |

### Image parameters

| Name                | Description                               | Value            |
| ------------------- | ----------------------------------------- | ---------------- |
| `image.registry`    | Image registry                            | `docker.io`      |
| `image.repository`  | Image repository                          | `sosedoff/pgweb` |
| `image.tag`         | Image tag (defaults to .Chart.AppVersion) | `""`             |
| `image.pullPolicy`  | Image pull policy                         | `IfNotPresent`   |
| `image.pullSecrets` | Image pull secrets                        | `[]`             |

### Deployment parameters

| Name                                 | Description                             | Value   |
| ------------------------------------ | --------------------------------------- | ------- |
| `replicaCount`                       | Number of replicas                      | `1`     |
| `podLabels`                          | Extra labels for pods                   | `{}`    |
| `podAnnotations`                     | Extra annotations for pods              | `{}`    |
| `podSecurityContext.enabled`         | Enable pod SecurityContext              | `false` |
| `containerSecurityContext.enabled`   | Enable container SecurityContext        | `false` |
| `resources`                          | Resource requests and limits            | `{}`    |
| `podAffinityPreset`                  | Pod affinity preset (soft or hard)      | `""`    |
| `podAntiAffinityPreset`              | Pod anti-affinity preset (soft or hard) | `soft`  |
| `nodeAffinityPreset.type`            | Node affinity preset type               | `""`    |
| `nodeAffinityPreset.key`             | Node label key to match                 | `""`    |
| `nodeAffinityPreset.values`          | Node label values to match              | `[]`    |
| `affinity`                           | Affinity for pod assignment             | `{}`    |
| `nodeSelector`                       | Node labels for pod assignment          | `{}`    |
| `tolerations`                        | Tolerations for pod assignment          | `[]`    |
| `topologySpreadConstraints`          | Topology spread constraints             | `[]`    |
| `readinessProbe.enabled`             | Enable readiness probe                  | `true`  |
| `readinessProbe.httpGet.path`        | Readiness probe path                    | `/`     |
| `readinessProbe.httpGet.port`        | Readiness probe port                    | `8081`  |
| `readinessProbe.initialDelaySeconds` | Initial delay seconds                   | `5`     |
| `readinessProbe.periodSeconds`       | Period seconds                          | `10`    |
| `livenessProbe.enabled`              | Enable liveness probe                   | `true`  |
| `livenessProbe.httpGet.path`         | Liveness probe path                     | `/`     |
| `livenessProbe.httpGet.port`         | Liveness probe port                     | `8081`  |
| `livenessProbe.initialDelaySeconds`  | Initial delay seconds                   | `10`    |
| `livenessProbe.periodSeconds`        | Period seconds                          | `10`    |

### PostgreSQL connection parameters

| Name                        | Description                                                                                                    | Value     |
| --------------------------- | -------------------------------------------------------------------------------------------------------------- | --------- |
| `postgresql.host`           | PostgreSQL server hostname                                                                                     | `""`      |
| `postgresql.port`           | PostgreSQL server port                                                                                         | `5432`    |
| `postgresql.database`       | Database name to connect to                                                                                    | `""`      |
| `postgresql.username`       | PostgreSQL username                                                                                            | `""`      |
| `postgresql.password`       | PostgreSQL password                                                                                            | `""`      |
| `postgresql.sslmode`        | SSL mode (disable, require, verify-ca, verify-full)                                                            | `disable` |
| `postgresql.existingSecret` | Use an existing secret containing the DATABASE_URL key (ignores host/port/database/username/password when set) | `""`      |

### Pgweb configuration

| Name                 | Description                                                                 | Value   |
| -------------------- | --------------------------------------------------------------------------- | ------- |
| `pgweb.readOnly`     | Enable read-only mode (prevents data modifications)                         | `false` |
| `pgweb.bookmarksDir` | Path to bookmarks directory                                                 | `""`    |
| `pgweb.sessions`     | Enable multiple database sessions                                           | `false` |
| `pgweb.lockSession`  | Lock the connection to the configured database (disables session switching) | `true`  |
| `extraEnvVars`       | Extra environment variables for the container                               | `{}`    |

### Traffic exposure parameters

| Name                               | Description                              | Value         |
| ---------------------------------- | ---------------------------------------- | ------------- |
| `service.type`                     | Kubernetes Service type                  | `ClusterIP`   |
| `service.labels`                   | Additional labels for service            | `{}`          |
| `service.annotations`              | Additional annotations for service       | `{}`          |
| `service.ports.http`               | Service port                             | `8081`        |
| `service.nodePorts.http`           | NodePort (when service type is NodePort) | `""`          |
| `service.clusterIP`                | Service Cluster IP                       | `""`          |
| `service.loadBalancerIP`           | LoadBalancer IP                          | `""`          |
| `service.loadBalancerSourceRanges` | Allowed source ranges for LoadBalancer   | `[]`          |
| `service.externalTrafficPolicy`    | External traffic policy                  | `Cluster`     |
| `ingress.enabled`                  | Enable ingress                           | `false`       |
| `ingress.annotations`              | Ingress annotations                      | `{}`          |
| `ingress.ingressClassName`         | Ingress class name                       | `""`          |
| `ingress.hostname`                 | Default hostname                         | `pgweb.local` |
| `ingress.path`                     | Default path                             | `/`           |
| `ingress.pathType`                 | Path type                                | `Prefix`      |
| `ingress.tls`                      | Enable TLS                               | `false`       |
| `ingress.selfSigned`               | Create self-signed TLS certificate       | `false`       |
| `ingress.existingSecret`           | Use existing TLS secret                  | `""`          |
| `ingress.extraHosts`               | Additional hosts                         | `[]`          |
| `ingress.extraPaths`               | Additional paths                         | `[]`          |
| `ingress.extraTls`                 | Extra TLS configuration                  | `[]`          |
| `ingress.extraRules`               | Additional ingress rules                 | `[]`          |

### ServiceAccount parameters

| Name                                          | Description                       | Value   |
| --------------------------------------------- | --------------------------------- | ------- |
| `serviceAccount.create`                       | Enable creation of ServiceAccount | `false` |
| `serviceAccount.name`                         | ServiceAccount name               | `""`    |
| `serviceAccount.annotations`                  | ServiceAccount annotations        | `{}`    |
| `serviceAccount.automountServiceAccountToken` | Auto mount token                  | `true`  |
