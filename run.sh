#!/bin/sh

REPO=${GITHUB_REPOSITORY#*/}
TIMESTAMP=`date -u +"%Y-%m-%dT%H:%M:%SZ"`
SRC_DIR=$1; shift
ESLINT_OPTS=$@

cd /github/workspace/$SRC_DIR
npm i

cd /github/workspace
/usr/bin/eslint -f @microsoft/eslint-formatter-sarif -o eslint.sarif --resolve-plugins-relative-to /github/workspace/$SRC_DIR $ESLINT_OPTS $SRC_DIR

DATA=`gzip -cf eslint.sarif | base64 -w0`

echo $DATA

curl \
  -X POST \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Authorization: token $GITHUB_TOKEN" \
  https://api.github.com/repos/thedave42/$REPO/code-scanning/sarifs \
  -d "{ \
        \"commit_sha\":\"$GITHUB_SHA\", \
        \"ref\":\"$GITHUB_REF\", \
        \"checkout_uri\":\"file:///github/workspace\", \
        \"started_at\":\"$TIMESTAMP\", \
        \"sarif\":\"$DATA\" \
      }" 
