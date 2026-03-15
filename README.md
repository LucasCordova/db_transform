# db-transform

A lightweight container that runs a PostgreSQL SQL script against a database. Useful for one-off or scheduled transforms (e.g. via cron, Railway cron, or Kubernetes CronJob).

## What it does

1. **Reads** the `TRANSFORM_SQL` environment variable (multi-line SQL supported).
2. **Connects** to PostgreSQL via `DATABASE_URL`.
3. **Executes** the SQL and exits.

The SQL runs exactly as written. Wrap in `START TRANSACTION; ... COMMIT;` for transactional execution.

## Environment variables

| Variable | Required | Description |
|---|---|---|
| `DATABASE_URL` | Yes | PostgreSQL connection string (e.g. `postgresql://user:pass@host:5432/dbname`). |
| `TRANSFORM_SQL` | Yes | SQL to execute each run. Multi-line supported. Edit anytime in Railway Variables — no redeploy needed. |
| `DEBUG` | No | Set to `true` or `1` for timestamped verbose logging with full `psql` output. Default: `false`. |

## Running with Docker

Build and run with environment variables:

```bash
docker build -t db-transform .
docker run --rm \
  -e DATABASE_URL="postgresql://user:password@host:5432/mydb" \
  -e TRANSFORM_SQL="SELECT NOW();" \
  -e DEBUG=true \
  db-transform
```

Or use an env file:

```bash
docker run --rm --env-file .env db-transform
```

## Example `.env`

```env
DATABASE_URL=postgresql://user:secret@db.example.com:5432/etl
TRANSFORM_SQL=START TRANSACTION;
  UPDATE users SET active = false WHERE last_login < NOW() - INTERVAL '1 year';
COMMIT;
DEBUG=false
```

## Running on a schedule

With host cron:

```bash
0 * * * * docker run --rm --env-file /path/to/.env lucascordova/db-transform
```

Or use the same image as the job container in a Kubernetes CronJob.

## Railway deployment

1. Deploy from the Railway template or connect the repo.
2. Set `DATABASE_URL` and `TRANSFORM_SQL` in Railway Variables.
3. Optionally set `DEBUG=true`.
4. Set a **Cron Schedule** in Service Settings (e.g. `0 * * * *` for hourly).

Change the SQL anytime in Railway Variables — no redeploy needed.

## License

See repository for license information.
