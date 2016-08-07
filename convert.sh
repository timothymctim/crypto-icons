#!/bin/sh
if [ "$#" -lt 1 ] || [ "$1" = "--help" ]; then
	echo "$0 [options]\n\nOptions\n\
  pdf     convert SVGs to PDFs\n\
  png     convert SVGs to PNGs\n\
  clean   remove all converted files"
	exit 0
fi
for FILENAME in *.svg; do
	if [ "$1" = "pdf" ]; then
		inkscape -A "$(basename "$FILENAME" .svg).pdf" "$FILENAME"
	elif [ "$1" = "png" ]; then
		inkscape -e "$(basename "$FILENAME" .svg).png" "$FILENAME"
	elif [ "$1" = "clean" ]; then
		rm "$(basename "$FILENAME" .svg).pdf" "$(basename "$FILENAME" .svg).png"
	fi
done
