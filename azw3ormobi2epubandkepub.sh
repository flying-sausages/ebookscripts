#!/bin/bash
#Converts all azw3 and mobi to epub and kepub. Skips all books with k/epub versions (use script below afterwards)

#List entire library, trim all books with k/epub versions, and find only azw3 or mobi.
calibredb list -f formats -w 9999 | grep -v epub | grep 'azw3\|mobi' | while read -r line ; do
    id=$(echo "$line" | awk '{print $1}')
    echo "ID = $id"

    filepath=$(calibredb list --for-machine -f formats | jq " .[] | select (.id==$id)" | jq '.formats[0]' -r)
    fullname=$(basename "$filepath")
    filename="${fullname%.*}"
    
    #Make epub version
    ebook-convert "$filepath" /tmp/"$filename".epub --no-default-epub-cover --output-profile=tablet
    #Add Epub to calibre (optional, comment out if you don't want this)
    calibredb add_format "$id" /tmp/"$filename".epub
    
    #Make kepub version from epub
    kepubify "/tmp/$filename.epub" --calibre -o "/tmp/$filename.kepub"
    #Add kepub to calibre
    calibredb add_format "$id" /tmp/"$filename".kepub
done
