#!/bin/sh
if [ "$#" -lt 1 ] || [ "$1" = "--help" ]; then
	echo "$0 [options]\n\nOptions\n\
  pdf       convert SVGs to PDFs\n\
  png       convert SVGs to PNGs\n\
  montage   create a composite image all icons\n\
  clean     remove all converted files"
	exit 0
fi
if [ "$1" = "montage" ]; then
	for FILENAME in *.svg; do
		inkscape -e "$(basename "$FILENAME" .svg).montage" --export-width=128 "$FILENAME"
	done
	montage -label '%t' -geometry 128x128+10+10 *.montage montage.png
	rm *.montage
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
