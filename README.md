# These are my scripts for dealing with Calibre libraries on the CLI
You can use them but don't expect a ton of support. They're made for my specific use case.

Feel free to use them as inspiration for your own. Hit me up on Freenode in #calibre (same name but underscore instead of hyphen) if you want some help.

## `epub2kobo.sh` & `azw3mobi2epubkepub.sh`

### Why does this exist
- I want `Kepub` files in my Calibre library
- I don't want to run the GUI for `calibre` on my headless server to do this
- `calibredb` doesn't seem to have an easy CLI function to convert books already present in library
- `calibre-web` does not have a batch conversion function
  - The kobo sync gives weird results with ePub books

### What this does
These scripts will convert all your reflowable (azw3, mobi, epub) books to KePub and add them directly as additional formats for the same book ID to calibre.

It will query the library `calibredb` would pick up by default. If your DB is in an odd place, you can probaby symlink the calibredb directory to `~/'Calibre Library'` and not have to modify the script all that much.

### Requirements
You need `kepubify`, `ebook-convert` and `calibredb` installed and in your path.

## `find_bad_kepubs.sh`
### Why does this exist
- I fucked up the scripts I'm writing about above so i wanted to find kepubs that were identical to epubs and delete them
### What this does
- It checks the diff for each kepub + epub pair, and lets you know when they're identical

## `transmission2calibre.sh`
### Why does this exist
- I want downloaded books to be added to calibre straight away without using a cronjob
  - Transmission lets you execute a script after a torrent downloads and passes all sorts of useful variables to it
- I want my downloaded books to be converted to my desired formats (ePub and Kepub) as part of this flow
