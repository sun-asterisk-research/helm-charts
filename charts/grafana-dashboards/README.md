# Grafana dashboards

A collection of grafana dashboards. Can be used with dashboard provisioning.

## Datasource requirements

These dashboards assumes you have certain data sources with specific name:

- Prometheus

## Parameters

### Common parameters

| Name                | Description                                          | Value |
| ------------------- | ---------------------------------------------------- | ----- |
| `nameOverride`      | String to partially override `common.names.fullname` | `""`  |
| `fullnameOverride`  | String to fully override `common.names.fullname`     | `""`  |
| `commonLabels`      | Additional labels for dashboards                     | `{}`  |
| `commonAnnotations` | Additional annotations for dashboards                | `{}`  |

### Dashboards parameters

| Name                       | Description                                                               | Value                                      |
| -------------------------- | ------------------------------------------------------------------------- | ------------------------------------------ |
| `defaultDashboards`        | Dashboards included by default                                            | `["kubernetes-resources","node-exporter"]` |
| `includeDefaultDashboards` | Whether to include default dashboards when extra dashboards is set        | `true`                                     |
| `dashboards`               | Extra dashboards to include                                               | `[]`                                       |
| `folderAnnotation`         | Annotation to put folder name on, can be used for dashboards provisioning | `nil`                                      |
