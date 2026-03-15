FROM alpine
LABEL org.opencontainers.image.title="db-transform" \
      org.opencontainers.image.description="Run PostgreSQL transforms on a cron schedule" \
      org.opencontainers.image.source="https://github.com/LPCORDOVA/db_transform"
WORKDIR /app
RUN apk --no-cache add postgresql18-client
COPY run.sh .
RUN chmod +x run.sh
CMD ["sh", "run.sh"]
