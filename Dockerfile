FROM alpine:3.13.0


WORKDIR /app
RUN apk add --no-cache postgresql-client  && \
    rm -rf /var/cache/apk/*

COPY run.sh run.sh
COPY mc /usr/local/bin/mc
COPY go-cron /usr/local/bin/go-cron
COPY backup.sh backup.sh
RUN chmod +x  /usr/local/bin/mc && chmod +x /usr/local/bin/go-cron

RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

CMD ["sh", "run.sh"]
