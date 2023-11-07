#!/bin/sh
[ "${XDEBUG:-}" = "1" ] && set -x

HYAKVNC_VNC_PASSWORD="${HYAKVNC_VNC_PASSWORD:-password}"
HYAKVNC_VNC_DISPLAY="${HYAKVNC_VNC_DISPLAY:-:10}"
HYAKVNC_VNC_DIR="${HYAKVNC_VNC_DIR:-/vnc}"
HYAKVNC_VNC_LOG="${HYAKVNC_VNC_LOG:-${HYAKVNC_VNC_DIR}/vnc.log}"
HYAKVNC_VNC_SOCKET="${HYAKVNC_VNC_SOCKET:-${HYAKVNC_VNC_DIR}/socket.uds}"
HYAKVNC_VNC_PORT="${HYAKVNC_VNC_PORT:-}"

while true; do
	case "${1:-}" in
		--port | -p)
			shift
			export HYAKVNC_VNC_PORT="${1:-5900}"
			;;
		--help | -h)
			echo "Usage: ${0} [--port|-p <portnum>][--help|-h] -- <vncserver args>"
			echo "  --port|-p <portnum>  Set a port number to listen on instead of a Unix socket"
			echo "  --help|-h            Print this help message"
			echo "  -- <vncserver args>  Pass any additional arguments to vncserver"
			echo " 					 (e.g. -geometry 1920x1080)"
			echo "Environment variables:"
			echo "  HYAKVNC_VNC_PASSWORD  Set the VNC password (default: password)"
			echo "  HYAKVNC_VNC_DISPLAY   Set the VNC display (default: :10)"
			echo "  HYAKVNC_VNC_DIR       Set the VNC directory (default: /vnc)"
			echo "  HYAKVNC_VNC_LOG       Set the VNC log file (default: /vnc/vnc.log)"
			echo "  HYAKVNC_VNC_SOCKET    Set the VNC Unix socket (default: /vnc/socket.uds)"
			echo "  HYAKVNC_VNC_PORT      Set the VNC port (default: unset, use Unix socket)"
			exit 0
			;;
		--)
			shift
			break
			;;
		*)
			break
			;;
	esac
	shift
done

echo "Running as ${USER:-$(id -un)} with UID ${UID:-$(id -u)} and GID ${GID:-$(id -g)}" >&2

# Set up the VNC directory
mkdir -p "${HYAKVNC_VNC_DIR}" &&
	echo "${HYAKVNC_VNC_PASSWORD}" | vncpasswd -f >"${HYAKVNC_VNC_DIR}/passwd" &&
	chmod 600 "${HYAKVNC_VNC_DIR}/passwd" &&
	echo "${APPTAINER_NAME:-hyakvnc-vncserver}: Set VNC password to ${HYAKVNC_VNC_PASSWORD}" &&
	uname -n >"${HYAKVNC_VNC_DIR}/hostname" &&
	printenv >"${HYAKVNC_VNC_DIR}/environment"

# Set up the vncserver arguments
if [ -n "${HYAKVNC_VNC_PORT:-}" ]; then
	set -- -rfbport "${HYAKVNC_VNC_PORT}" "${@}"
else
	set -- -rfbunixpath "${HYAKVNC_VNC_SOCKET}" "${@}"
fi

set -- "${HYAKVNC_VNC_DISPLAY}" -fg -log "${HYAKVNC_VNC_LOG}" "${@}"

echo "Running vncserver ${*}" >&2
trap 'vncserver -kill "${HYAKVNC_VNC_DISPLAY}" 2>/dev/null' INT QUIT TERM TSTP
vncserver "$@"
trap - INT QUIT TERM TSTP
echo
echo "Exiting vncserver" >&2
