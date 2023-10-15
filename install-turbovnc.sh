#!/bin/sh
# Install TurboVNC:

TURBOVNC_VERSION=${TURBOVNC_VERSION:-3.0.91}
TURBOVNC_FILES_ROOT="${TURBOVNC_FILES_ROOT:-}"
TURBOVNC_DOWNLOAD_ROOT="${TURBOVNC_DOWNLOAD_ROOT:-https://sourceforge.net/projects/turbovnc/files}"
TURBOVNC_DOWNLOAD_URL="${TURBOVNC_DOWNLOAD_URL:-}"
TURBOVNC_TMPDIR="${TURBOVNC_TMPDIR:-./}"

if [ "${TURBOVNC_VERSION}" = "3.0.91" ] && [ -z "${TURBOVNC_FILES_ROOT:-}" ]; then
	TURBOVNC_FILES_ROOT="3.0.91 (3.1 beta2)"
fi

# url-encode the files root:
files_root_enc=$(echo "${TURBOVNC_FILES_ROOT}" | curl -Gs -w '%{url_effective}' --data-urlencode @- ./ | sed "s/%0[aA]$//;s/^[^?]*?\(.*\)/\1/;s/[+]/%20/g")

if [ -z "${TURBOVNC_DOWNLOAD_URL:-}" ]; then
	if command -v dpkg >/dev/null 2>&1; then
		# Is Debian/Ubuntu. Package filename looks like turbovnc_3.0.91_arm64.deb
		arch="$(dpkg --print-architecture)"
		filename="turbovnc_${TURBOVNC_VERSION}_${arch}.deb"
	elif command -v yum >/dev/null 2>&1; then
		# Is RHEL/CentOS/Rocky. Package filename looks like turbovnc-3.0.91.x86_64.rpm
		arch="$(uname -m)"
		filename="turbovnc_${TURBOVNC_VERSION}.${arch}.rpm"
	else
		echo >&2 "error: cannot determine architecture and package extension for this OS"
		exit 1
	fi
	TURBOVNC_DOWNLOAD_URL="${TURBOVNC_DOWNLOAD_ROOT}/${files_root_enc}/${filename}"
fi

download_path="${TURBOVNC_TMPDIR}/${filename}"

if command -v curl >/dev/null 2>&1; then
	echo "Downloading TurboVNC from ${TURBOVNC_DOWNLOAD_URL} to ${download_path} via curl..."
	curl -o "${download_path}" -fsSL "${TURBOVNC_DOWNLOAD_URL}" || {
		echo >&2 "error: failed to download ${TURBOVNC_DOWNLOAD_URL}"
		exit 1
	}
elif command -v wget >/dev/null 2>&1; then
	echo "Downloading TurboVNC from ${TURBOVNC_DOWNLOAD_URL} to ${download_path} via wget..."
	wget -O "${download_path}" "${TURBOVNC_DOWNLOAD_URL}" || {
		echo >&2 "error: failed to download ${TURBOVNC_DOWNLOAD_URL}"
		exit 1
	}
else
	echo >&2 "error: curl or wget not found"
	exit 1
fi

if command -v dpkg >/dev/null 2>&1; then
	# Is Debian/Ubuntu
	apt install -y -q --install-suggests --install-recommends "${download_path}" || echo >&2 "warning: failed to install ${TURBOVNC_DOWNLOAD_PATH}"
elif command -v yum >/dev/null 2>&1; then
	# Is RHEL/CentOS/Rocky
	yum install -y -q "${download_path}" || echo >&2 "warning: failed to install ${TURBOVNC_DOWNLOAD_PATH}"
else
	echo >&2 "error: cannot determine package manager for this OS"
fi

rm -f "${download_path}"
