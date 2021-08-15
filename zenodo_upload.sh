#!/bin/bash
# Upload big files to Zenodo.
#
# usage: ./zenodo_upload.sh [deposition id] [filename]
#

set -e

if [ -z "$1" ]; then
    echo "Dposition ID not given."
    exit 1
fi
if [ -z "$2" ]; then
    echo "File not given."
    exit 1
fi

ZENODO_TOKEN=$(cat ~/.zenodo)

# strip deposition url prefix if provided; see https://github.com/jhpoelen/zenodo-upload/issues/2#issuecomment-797657717
DEPOSITION=$( echo $1 | sed 's+^http[s]*://zenodo.org/deposit/++g' )
FILEPATH="$2"
FILENAME=$(echo $FILEPATH | sed 's+.*/++g')

BUCKET=$(curl -H @<(echo -e "Accept: application/json\nAuthorization: Bearer $ZENODO_TOKEN") "https://www.zenodo.org/api/deposit/depositions/$DEPOSITION" | jq --raw-output .links.bucket)


curl --progress-bar -o /dev/null -H @<(echo -e "Authorization: Bearer $ZENODO_TOKEN") --upload-file "$FILEPATH" $BUCKET/"$FILENAME"
