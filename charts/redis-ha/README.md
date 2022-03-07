# Redis HA

[Redis](http://redis.io/) is an advanced key-value cache and store. It is often referred to as a data structure server since keys can contain strings, hashes, lists, sets, sorted sets, bitmaps and hyperloglogs.

## Install

```sh
helm repo add sunasteriskrnd https://sun-asterisk-research.github.io/helm-charts
helm install my-release sunasteriskrnd/redis-ha
```

## Configuration parameters

The following tables lists the configurable parameters and their default values.

### Global parameters

| Parameter                 | Description                                     | Default |
|---------------------------|-------------------------------------------------|---------|
| `global.imageRegistry`    | Global Docker image registry                    | `nil`   |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`    |

### HAProxy parameters

| Parameter                                    | Description                                                                                                 | Default              |
|----------------------------------------------|-------------------------------------------------------------------------------------------------------------|----------------------|
| `nameOverride`                               | String to partially override `common.names.fullname` template with a string (will prepend the release name) | `""`                 |
| `fullnameOverride`                           | String to fully override `common.names.fullname` template with a string                                     | `""`                 |
| `haproxy.image.registry`                     | The image registry to be used                                                                               | `docker.io`          |
| `haproxy.image.repository`                   | The image repository to be used                                                                             | `metabase/metabase`  |
| `haproxy.image.tag`                          | The image tag to be used                                                                                    | `{METABASE_VERSION}` |
| `haproxy.image.pullPolicy`                   | Image pull policy                                                                                           | `IfNotPresent`       |
| `haproxy.image.pullSecrets`                  | Specify docker-registry secret names as an array                                                            | `[]`                 |
| `haproxy.replicaCount`                       | Number of Pods to run                                                                                       | `1`                  |
| `haproxy.updateStrategy`                     | Set up update strategy                                                                                      | `RollingUpdate`      |
| `haproxy.podSecurityContext`                 | Specify security context for pods                                                                           | `{}`                 |
| `haproxy.securityContext`                    | Specify security context for Metabase container                                                             | `{}`                 |
| `haproxy.timeout.connect`                    | haproxy.cfg `timeout connect` setting                                                                       | `4s`                 |
| `haproxy.timeout.server`                     | haproxy.cfg `timeout server` setting                                                                        | `30s`                |
| `haproxy.timeout.client`                     | haproxy.cfg `timeout client` setting                                                                        | `30s`                |
| `haproxy.timeout.check`                      | haproxy.cfg `timeout check` setting                                                                         | `2s`                 |
| `haproxy.check.interval`                     | haproxy.cfg `check inter` setting                                                                           | `1s`                 |
| `haproxy.check.fall`                         | haproxy.cfg `check fall` setting                                                                            | `1`                  |
| `haproxy.check.rise`                         | haproxy.cfg `check rise` setting                                                                            | `1`                  |
| `haproxy.service.type`                       | Service type                                                                                                | `ClusterIP`          |
| `haproxy.service.port`                       | Service port                                                                                                | `6379`               |
| `haproxy.service.nodePort`                   | Service node port                                                                                           | `""`                 |
| `haproxy.service.externalTrafficPolicy`      | Service external traffic policy                                                                             | `Cluster`            |
| `haproxy.service.clusterIP`                  | Service Cluster IP                                                                                          | `""`                 |
| `haproxy.service.loadBalancerIP`             | Service Load Balancer IP                                                                                    | `""`                 |
| `haproxy.service.loadBalancerSourceRanges`   | Service Load Balancer sources                                                                               | `[]`                 |
| `haproxy.livenessProbe.enabled`              | Enable livenessProbe HAProxy pods                                                                           | `true`               |
| `haproxy.livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                                                     | `30`                 |
| `haproxy.livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                                            | `10`                 |
| `haproxy.livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                                           | `5`                  |
| `haproxy.livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                                                         | `5`                  |
| `haproxy.livenessProbe.successThreshold`     | Success threshold for livenessProbe                                                                         | `1`                  |
| `haproxy.readinessProbe.enabled`             | Enable readinessProbe HAProxy pods                                                                          | `true`               |
| `haproxy.readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                                                    | `30`                 |
| `haproxy.readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                                           | `10`                 |
| `haproxy.readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                                                          | `1`                  |
| `haproxy.readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                                                        | `5`                  |
| `haproxy.readinessProbe.successThreshold`    | Success threshold for readinessProbe                                                                        | `1`                  |
| `haproxy.resources.limits`                   | The resources limits for HAProxy containers                                                                 | `{}`                 |
| `haproxy.resources.requests`                 | The requested resources for HAProxy containers                                                              | `{}`                 |
| `haproxy.podSecurityContext.enabled`         | Enabled HAProxy pods' Security Context                                                                      | `true`               |
| `haproxy.podSecurityContext.fsGroup`         | Set HAProxy pod's Security Context fsGroup                                                                  | `1001`               |
| `haproxy.containerSecurityContext.enabled`   | Enabled HAProxy containers' Security Context                                                                | `true`               |
| `haproxy.containerSecurityContext.runAsUser` | Set HAProxy containers' Security Context runAsUser                                                          | `1001`               |
| `haproxy.updateStrategy.type`                | HAProxy deployment strategy type                                                                            | `RollingUpdate`      |
| `haproxy.podAnnotations`                     | Annotations for HAProxy pods                                                                                | `{}`                 |
| `haproxy.shareProcessNamespace`              | Share a single process namespace between all of the containers in HAProxy pods                              | `false`              |
| `haproxy.podAffinityPreset`                  | Pod affinity preset. Ignored if `haproxy.affinity` is set. Allowed values: `soft` or `hard`                 | `""`                 |
| `haproxy.podAntiAffinityPreset`              | Pod anti-affinity preset. Ignored if `haproxy.affinity` is set. Allowed values: `soft` or `hard`            | `soft`               |
| `haproxy.nodeAffinityPreset.type`            | Node affinity preset type. Ignored if `haproxy.affinity` is set. Allowed values: `soft` or `hard`           | `""`                 |
| `haproxy.nodeAffinityPreset.key`             | Node label key to match. Ignored if `haproxy.affinity` is set                                               | `""`                 |
| `haproxy.nodeAffinityPreset.values`          | Node label values to match. Ignored if `haproxy.affinity` is set                                            | `[]`                 |
| `haproxy.affinity`                           | Affinity for HAProxy pods assignment                                                                        | `{}`                 |
| `haproxy.nodeSelector`                       | Node labels for HAProxy pods assignment                                                                     | `{}`                 |
| `haproxy.tolerations`                        | Tolerations for HAProxy pods assignment                                                                     | `[]`                 |
| `haproxy.spreadConstraints`                  | Topology spread Constraints for HAProxy pod assignment                                                      | `{}`                 |

### Redis&trade; parameters

See [bitnami/redis](https://github.com/bitnami/charts/tree/master/bitnami/redis) for all available values.
The following values are set by this chart.

| Parameter                              | Description                                       | Default       |
|----------------------------------------|---------------------------------------------------|---------------|
| `redis.architecture`                   | Redis&trade; architecture                         | `replication` |
| `redis.sentinel.enabled`               | Use Redis&trade; Sentinel on Redis&trade; pods    | `true`        |
| `redis.sentinel.downAfterMilliseconds` | Timeout for detecting a Redis&trade; node is down | `30000`       |
| `redis.sentinel.failoverTimeout`       | Timeout for performing an election failover       | `180000`      |

### Other Parameters

| Parameter                    | Description                                                        | Default |
|------------------------------|--------------------------------------------------------------------|---------|
| `serviceAccount.create`      | Specifies whether a ServiceAccount should be created               | `true`  |
| `serviceAccount.name`        | The name of the ServiceAccount to use.                             | `""`    |
| `serviceAccount.annotations` | Additional custom annotations for the ServiceAccount               | `{}`    |
| `pdb.create`                 | Specifies whether a PodDisruptionBudget should be created          | `false` |
| `pdb.minAvailable`           | Min number of pods that must still be available after the eviction | `1`     |
| `pdb.maxUnavailable`         | Max number of pods that can be unavailable after the eviction      | `""`    |
