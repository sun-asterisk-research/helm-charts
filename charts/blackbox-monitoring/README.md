# Blackbox monitoring

Blackbox monitoring for websites and API endpoints with Apdex & alerting.

## Parameters

### Common parameters

| Name                | Description                                          | Value |
| ------------------- | ---------------------------------------------------- | ----- |
| `nameOverride`      | String to partially override `common.names.fullname` | `""`  |
| `fullnameOverride`  | String to fully override `common.names.fullname`     | `""`  |
| `commonLabels`      | Additional labels for resources                      | `{}`  |
| `commonAnnotations` | Additional annotations for resources                 | `{}`  |


### Monitoring parameters

| Name                                       | Description                                                                                                                                                                        | Value                                           |
| ------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------- |
| `targets`                                  | Monitoring targets                                                                                                                                                                 | `[]`                                            |
| `defaults.scrapeInterval`                  | Default scrape interval for targets                                                                                                                                                | `30s`                                           |
| `defaults.scrapeTimeout`                   | Default scrape timeout for targets                                                                                                                                                 | `30s`                                           |
| `apdex.T`                                  | T value for calculating apdex                                                                                                                                                      | `1`                                             |
| `alerting.enabled`                         | Enable alerting                                                                                                                                                                    | `false`                                         |
| `alerting.rules.endpointDown.enabled`      | Enable EndpointDown alert                                                                                                                                                          | `true`                                          |
| `alerting.rules.endpointDown.name`         | EndpointDown alert name                                                                                                                                                            | `EndpointDown`                                  |
| `alerting.rules.endpointDown.severity`     | EndpointDown alert severity                                                                                                                                                        | `critical`                                      |
| `alerting.rules.endpointDown.for`          | Durations before EndpointDown alert is sent to receivers                                                                                                                           | `30s`                                           |
| `alerting.rules.apdexLow.enabled`          | Enable ApdexLow alert                                                                                                                                                              | `true`                                          |
| `alerting.rules.apdexLow.name`             | ApdexLow alert name                                                                                                                                                                | `ApdexLow`                                      |
| `alerting.rules.apdexLow.severity`         | ApdexLow alert severity                                                                                                                                                            | `warning`                                       |
| `alerting.rules.apdexLow.threshold`        | ApdexLow alert threshold                                                                                                                                                           | `0.85`                                          |
| `alerting.rules.apdexLow.for`              | Durations before ApdexLow alert is sent to receivers                                                                                                                               | `5m`                                            |
| `alerting.receivers.slack.enabled`         | Enable Slack receiver                                                                                                                                                              | `false`                                         |
| `alerting.receivers.slack.api_url`         | Slack receiver API URL                                                                                                                                                             | `nil`                                           |
| `alerting.receivers.slack.channel`         | Slack receiver channel                                                                                                                                                             | `nil`                                           |
| `alerting.receivers.slack.title`           | Slack receiver alert title                                                                                                                                                         | `[{{ .Status }}] {{ .CommonLabels.alertname }}` |
| `alerting.receivers.slack.text`            | Slack receiver alert content (See values.yaml for default)                                                                                                                         | `""`                                            |
| `alerting.receivers.slack.send_resolved`   | Whether to send resolved message to Slack receiver                                                                                                                                 | `true`                                          |
| `alerting.receivers.webhook.enabled`       | Enable webhook receiver                                                                                                                                                            | `false`                                         |
| `alerting.receivers.webhook.url`           | URL to send webhook payloads                                                                                                                                                       | `nil`                                           |
| `alerting.receivers.webhook.max_alerts`    | Maximum number of alerts per payload to send                                                                                                                                       | `1`                                             |
| `alerting.receivers.webhook.send_resolved` | Whether to send resolved payload                                                                                                                                                   | `true`                                          |
| `alertmanagerConfig.route.group_by`        | Labels by which alerts are grouped together                                                                                                                                        | `["alertname"]`                                 |
| `alertmanagerConfig.route.group_interval`  | How long to wait before sending a notification about new alerts that are added to a group of alerts for which an initial notification has already been sent. (Usually ~5m or more) | `5m`                                            |
| `alertmanagerConfig.route.group_wait`      | How long to initially wait to send a notification for a group of alerts                                                                                                            | `30s`                                           |
| `alertmanagerConfig.route.repeat_interval` | How long to wait before sending a notification again if it has already been sent successfully for an alert                                                                         | `30m`                                           |


### Prometheus parameters

| Name                                            | Description                              | Value          |
| ----------------------------------------------- | ---------------------------------------- | -------------- |
| `prometheus.enabled`                            | Enable prometheus subchart               | `true`         |
| `prometheus.server.retention`                   | Time to retent probe metrics             | `30d`          |
| `prometheus.server.configMapOverrideName`       | Override configmap name for Prometheus   | `prometheus`   |
| `prometheus.server.service.servicePort`         | Prometheus service port                  | `9090`         |
| `prometheus.alertmanager.enabled`               | Enable alertmanager                      | `true`         |
| `prometheus.alertmanager.configMapOverrideName` | Override configmap name for Alertmanager | `alertmanager` |
| `prometheus.alertmanager.service.servicePort`   | Alertmanager service port                | `9093`         |


### Blackbox exporter parameters

| Name                                       | Description                                                     | Value   |
| ------------------------------------------ | --------------------------------------------------------------- | ------- |
| `blackbox-exporter.serviceMonitor.enabled` | Enable generating ServiceMonitor resource for Blackbox exporter | `false` |
| `blackbox-exporter.pspEnabled`             | Enable generation of PodSecurityPolicy resource                 | `false` |


### Grafana parameters

| Name                                                | Description                                                | Value                                                 |
| --------------------------------------------------- | ---------------------------------------------------------- | ----------------------------------------------------- |
| `grafana.enabled`                                   | Enable Grafana subchart                                    | `true`                                                |
| `grafana.plugins`                                   | Grafana plugins to install by default                      | `["natel-discrete-panel","neocat-cal-heatmap-panel"]` |
| `grafana.grafana.ini`                               | Grafana config file                                        | `{}`                                                  |
| `grafana.sidecar.dashboards.enabled`                | Enable dashboards watcher sidecar                          | `true`                                                |
| `grafana.sidecar.dashboards.provider.name`          | Grafana dashboards provider name                           | `kubernetes`                                          |
| `grafana.sidecar.dashboards.provider.disableDelete` | Disable deletion for dashboards provisioned by the sidecar | `true`                                                |
| `grafana.sidecar.dashboards.label`                  | ConfigMap label to watch for dashboards                    | `grafana/dashboard-for`                               |
| `grafana.sidecar.dashboards.labelValue`             | ConfigMap label value to watch for dashboards              | `blackbox-monitoring`                                 |
| `grafana.sidecar.datasources.enabled`               | Enable data sources watcher sidecar                        | `true`                                                |
| `grafana.sidecar.datasources.label`                 | ConfigMap label to watch for data sources                  | `grafana/datasource-for`                              |
| `grafana.sidecar.datasources.labelValue`            | ConfigMap label value to watch for data sources            | `blackbox-monitoring`                                 |
| `grafana.testFramework.enabled`                     | Enable Grafana subchart test framework                     | `false`                                               |
| `grafana.rbac.pspEnabled`                           | Enable generation of PodSecurityPolicy resource            | `false`                                               |


### External Prometheus config (for Grafana subchart data source)

| Name                               | Description                       | Value |
| ---------------------------------- | --------------------------------- | ----- |
| `externalPrometheus.url`           | External Prometheus URL           | `nil` |
| `externalPrometheus.auth.username` | External Prometheus auth username | `nil` |
| `externalPrometheus.auth.password` | External Prometheus auth password | `nil` |

