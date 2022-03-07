# Service account

Utility Helm chart for creating a service account for accessing the namespace from an automated system (e.g. CI/CD).

## Parameters

| Paramter                     | Description                                              | Default |
|------------------------------|----------------------------------------------------------|---------|
| `nameOverride`               | String to partially override the subchart fullname       | `nil`   |
| `fullnameOverride`           | String to override the subchart fullname                 | `nil`   |
| `serviceAccount.annotations` | Annotations for the ServiceAccount                       | `{}`    |
| `role.kind`                  | The role kind (`Role` or `ClusterRole`)                  | `Role`  |
| `role.rules`                 | Rules for the ServiceAccount's binded role               | `[]`    |
| `role.rulesPreset`           | The rules preset                                         | `nil`   |
| `existingRole.kind`          | Existing role kind to bind instead of creating a new one | `nil`   |
| `existingRole.name`          | Existing role name to bind instead of creating a new one | `nil`   |

## Presets

The following presets are available

### `deployer`

A service account for deploying from automated system (e.g. CI/CD).

```yaml
- apiGroups:
  - ''
  resources:
  - configmaps
  - pods
  - secrets
  - serviceaccounts
  - services
  - persistentvolumeclaims
  verbs:
  - '*'
- apiGroups:
  - apps
  - autoscaling
  - cert-manager.io
  - extensions
  - networking.k8s.io
  - rbac.authorization.k8s.io
  - batch/v1beta1
  - monitoring.coreos.com
  resources:
  - '*'
  verbs:
  - '*'
```
