#!/bin/bash

#Remove all books that have a kepub version, and from that sublist take only epubs
calibredb list -f formats -w 9999 | grep -v kepub | grep epub | while read -r line ; do
    id=$(echo "$line" | awk '{print $1}')
    echo "ID = $id"

    filepath=$(calibredb list --for-machine -f formats | jq " .[] | select (.id==$id)" | jq '.formats[0]' -r)
    echo "$filepath"
    fullname=$(basename "$filepath")
    filename="${fullname%.*}"
    echo "$filename"
    
    kepubify "$filepath" -o "/tmp/$filename.kepub"
    calibredb add_format "$id" /tmp/"$filename".kepub

done