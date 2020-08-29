# What this does
This will convert all your reflowable (azw3, mobi, epub) books to KePub and add them directly as additional formats for the same book ID to calibre.

It will query the library `calibredb` would pick up by default. If your DB is in an odd place, you can probaby symlink the calibredb directory to `~/'Calibre Library'` and not have to modify the script

# Requirements
You need `kepubify`, `ebook-convert` and `calibredb` installed and in your path.

# Why does this exist
- `calibredb` doesn't seem to have an easy CLI function to convert books already present in library
- `calibre-web` does not have a batch conversion function
  - The kobo sync gives weird results with ePub books
- I don't want to run the GUI for `calibre` on my headless server to do this

