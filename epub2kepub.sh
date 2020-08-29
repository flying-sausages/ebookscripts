#!/bin/bash
#Quick epub to kepub conversion that skips all converted books

#List entire library, trim all books that have a kepub version, select only books with epub versions
calibredb list -f formats -w 9999 | grep -v kepub | grep epub | while read -r line ; do
    id=$(echo "$line" | awk '{print $1}')
    echo "ID = $id"
    
    filepath=$(calibredb list --for-machine -f formats | jq " .[] | select (.id==$id)" | jq '.formats' | jq '.[]' -r | grep epub | head -1)
    fullname=$(basename "$filepath")
    filename="${fullname%.*}"
    
    kepubify "$filepath" -o "/tmp/$filename.kepub"
    calibredb add_format "$id" /tmp/"$filename".kepub

done