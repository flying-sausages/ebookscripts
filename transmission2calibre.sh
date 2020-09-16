#! /bin/bash
# Username for transmission remote.
TR_USERNAME="<username>"
# Password for transmission remote.
TR_PASSWORD="<password>"
# The location of the transmission rpc endpoint relative to where it's started from
TR_HOST="https://localhost/transmission/rpc"
#Where to write the log file for troubleshooting (could be /dev/null if you don't want this)
log="$HOME/tr.log"

# Move torrent to tracker-based directory
TRACKER=$(transmission-remote $TR_HOST -n "$TR_USERNAME":"$TR_PASSWORD" -t$TR_TORRENT_ID -it | sed -n -e '/[:]/p' | head -1 | awk '{print substr($0, index($0,$3))}' | awk -F[/:] '{print $4}')
echo "Tracker = ${TRACKER}" >> "$log" 2>&1
mvdir="${TR_TORRENT_DIR}/${TRACKER}"
echo "mvdir = $mvdir" >> "$log" 2>&1
if [[ ! -d "$mvdir" ]]; then
	mkdir -p "$mvdir"
fi
transmission-remote $TR_HOST -n "$TR_USERNAME":"$TR_PASSWORD" -t$TR_TORRENT_ID --move "$mvdir"


#Convert torrent to ebooks I want
echo "TN = $TR_TORRENT_NAME" >> "$log" 2>&1
ext="${TR_TORRENT_NAME##*.}"
echo "Orig. extension = ${ext,,}" >> "$log" 2>&1

lockfile="/tmp/calibredb.lock"

if [[ "${ext,,}" =~ (epub|mobi|azw3|cbz|cb7|cbr|pdf) ]]; then

	file=$(basename -- "$TR_TORRENT_NAME")
	filename="${file%.*}"
	echo "Filename = $filename" >> "$log" 2>&1
	clbdr="/tmp/$filename"
	echo "clbdr = $clbdr"  >> "$log" 2>&1
	mkdir -p "$clbdr"

	cp "$mvdir/$TR_TORRENT_NAME" "$clbdr"  >> "$log" 2>&1

    #Convert mobis and azw3 to epub and add to final folder
	if [[ "${ext,,}" =~ (mobi|azw3) ]]; then
		/opt/calibre/ebook-convert "$clbdr/$TR_TORRENT_NAME" "$clbdr/$filename.epub" --no-default-epub-cover --output-profile=tablet >> "$log" 2>&1
	fi

    # Convert comic archives to epub, then straight to kepub, and only add kepub to final folder
	if [[ "${ext,,}" =~ (cbz|cbr|cb7) ]]; then
		/opt/calibre/ebook-convert "$clbdr/$TR_TORRENT_NAME" "$clbdr/$filename.epub" --landscape --no-default-epub-cover --no-process --output-profile=tablet >> "$log" 2>&1
		# rm "$clbdr/$TR_TORRENT_NAME"
		# do the conversion now so we can get rid of the epub
		kepubify "$clbdr/$filename.epub" --calibre -o "$clbdr/$filename.kepub" >> "$log" 2>&1
		rm "$clbdr/$filename.epub"
	fi

    # Convert any ePub to kepub too and add to final folder
	if [[ -f "$clbdr/$filename.epub" ]]; then
		kepubify "$clbdr/$filename.epub" --calibre -o "$clbdr/$filename.kepub" >> "$log" 2>&1
	fi

    #Check if something else is using calibredb right now and wait if it is
	if [[ -f $lockfile ]]; then
		echo "calibre is being used right now, waiting"
		while [ -f $lockfile ]; do
  			sleep 2
		done
	fi
	touch $lockfile
	calibredb add -1 "$clbdr" >> "$log" 2>&1
	rm $lockfile
fi

if [[ -d "$mvdir/$TR_TORRENT_NAME" ]]; then
	echo "adding $mvdir/$TR_TORRENT_NAME as a directory"
    #Check if something else is using calibredb right now and wait if it is
    if [[ -f $lockfile ]]; then
            echo "calibre is being used right now, waiting"
            while [ -f $lockfile ]; do
                    sleep 2
            done
    fi
    touch $lockfile
	calibredb add -1 "$mvdir/$TR_TORRENT_NAME" >> "$log" 2>&1
	rm $lockfile
fi