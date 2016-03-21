#!/bin/sh
#
# wildefyr - 2016 (c) MIT
# power menu for fyre

usage() {
    cat << EOF
Usage: $(basename $0) [-lerp]
    -e | --exit:   Exit fyre.
    -l | --lock:   Lock the session.
    -p | --power:  Poweroff the machine.
    -r | --reboot: Reboot the machine.
EOF

    test $# -eq 0 || exit $1
}

killfyre() {
    layouts.sh -s 0 -q
    windows.sh --reset

    pgrep taskbar.sh 2>&1 > /dev/null && {
        pkill taskbar.sh
    }

    pkill xinit
}

lockfyre() {
    mpvc --stop -q

    test -d /sys/class/backlight/intel_backlight && {
        type xbacklight 2>&1 > /dev/null && {
            LIGHT=$(xbacklight -get)
            LIGHT=$(echo "($LIGHT+0.5)/1" | bc)
            xbacklight -set 0 && slock && xbacklight -set $LIGHT
            return 0
        }
    }

    xset dpms force suspend

    type slock 2>&1 > /dev/null && {
        slock
    } || {
        printf '%s\n' "slock was not found on your \$PATH."
    }
}

restartfyre() {
    killfyre
    sudo reboot 2>/dev/null
}

powerfyre() {
    killfyre
    sudo poweroff 2>/dev/null
}

case $1 in
    -l|--lock)     lockfyre    ;;
    -e|--exit)     killfyre    ;;
    -r|--restart)  restartfyre ;;
    -p|--poweroff) powerfyre   ;;
    *)             usage       ;;
esac
