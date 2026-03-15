ARG RELEASE=22.04
FROM ubuntu:${RELEASE}

LABEL org.opencontainers.image.ref.name="ubuntu"
LABEL org.opencontainers.image.version="22.04"

WORKDIR /app

RUN apt-get update && \
    apt-get install -y postgresql-client && \
    apt-get clean

COPY run.sh .
COPY transform.sql .

RUN chmod +x run.sh

CMD ["bash", "run.sh"]
