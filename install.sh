#!/bin/sh
# install.sh — put cnvim on PATH (~/.local/bin).

install -D -m 755 "$(dirname "$0")/cnvim" ~/.local/bin/cnvim
echo "installed ~/.local/bin/cnvim"
