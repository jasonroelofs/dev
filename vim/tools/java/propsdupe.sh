#!/bin/sh
if [ -z "$1" ]; then
  echo "(Displays duplicate keys in a properties file)"
  echo "Usage: propsdupe.sh <propertiesfile>"
	exit 1
fi
cat $1 | awk -F "=" '{print $1}' | grep -v "^$" | grep -v "\s*#" | sort | uniq -d
