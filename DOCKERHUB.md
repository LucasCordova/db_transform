# db-transform

Runs a PostgreSQL SQL script against a database. Ideal for one-off or scheduled transforms (e.g. cron, Kubernetes CronJob, Railway cron).

**What it does:** Reads `TRANSFORM_SQL` → connects to PostgreSQL via `DATABASE_URL` → executes the SQL → exits.

Multi-line SQL is fully supported. Change the SQL anytime via environment variables — no rebuild needed.

---

## Quick start

```bash
docker run --rm \
  -e DATABASE_URL="postgresql://user:password@host:5432/mydb" \
  -e TRANSFORM_SQL="SELECT NOW();" \
  lucascordova/db-transform
```

---

## Pull the image

```bash
docker pull lucascordova/db-transform
```

---

## Environment variables

| Variable | Required | Description |
|----------|----------|-------------|
| `DATABASE_URL` | **Yes** | PostgreSQL connection string (`postgresql://user:pass@host:port/dbname`). |
| `TRANSFORM_SQL` | **Yes** | SQL to execute. Multi-line supported. |
| `DEBUG` | No | Set to `true` or `1` to log timestamps and full `psql` output. Default: `false`. |

---

## Using an env file

```bash
docker run --rm --env-file .env lucascordova/db-transform
```

Example `.env`:

```env
DATABASE_URL=postgresql://user:secret@db.example.com:5432/etl
TRANSFORM_SQL=START TRANSACTION;
  UPDATE users SET active = false WHERE last_login < NOW() - INTERVAL '1 year';
COMMIT;
DEBUG=false
```

---

## Example: run on a schedule

With host cron:

```bash
0 * * * * docker run --rm --env-file /path/to/.env lucascordova/db-transform
```

Or use the same image as the job container in a Kubernetes CronJob or Railway cron service.

---

## Source

GitHub: [repository URL]

Replace `lucascordova` with your actual Docker Hub username or organization.
