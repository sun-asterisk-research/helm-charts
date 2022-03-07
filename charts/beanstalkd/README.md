# Beanstalkd

[beanstalkd](https://github.com/beanstalkd/beanstalkd) is a simple and fast general purpose work queue.

## Install

```sh
helm repo add sunasteriskrnd https://sun-asterisk-research.github.io/helm-charts
helm install my-release sunasteriskrnd/beanstalkd
```

## Parameters

The following tables lists the configurable parameters and their default values.

### Global parameters

| Parameter                 | Description                                     | Default |
|---------------------------|-------------------------------------------------|---------|
| `global.imageRegistry`    | Global Docker image registry                    | `nil`   |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`    |

### Common parameters

| Parameter          | Description                                                                                               | Default |
|--------------------|-----------------------------------------------------------------------------------------------------------|---------|
| `nameOverride`     | String to partially override `beanstalkd.fullname` template with a string (will prepend the release name) | `nil`   |
| `fullnameOverride` | String to fully override `beanstalkd.fullname` template with a string                                     | `nil`   |

### Beanstalkd parameters

| Parameter                 | Description                                                | Default                |
|---------------------------|------------------------------------------------------------|------------------------|
| `image.registry`          | The image registry to be used                              | `docker.io`            |
| `image.repository`        | The image repository to be used                            | `shickling/beanstalkd` |
| `image.tag`               | The image tag to be used                                   | `latest`               |
| `image.pullPolicy`        | Image pull policy                                          | `IfNotPresent`         |
| `image.pullSecrets`       | Specify docker-registry secret names as an array           | `[]`                   |
| `jobSize`                 | Maximum job size in bytes                                  | `65535`                |
| `binLogSize`              | Size in bytes of the binlog file                           | `10485760`             |
| `replicaCount`            | Number of Pods to run                                      | `1`                    |
| `updateStrategy`          | Set up update strategy                                     | `RollingUpdate`        |
| `podSecurityContext`      | Specify security context for pods                          | `{}`                   |
| `securityContext`         | Specify security context for laravel-echo-server container | `{}`                   |
| `resources.limits`        | The resources limits for the container                     | `{}`                   |
| `resources.requests`      | The requested resources for the container                  | `{}`                   |
| `nodeSelector`            | Node labels for pod assignment                             | `{}`                   |
| `tolerations`             | Tolerations for pod assignment                             | `[]`                   |
| `affinity`                | Affinity for pod assignment                                | `{}`                   |
| `podAnnotations`          | Pod annotations                                            | `{}`                   |
| `persistence.enabled`     | Enable persistent volume                                   | `true`                 |
| `persistence.accessModes` | Persistent volume access modes                             | `[ReadWriteOnce]`      |
| `persistence.size`        | Persistent volume size                                     | `100Mi`                |
| `service.type`            | Kubernetes Service type                                    | `ClusterIP`            |
| `service.port`            | Service HTTP port                                          | `11300`                |
