FROM ghcr.io/thedave42/docker-eslint-sarif:0.0.6

COPY run.sh .

ENTRYPOINT ["run.sh"]