# Database Transformer

This repo is to serve as a template repository for setting up a Docker container that will run a specific PSQL script on whatever database is stored in the `$DATABASE_URL` environment variable. The `transform.sql` file should have valid SQL added for all operations that are desired.

## Railway deployment

Railway runs the container on a schedule. Set the **Cron Schedule** in the service **Settings** (e.g. `0 * * * *` for every hour); Railway does not use an environment variable for the schedule.

Set these variables when deploying:

| Variable        | Required | Default | Description                                                                 |
|----------------|----------|---------|-----------------------------------------------------------------------------|
| `DATABASE_URL` | Yes      | —       | PostgreSQL connection URL (e.g. `postgresql://user:pass@host:5432/dbname`).   |
| `DEBUG`        | No       | —       | Set to any non-empty value (e.g. `1` or `true`) to enable debug logging.   |

With `DEBUG` set, the container will log each run with timestamps and the output of the SQL script for easier troubleshooting.
