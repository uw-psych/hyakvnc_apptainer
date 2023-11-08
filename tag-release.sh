#!/usr/bin/env bash

set -o pipefail

[[ -n "${XDEBUG:-}" ]] && set -x

TAG_PREFIX="sif-"
IMAGE_TAG_SEP="#"

IMAGE_NAME="${1:-}"
[[ -n "${IMAGE_NAME:-}" ]] || { echo "IMAGE_NAME is empty" >&2; exit 1; }
shift

IMAGE_TAG="${1:-}"
if [[ -z "${IMAGE_TAG:-}" ]]; then
	IMAGE_TAG="latest"
	echo "IMAGE_TAG is empty, using default: ${IMAGE_TAG}" >&2
else
	shift
fi

FULL_CONTAINER_NAME="${IMAGE_NAME}:${IMAGE_TAG}"

GIT_TAG="${TAG_PREFIX}${IMAGE_NAME}${IMAGE_TAG_SEP}${IMAGE_TAG}"

[[ -n "${GIT_TAG:-}" ]] || { echo "GIT_TAG is empty" >&2; exit 1; }

comment="${1:-}"
if [[ -z "${comment:-}" ]]; then
	comment="${FULL_CONTAINER_NAME}"
	echo "comment is empty, using default: ${comment}" >&2
else
	shift
fi

git_tag_args=()
if [[ -n "${comment:-}" ]]; then
	git_tag_args+=(-m "${comment}")
fi

for arg in "$@"; do
	git_tag_args+=(-m "${arg}")
done

echo "git_tag_args: ${git_tag_args[*]}" >&2

if git tag -l "${GIT_TAG:-}" | grep -q "^${GIT_TAG:-}$"; then
	echo "git tag ${GIT_TAG} already exists" >&2
	if [[ -t 1 ]]; then
		choice=y
		read -rp "Do you want to continue? [Y/n] " choice
		[[ "${choice:-y}" =~ ^[Yy]$ ]] || exit 1
	fi
fi

if [[ -t 1 ]]; then
	echo "git tag -fa ${GIT_TAG} ${git_tag_args[*]}"
	choice=y
	read -rp "Do you want to continue? [Y/n] " choice
	[[ "${choice:-y}" =~ ^[Yy]$ ]] || exit 1
fi

git tag -fa "${GIT_TAG}" "${git_tag_args[@]}"

if [[ -t 1 ]]; then
	choice=y
	read -rp "Do you want to push to origin? [Y/n] " choice
	[[ "${choice:-y}" =~ ^[Yy]$ ]] || exit 0
fi

echo "Pushing to origin: ${GIT_TAG}"
git push -f origin "${GIT_TAG}"