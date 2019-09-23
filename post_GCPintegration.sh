#!/bin/bash

~/get_token.sh
source ~/.lwapi.conf

if  [ ! -f ~/project_list ]; then
    echo "List of projects missing, quitting!"
    exit 1
fi

while read line; do

PROJECT="$line"

curl -X POST \
  https://$LWHOST.lacework.net/api/v1/external/integrations \
  -H 'Accept: */*' \
  -H 'Accept-Encoding: deflate' \
  -H "Authorization: Bearer $BTOKEN" \
  -H 'Cache-Control: no-cache' \
  -H 'Connection: keep-alive' \
  -H 'Content-Type: application/json' \
  -H "Host: $LWHOST.lacework.net" \
  -H 'cache-control: no-cache' \
  -d '{
    "NAME": '\"$PROJECT\"',
    "TYPE": "GCP_CFG",
    "ENABLED": 1,
    "DATA": {
        "CREDENTIALS": {
            "CLIENT_ID": "",
            "PRIVATE_KEY_ID": "",
            "CLIENT_EMAIL": "",
            "PRIVATE_KEY": ""
        },
            "ID_TYPE": "PROJECT",
            "ID": '\"$PROJECT\"'
        }
    }'

done < ~/project_list