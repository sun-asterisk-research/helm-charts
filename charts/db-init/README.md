# Database init

Utility Helm chart for creating databases with users and configured privileges.

## Configuration parameters

| Parameter                    | Description                                                                         | Default        |
|------------------------------|-------------------------------------------------------------------------------------|----------------|
| `image.registry`             | Default image registry                                                              | `docker.io`    |
| `image.pullPolicy`           | Default image pull policy                                                           | `IfNotPresent` |
| `image.pullSecrets`          | Default image pull secrets                                                          | `[]`           |
| `dbType`                     | Database type                                                                       | `mysql`        |
| `users`                      | List of users to create                                                             | `[]`           |
| `users.*.username`           | Username for the user to create                                                     | `nil`          |
| `users.*.password`           | Password for the user to create                                                     | `nil`          |
| `users.*.forcePassword`      | Whether to force a password for this user (a random one will be created if not set) | `false`        |
| `databases`                  | List of databases to create                                                         | `{}`           |
| `databases[name].owner`      | Database owner username                                                             | `nil`          |
| `databases[name].readonly`   | List of users with readonly privilege on this database                              | `[]`           |
| `databases[name].readwrite`  | List of users with readwrite privilege on this database                             | `[]`           |
| `databases[name].extensions` | List of database extensions to create (PostgreSQL only)                             | `[]`           |

## MySQL/MariaDB paramaters

| Parameter                 | Description                | Default                |
|---------------------------|----------------------------|------------------------|
| `mysql.image.registry`    | MySQL image registry       | `docker.io`            |
| `mysql.image.repository`  | MySQL image repository     | `bitnami/mariadb`      |
| `mysql.image.tag`         | MySQL image tag            | `10.5.12-debian-10-r9` |
| `mysql.image.pullPolicy`  | MySQL image pull policy    | `IfNotPresent`         |
| `mysql.image.pullSecrets` | MySQL image pull secrets   | `[]`                   |
| `mysql.host`              | MySQL server host          | `localhost`            |
| `mysql.port`              | MySQL server port          | `3306`                 |
| `mysql.rootUser`          | MySQL server root user     | `root`                 |
| `mysql.rootPassword`      | MySQL server root password | `nil`                  |

## PostgreSQL parameters

| Parameter                      | Description                         | Default               |
|--------------------------------|-------------------------------------|-----------------------|
| `postgresql.image.registry`    | PostgreSQL image registry           | `docker.io`           |
| `postgresql.image.repository`  | PostgreSQL image repository         | `bitnami/postgresql`  |
| `postgresql.image.tag`         | PostgreSQL image tag                | `13.4.0-debian-10-r3` |
| `postgresql.image.pullPolicy`  | PostgreSQL image pull policy        | `IfNotPresent`        |
| `postgresql.image.pullSecrets` | PostgreSQL image pull secrets       | `[]`                  |
| `postgresql.host`              | PostgreSQL server host              | `localhost`           |
| `postgresql.port`              | PostgreSQL server port              | `3306`                |
| `postgresql.postgresPassword`  | PostgreSQL `postgres` user password | `nil`                 |

## Example

This example creates the db `mydb` with an owner, sepearate user with read/write privileges and two extensions.

```yaml
dbType: postgresql

postgresql:
  host: localhost
  port: 5432
  postgresPassword: secret

users:
- username: mydb_owner
  password: secret1
- username: mydb_reader
  password: secret2
- username: mydb_writer
  password: secret3

databases:
  mydb:
    owner: mydb_owner
    readonly:
    - mydb_reader
    readwrite:
    - mydb_writer
    extensions:
    - pg_stat_kcache
    - pg_stat_statements
```
