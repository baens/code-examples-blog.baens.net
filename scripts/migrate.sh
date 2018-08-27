#!/bin/bash

MAX_RETRY=10
RETRY_SLEEP_AMOUNT=1 # in seconds

# Verify that we have a apt cache
if ! [ "$(ls -A /var/lib/apt/lists)" ]; then
    apt-get update
fi

# Install Netcat to check for open ports
if ! [ -x "$(command -v nc)" ]; then
    apt-get install netcat -y
fi

function checkService {
    local dnsName=$1
    local port=$2
    local printName="$dnsName:$port"

    echo "Waiting $((MAX_RETRY * RETRY_SLEEP_AMOUNT)) seconds for service on $printName to come up"

    local counter=0
    until nc -z $dnsName $port; do
      if (( $counter > $MAX_RETRY )); then
        echo "$printName did not come up in the acceptable amount of time, exiting"
        exit 1;
      fi;

      echo "Service $printName is not available - sleeping"
      sleep $RETRY_SLEEP_AMOUNT
      ((counter+=1))
    done
}

checkService database 5432
checkService vault 8200
