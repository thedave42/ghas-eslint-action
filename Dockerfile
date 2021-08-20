FROM ghcr.io/thedave42/docker-eslint-sarif:0.0.10

COPY run.sh /run.sh

ENTRYPOINT ["/bin/sh", "/run.sh"]