#!/bin/bash

if [ -f ~/.lwapi.conf ]; then
    source ~/.lwapi.conf
else
    echo "BTOKEN=\"empty\"" > ~/.lwapi.conf
    chmod 600 ~/.lwapi.conf
    source ~/.lwapi.conf
fi

if [[ -z $BTOKEN ]]; then
    echo "BTOKEN=\"empty\"" >> ~/.lwapi.conf
fi

if [[ -z $LWHOST ]]; then
    printf "Enter the Lacework portal name> "
    read LWHOST
    echo "LWHOST=\"$LWHOST\"" >> ~/.lwapi.conf
fi

if [[ -z $LWSKEY ]]; then 
    printf "Enter your Lacework secret key> "
    read LWSKEY
    echo "LWSKEY=\"$LWSKEY\"" >> ~/.lwapi.conf
fi

if [[ -z $LWAKEY ]]; then
    printf "Enter your Lacework access key> "
    read LWAKEY
    echo "LWAKEY=\"$LWAKEY\"" >> ~/.lwapi.conf
fi

LWTOKEN=`curl -s -X POST \
  https://$LWHOST.lacework.net/api/v1/access/tokens \
  -H 'Accept: */*' \
  -H 'Cache-Control: no-cache' \
  -H 'Connection: keep-alive' \
  -H 'Content-Type: application/json' \
  -H "Host: $LWHOST.lacework.net" \
  -H "X-LW-UAKS: $LWSKEY" \
  -H 'accept-encoding: deflate' \
  -H 'cache-control: no-cache' \
  -H 'content-length: 95' \
  -d "{
  \"keyId\": \"$LWAKEY\",
  \"expiryTime\": 3600
}" | grep token | cut -d',' -f 2 | cut -d":" -f 2 | tr -d '"}]'`

sed -i ""  "s/BTOKEN=\".*\"/BTOKEN=\"$LWTOKEN\"/" ~/.lwapi.conf
