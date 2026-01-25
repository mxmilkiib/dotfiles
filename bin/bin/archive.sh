#!/bin/bash

URL=$1
PATH=$2
EXCLUDE=$3

rm -rf "$URL"
mkdir "$URL"

echo "Gathering URLs..."

wget -q -r -nc "$URL$PATH" -D "$URL" # -X "$EXCLUDE"

echo "Sending to archive.org..."

find "$URL" -type f -print0 | while IFS= read -r -d $'\0' LINE; do
    echo "Saving $LINE"
    curl -s "https://web.archive.org/save/$LINE" > /dev/null &
    sleep 1
done

echo "Done"

rm -rf "$URL"
