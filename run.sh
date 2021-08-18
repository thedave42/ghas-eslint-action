#!/bin/sh

GITHUB_TOKEN='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'
GITHUB_REPOSITORY='thedave42/ghas-eslint-action'

REPO=${GITHUB_REPOSITORY#*/}

echo $REPO

#mkdir -p /home/runner/work/ghas-eslint-action
mkdir -p /home/runner/work/$REPO

#ln -s /github/workspace/. /home/runner/work/ghas-eslint-action/ghas-eslint-action
ln -s /github/workspace/. /home/runner/work/$REPO/$REPO 

/usr/bin/eslint -f @microsoft/eslint-formatter-sarif -o /tmp/eslint.sarif /home/runner/work/$REPO/$REPO/tests/.

DATA=`gzip -cf /tmp/eslint.sarif | base64 -w0`

echo $DATA

curl \
  -X POST \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Authorization: token $GITHUB_TOKEN" \
  https://api.github.com/repos/thedave42/ghas-eslint-action/code-scanning/sarifs \
  -d "{\"commit_sha\":\"3858cb716d1ec932d6cdaaaf6681f3653d0e81be\",\"ref\":\"refs/heads/main\",\"sarif\":\"$DATA\"}"
