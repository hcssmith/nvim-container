#!/bin/sh
# build.sh — build the nvim-container image with docker.
#
# Usage: build.sh [--debug] [--prune-cache]
#
#   build.sh             build and tag :latest plus a timestamp tag
#   build.sh --debug     plain build output, also written to build.log
#   build.sh --prune-cache   drop the build cache
#
# TAG overrides the image name: TAG=foo/bar build.sh

TAG="${TAG:-hcssmith/nvim-container}"
TIMESTAMP="${TIMESTAMP:-$(date +%Y%m%d-%H%M%S)}"

DEBUG=0
for arg in "$@"; do
	case "$arg" in
		--debug) DEBUG=1 ;;
		--prune-cache) docker builder prune -f; exit ;;
		*) echo "build.sh: unknown option: $arg" >&2; exit 1 ;;
	esac
done

if [ "$DEBUG" = 1 ]; then
	docker build --progress=plain . \
		-t "$TAG:latest" -t "$TAG:$TIMESTAMP" 2>&1 | tee build.log
else
	docker build . -t "$TAG:latest" -t "$TAG:$TIMESTAMP"
fi
