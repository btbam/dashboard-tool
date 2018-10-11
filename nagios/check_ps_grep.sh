#!/bin/bash
OK=0
WARNING=1
CRITICAL=2
UNKNOWN=3

ps -ef | grep -v grep | grep "$1" 2>&1

STATUS=$?
if [ "$STATUS" = 0 ]; then
  exit $OK
elif [ "$STATUS" = 1 ]; then
  echo "$1 is not running!"
  exit $CRITICAL
else
  echo "An unknown error occurred."
  exit $UNKNOWN
fi
