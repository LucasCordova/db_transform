FROM alpine
WORKDIR /app
RUN apk --no-cache add postgresql18-client
COPY transform.sql run.sh .
CMD ["sh", "run.sh"]
