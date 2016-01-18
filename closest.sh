#!/bin/sh
#
# wildefyr & z3bra - 2014 (c) wtfpl
# find and focus the closest window in a specific direction

readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))
readonly PROGPATH=${PROGPATH:-$PROGDIR/$PROGNAME}
ARGS="$@"

usage() {
    printf '%s\n' "Usage: $PROGNAME <direction>"
    test -z $1 && exit 0 || exit $1
}

next_east() {
    lsw | xargs wattr xi | sort -nr | sed "0,/$CUR/d" | sed "1s/^[0-9]* //p;d"
}

next_west() {
    lsw | xargs wattr xi | sort -n | sed "0,/$CUR/d" | sed "1s/^[0-9]* //p;d"
}

next_north() {
    lsw | xargs wattr yi | sort -nr | sed "0,/$CUR/d" | sed "1s/^[0-9]* //p;d"
}

next_south() {
    lsw | xargs wattr yi | sort -n | sed "0,/$CUR/d" | sed "1s/^[0-9]* //p;d"
}

main() {
    . fyrerc.sh

    case $1 in
        h|east|left)  focus.sh $(next_east)  2>/dev/null ;;
        j|south|down) focus.sh $(next_south) 2>/dev/null ;;
        k|north|up)   focus.sh $(next_north) 2>/dev/null ;;
        l|west|right) focus.sh $(next_west)  2>/dev/null ;;
        h|help)       usage                              ;;
        *)            usage                              ;;
    esac
}

main $ARGS
