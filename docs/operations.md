# Nango local operations

The package binds Nango only to `127.0.0.1:3003` and Connect UI only to
`127.0.0.1:3009`. The first start generates secrets into `.state/nango.env`
and starts the `lasso-nango` Docker Compose project.

To stop it, use the Service Lasso lifecycle stop action. The wrapper runs
`docker compose down --remove-orphans` without `--volumes`, preserving
`data/postgres` and the generated local credentials.

To intentionally reset a local Nango instance, stop it first and delete the
service's persisted data through an operator-approved recovery procedure. That
destructive operation is deliberately not an action supplied by this package.
