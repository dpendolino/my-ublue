#!/bin/bash
set -o pipefail

setcap "cap_dac_override+p" $(which espanso-wayland)
