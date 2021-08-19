# Adapted from https://github.com/cytopia/docker-eslint
# by cytopia <cytopia@everythingcli.org>
#
FROM alpine:latest as builder

RUN set -eux \
	&& apk add --no-cache \
		nodejs-current \
		npm

WORKDIR /eslint
COPY ./ /eslint
RUN set -eux \
	&& npm install global --production --remove-dev eslint @microsoft/eslint-formatter-sarif \
	&& /eslint/node_modules/eslint/bin/eslint.js --version | grep -E '^v?[0-9]+'

# Remove unecessary files
RUN set -eux \
	&& find /eslint/node_modules -type d -iname 'test' -prune -exec rm -rf '{}' \; \
	&& find /eslint/node_modules -type d -iname 'tests' -prune -exec rm -rf '{}' \; \
	&& find /eslint/node_modules -type d -iname 'testing' -prune -exec rm -rf '{}' \; \
	&& find /eslint/node_modules -type d -iname '.bin' -prune -exec rm -rf '{}' \; \
	\
	&& find /eslint/node_modules -type f -iname '.*' -exec rm {} \; \
	&& find /eslint/node_modules -type f -iname 'LICENSE*' -exec rm {} \; \
	&& find /eslint/node_modules -type f -iname 'Makefile*' -exec rm {} \; \
	&& find /eslint/node_modules -type f -iname '*.bnf' -exec rm {} \; \
	&& find /eslint/node_modules -type f -iname '*.css' -exec rm {} \; \
	&& find /eslint/node_modules -type f -iname '*.def' -exec rm {} \; \
	&& find /eslint/node_modules -type f -iname '*.flow' -exec rm {} \; \
	&& find /eslint/node_modules -type f -iname '*.html' -exec rm {} \; \
	&& find /eslint/node_modules -type f -iname '*.info' -exec rm {} \; \
	&& find /eslint/node_modules -type f -iname '*.jst' -exec rm {} \; \
	&& find /eslint/node_modules -type f -iname '*.lock' -exec rm {} \; \
	&& find /eslint/node_modules -type f -iname '*.map' -exec rm {} \; \
	&& find /eslint/node_modules -type f -iname '*.markdown' -exec rm {} \; \
	&& find /eslint/node_modules -type f -iname '*.md' -exec rm {} \; \
	&& find /eslint/node_modules -type f -iname '*.mjs' -exec rm {} \; \
	&& find /eslint/node_modules -type f -iname '*.mli' -exec rm {} \; \
	&& find /eslint/node_modules -type f -iname '*.png' -exec rm {} \; \
	&& find /eslint/node_modules -type f -iname '*.ts' -exec rm {} \; \
	&& find /eslint/node_modules -type f -iname '*.yml' -exec rm {} \;

FROM alpine:latest
LABEL \
	maintainer="the Dave <dave@digitalnosie.net>" \
	repo="https://github.com/cytopia/docker-eslint"
COPY --from=builder /eslint/node_modules/ /node_modules/
RUN set -eux \
	&& apk add --no-cache nodejs-current curl gzip\
	&& ln -sf /node_modules/eslint/bin/eslint.js /usr/bin/eslint