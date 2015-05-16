#! /bin/sh

## Takes two directories as arguments, plus an optional third, and outputs any files that are present in the first two dirs but contain some diffence, ignoring everything in the third directory.
## There's probably an easier way to do this I didn't think of.

dirA="$(readlink -e "$1")/"
dirB="$(readlink -e "$2")/"
ignore="$(readlink -e "$3")/"

recursiveCall() {
    A=$dirA
    B=$dirB

    dirA="$(readlink -e "$1///")/"
    dirB="$(readlink -e "$2///")/"
    ignore="$(readlink -e "$3")/"

    find "$dirA" -maxdepth 1 -type f -printf '%f\n' | while read -r file ;
    do
	if [ -f "$dirB$file" ] && ! cmp -s "$dirA$file" "$dirB$file"
	then
	    realpath "$dirA$file"
	fi
    done

    find "$dirA" -maxdepth 1 -mindepth 1 -type d -printf '%f\n' | while read -r dir ;
    do
	if [ -d "$dirA$dir" ] && [ -d "$dirB$dir" ] && [ "$dirA" != "$ignore" ]
	then
	    recursiveCall "$dirA$dir" "$dirB$dir" "$ignore"
	fi
    done

    dirA=$A
    dirB=$B
    return 0
}

recursiveCall $dirA $dirB $ignore
