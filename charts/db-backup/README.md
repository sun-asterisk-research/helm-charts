# Database backup

Utility Helm chart for creating a database backup

## Parameters

| Parameter                    | Description                                        | Default                              |
|------------------------------|----------------------------------------------------|--------------------------------------|
| `image.repository`           | Database backup docker image repository            | `docker.io/sunasteriskrnd/db-backup` |
| `image.tag`                  | Database backup docker images tag                  | `latest`                             |
| `image.imagePullPolicy`      | Database backup docker images pull policy          | `IfNotPresent`                       |
| `jobs.name`                  | Name of Cronjob                                    | `db-backup`                          |
| `jobs.dbType`                | Type of database                                   | `nil`                                |
| `jobs.dbHost`                | Database hostname                                  | `nil`                                |
| `jobs.dbPost`                | Database custom port                               | `nil`                                |
| `jobs.dbName`                | Name of Database                                   | `nil`                                |
| `jobs.dbUser`                | Database custom user                               | `nil`                                |
| `jobs.dbPassword`            | Database custom user password                      | `nil`                                |
| `jobs.dbBackupMaxFiles`      | Database backup max files                          | `10`                                 |
| `jobs.timezone`              | Set the timezone in container cronjob              | `UTC`                                |
| `persistence.enabled`        | Enable Database backup persistence using PVC       | `true`                               |
| `persistence.accessMode`     | PVC Access Mode for database backup volume         | `ReadWriteOnce`                      |
| `persistence.size`           | PVC Storage Request for database backup volume     | `1GB`                                |
