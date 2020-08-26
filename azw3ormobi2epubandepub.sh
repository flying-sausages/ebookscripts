#!/bin/bash
#Converts all non-epub or kepub reflowable books 


#Remove all k/epub books, and find only azw3 or mobi.
calibredb list -f formats -w 9999 | grep -v epub | grep 'azw3\|mobi' | while read -r line ; do
    id=$(echo "$line" | awk '{print $1}')
    echo "ID = $id"

    filepath=$(calibredb list --for-machine -f formats | jq " .[] | select (.id==$id)" | jq '.formats[0]' -r)
    echo "$filepath"
    fullname=$(basename "$filepath")
    filename="${fullname%.*}"
    echo "$filename"

    ebook-convert "$filepath" /tmp/"$filename".epub --no-default-epub-cover --output-profile=tablet
    kepubify "/tmp/$filename.epub" -o "/tmp/$filename.kepub"
    calibredb add_format "$id" /tmp/"$filename".epub
    calibredb add_format "$id" /tmp/"$filename".kepub
done