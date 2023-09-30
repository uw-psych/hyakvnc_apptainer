#!/bin/sh
# Clean stale X11 sockets and locks

if ! command -v fuser >/dev/null 2>&1; then
	echo >&2 "fuser is not installed. Exiting"
	exit 1
fi

for socket in /tmp/.X11-unix/*; do
	[ -e "$socket" ] || continue
	if ! fuser -s "$socket" 2>/dev/null; then
		# X11 is not in use by any process"
		lockfile="/tmp/.${socket##*/}-lock"
		rm -f "$socket" 2>/dev/null && echo >&2 "Removed stale X11 socket $socket" && [ -e "$lockfile" ] && rm -f "$lockfile" 2>/dev/null && echo >&2 "Removed stale X11 lockfile $lockfile"
	fi
done

for lockfile in /tmp/.X*-lock; do
	[ -e "$lockfile" ] || continue
	socket=/tmp/.X11-unix/${lockfile##*/.}
	read -r pid <"$lockfile"
	if [ -n "$pid" ] && [ ! -d "/proc/$pid" ]; then
		# X11 is not in use by process $pid"
		rm -f "$lockfile" 2>/dev/null && echo >&2 "Removed stale X11 lockfile $lockfile" || echo >&2 "Failed to remove stale X11 lockfile $lockfile"
		[ -e "$socket" ] && rm -f "$socket" 2>/dev/null && echo >&2 "Removed stale X11 socket $socket" || echo >&2 "Failed to remove stale X11 socket $socket"
	fi
done

hostnames="$(hostname -s)$(hostname -A)"
for h in $hostnames; do
	for pidfile in "$HOME/.vnc/${h}"*:*.pid; do
		[ -e "$pidfile" ] || continue
		read -r pid <"$pidfile"
		if [ -n "$pid" ] && [ ! -d "/proc/$pid" ]; then
			# VNC is not in use by process $pid on this host"
			rm -f "$pidfile" 2>/dev/null && echo >&2 "Removed stale VNC pidfile $pidfile" || echo >&2 "Failed to remove stale VNC pidfile $pidfile"
		fi
	done
done
