#!/bin/bash -eux
set -o pipefail

pip3 install --upgrade gnome-extensions-cli

gext install appindicatorsupport@rgcjonas.gmail.com && gext enable appindicatorsupport@rgcjonas.gmail.com
gext install dash-to-dock@micxgx.gmail.com && gext enable dash-to-dock@micxgx.gmail.com
gext enable GPaste@gnome-shell-extensions.gnome.org
gext install pop-shell@system76.com && gext enable pop-shell@system76.com
gext install tailscale-status@maxgallup.github.com && gext enable tailscale-status@maxgallup.github.com

exit 0
