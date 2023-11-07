#!/bin/bash
[[ -z "${FS_LICENSE:-}" ]] && [[ -n "${FREESURFER_HOME:-}" ]] && [[ -f "${FREESURFER_HOME}/license.txt" ]] && export FS_LICENSE="${FREESURFER_HOME}/license.txt"
if [[ -n "${FS_LICENSE:-}" ]] && [[ -f "${FS_LICENSE:-}" ]] && [[ -r "${FS_LICENSE:-}" ]]; then
	echo "FS_LICENSE is set to ${FS_LICENSE}" >&2
else
	if [[ -z "${FS_LICENSE:-}" ]]; then
		echo "FS_LICENSE is not set" >&2
		zenity --error --text "FreeSurfer license path FS_LICENSE is not set!"
	elif [[ ! -e "${FS_LICENSE}" ]]; then
		echo "FS_LICENSE does not exist" >&2
		zenity --error --text "FreeSurfer license path FS_LICENSE does not exist!"
	elif [[ ! -r "${FS_LICENSE}" ]]; then
		echo "FS_LICENSE is not readable" >&2
		zenity --error --text "FreeSurfer license path FS_LICENSE is not readable!"
	fi
	start_dir=""
	if [[ -n "${FS_LICENSE}" ]] && [[ -f "${FS_LICENSE}" ]]; then
		start_dir="$(dirname "${FS_LICENSE:-}")"
	fi

	[[ -n "${start_dir:-}" ]] && [[ -d "${start_dir:-}" ]] || start_dir="${PWD:-${HOME}}"

	while true; do
		zenity --question --text "Would you like to select a file to use for this session?" || break
		fsl="$(zenity --file-selection)" || break
		if [[ -f "${fsl:-}" ]] && [[ -r "${fsl:-}" ]]; then
			export FS_LICENSE="${fsl}"
			echo "FS_LICENSE is set to ${FS_LICENSE}" >&2
			break
		else
			zenity --error --text "Invalid file!"
		fi
	done
fi
freeview "$@"
