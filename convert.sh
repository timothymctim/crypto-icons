#!/bin/sh
show_help() {
	cat << EOF
Usage: ${0##*/} [options] [FORMAT]
Convert all SVG files in the current directory to FORMAT.
If no FORMAT is given, all possible formats are considered.

Options
    -h          display this help and exit
    -s SUFFIX   append SUFFIX to the basename of the converted files
    -c          remove all converted files in FORMAT
    -n          crop the excessive whitespace of the image

FORMAT options
    pdf         convert PDFs
    png         convert PNGs
    montage     create a composite image all icons (in PNG format)
EOF
}

CLEAN=0
SUFFIX=""
CONVERT_OPTIONS=""
while getopts "hcs:n" opt; do
	case "$opt" in
		h)  show_help
			exit 0
			;;
		c)  CLEAN=1
			;;
		s)  SUFFIX=$OPTARG
			;;
		n)  CONVERT_OPTIONS="-D"
			;;
		'?')
			show_help >&2
			exit 1
			;;
	esac
done
shift "$((OPTIND-1))"

MONTAGE=0
# Set all conversion options if none is specified
if [ -z "$1" ]; then
	PDF=1
	PNG=1
else
	PDF=0
	PNG=0
fi
while :; do
	case $1 in
		pdf)
			PDF=1
			;;
		png)
			PNG=1
			;;
		montage)
			MONTAGE=1
			;;
		?*)
			printf "Unknown conversion option: %s\n" "$1" >&2
			break
	esac

	if [ -z "$1" ]; then
		# Break the loop if no more options to parse
		break
	fi
	shift
done

for FILENAME in *.svg; do
	if [ $CLEAN -eq 1 ]; then
		if [ $PDF -eq 1 ]; then
			rm "$(basename "$FILENAME" .svg)${SUFFIX}.pdf"
		fi
		if [ $PNG -eq 1 ]; then
			rm "$(basename "$FILENAME" .svg)${SUFFIX}.png"
		fi
	else
		if [ $PDF -eq 1 ]; then
			inkscape $CONVERT_OPTIONS -A "$(basename "$FILENAME" .svg)${SUFFIX}.pdf" "$FILENAME"
		fi
		if [ $PNG -eq 1 ]; then
			inkscape $CONVERT_OPTIONS -e "$(basename "$FILENAME" .svg)${SUFFIX}.png" "$FILENAME"
		fi
	fi
done

if [ $MONTAGE -eq 1 ]; then
	for FILENAME in *.svg; do
		inkscape -e "$(basename "$FILENAME" .svg).montage" --export-width=128 "$FILENAME"
	done
	montage -label '%t' -geometry 128x128+10+10 *.montage montage"$SUFFIX".png
	rm *.montage
fi
