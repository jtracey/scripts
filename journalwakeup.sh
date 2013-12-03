#! /bin/bash

renice -n 19 $$
xscreensaver-command -watch | while read line
do
    if [[ $(echo $line | grep -o UNBLANK) == "UNBLANK" ]]
	then
	emacs ~/Documents/journals/"$(date).txt" &
    fi
done

