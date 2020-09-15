#!/bin/bash
# I had a script that incorrectly made copies of epubs to the kepubs instead of copying them. Here is 


calibrelib="$HOME/Calibre Library"

for artistdir in "$calibrelib"/*/; do
    # echo "$artistdir"
    for bookdir in "$artistdir"/*; do
    # echo "  $bookdir"
        epub=$(find "$bookdir" | grep -F .epub)
        kepub=$(find "$bookdir" | grep -F .kepub)
        if [[ -f $kepub ]]; then 
            if [[ $(diff -sq "$epub" "$kepub") ]]; then 
                echo "    File $kepub is identical to epub"
                # rm "$kepub"
            fi 
        fi
    done
done
