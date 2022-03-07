# Docker login secret

Helm chart for creating docker login secret for pulling private docker images.

## Parameters

| Parameter                | Description                                        | Default |
|--------------------------|----------------------------------------------------|---------|
| `nameOverride`           | String to partially override the subchart fullname | `nil`   |
| `fullnameOverride`       | String to override the subchart fullname           | `nil`   |
| `registries[0].server`   | Registry server                                    | `nil`   |
| `registries[0].username` | Registry username                                  | `nil`   |
| `registries[0].password` | Registry password                                  | `nil`   |
