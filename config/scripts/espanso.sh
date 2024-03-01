#!/bin/bash
set -o pipefail

echo "$USER"
echo "$EUID"
setcap "cap_dac_override+p" "$(which espanso-wayland)"
getcap "$(which espanso-wayland)"
