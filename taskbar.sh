#!/bin/sh
#
# wildefyr - 2016 (c) wtfpl
# report group and window title data in lemonbar format

. fyrerc.sh

# colours!!11!!!
ACTIVE="%{F#D7D7D7}"
INACTIVE="%{F#737373}"

for group in $GROUPSDIR/group.?; do
    title=""
    numGroups=$(ls $GROUPSDIR/group.? | wc -l)
    groupNum=$(printf "$group" | rev | cut -d'.' -f 1 | rev)

    colour="$INACTIVE"
    for groupId in $(cat "$GROUPSDIR/active"); do
        test "$groupId" -eq "$groupNum" && {
            colour="$ACTIVE"
            break
        } || {
            colour="$INACTIVE"
        }
    done

    wids=$(cat $group | tr '\n' ' ')

    for wid in $wids; do
        window="$(class ${wid})"

        test "$window" = "URxvt" && {
            window="$(name ${wid})"
            test "$window" = "tmux" && {
                window="$(wname ${wid})"
            }
            test "$window" = "urxvt" && {
                window="$(wname ${wid})"
            }
        }
        test "$window" = "mpv" && {
            window="$(wname ${wid})"
        }
        test "$window" = "Wine" && {
            window="$(wname ${wid})"
        }

        test -z "$title" && {
            title="$(printf "$window" | tr '\n' ' ')"
        } || {
            title="$title \ $(printf "$window" | tr '\n' ' ')"
        }
    done

    test ! -z "$title" && {
        stringOut="${stringOut}${colour}\
%{A:wgroups.sh -t $groupNum:}  #${groupNum} - ${title}  %{A}"
    }

    test "$counter" -ne "$numGroups" && {
        stringOut="${stringOut}${INACTIVE}|"
    } || {
        counter=$((counter + 1))
    }
done

echo "${stringOut}"
