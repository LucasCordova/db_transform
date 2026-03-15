# Database Transformer

A lightweight Docker container that runs a PostgreSQL script against a database. Designed to be deployed as a **Railway template** on a cron schedule — set your SQL in an environment variable, no redeploy needed to change it.

## Quick Start (Railway Template)

1. **Deploy the template** from the Railway template link.
2. **Set variables** when prompted (see below).
3. **Set a cron schedule** in Service Settings (e.g. `0 * * * *` for hourly).

That's it. The container runs your SQL on schedule and exits.

## Environment Variables

| Variable | Required | Description |
|---|---|---|
| `DATABASE_URL` | Yes | PostgreSQL connection URL (e.g. `postgresql://user:pass@host:5432/dbname`). |
| `TRANSFORM_SQL` | Yes | The SQL to execute each run. Multi-line supported. Edit anytime in Railway Variables — no redeploy needed. |
| `DEBUG` | No | Set to `1` for timestamped verbose logging with full `psql` output. |

## How It Works

1. Container starts and reads `TRANSFORM_SQL` from the environment.
2. Pipes the SQL to `psql` using the `DATABASE_URL` connection string.
3. Exits. Railway's cron scheduler handles the next run.

The SQL runs exactly as written — wrap in `START TRANSACTION; ... COMMIT;` if you want transactional execution.

## Docker Hub

### Build and push

```bash
docker build --platform linux/amd64 -t youruser/db-transform:latest .
docker push youruser/db-transform:latest
```

### Run locally

```bash
docker run --rm \
  -e DATABASE_URL="postgresql://user:pass@host:5432/dbname" \
  -e TRANSFORM_SQL="SELECT NOW();" \
  -e DEBUG=1 \
  youruser/db-transform:latest
```

## Creating the Railway Template

1. Push the image to Docker Hub.
2. Go to [railway.com/button](https://railway.com/button) and create a new template.
3. Add a service using your Docker Hub image.
4. In the template's **Variables** section, define:
   - `DATABASE_URL` — required
   - `TRANSFORM_SQL` — required
   - `DEBUG` — optional
5. Set a default **Cron Schedule** in the service settings.
6. Publish the template.

Users deploying your template will be prompted for the required variables automatically.
