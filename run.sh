#!/bin/sh

REPO=${GITHUB_REPOSITORY#*/}
TIMESTAMP=`date -u +"%Y-%m-%dT%H:%M:%SZ"`
SRC_DIR=$1; shift
ESLINT_OPTS=$@

# example on how to get last n chars from string
# str = "Test"
# ${str: -2}  # displays 'st'

# If there's a SARIF_CATEGORY make sure it ends in /
if [ ! -z "$SARIF_CATEGORY" ]
then
  if [ ! "${SARIF_CATEGORY:-1}" = "/" ]
  then
    SARIF_CATEGORY="$SARIF_CATEGORY/"
  fi
fi

AUTOMATION_ID="$SARIF_CATEGORY$GITHUB_RUN_ID"

cd /github/workspace/$SRC_DIR
/usr/bin/eslint -f @microsoft/eslint-formatter-sarif -o $GITHUB_RUN_ID.sarif $ESLINT_OPTS . || exit 0
jq --arg a $AUTOMATION_ID '.runs[0] |= . + {"automationDetails": {"id": $a}}' $GITHUB_RUN_ID.sarif > $GITHUB_JOB.sarif
if [ $? -ne 0 ]
then
  echo Failed with error code $?
  exit $?
fi

# Command to add 'category' to SARIF file
# jq --arg a $AUTOMATION_ID '.runs[0] |= . + {"automationDetails": {"id": $a}}' eslint.sarif

DATA=`gzip -cf $GITHUB_JOB.sarif | base64 -w0`

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
        \"tool_name\":\"GHAS ESLint Action\", \
        \"sarif\":\"$DATA\" \
      }" 
