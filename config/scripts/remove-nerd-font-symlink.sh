#!/usr/bin/env bash
set -euo pipefail

# bluefin-dx (and other images that install nerd-fonts from che/nerd-fonts)
# already provide this fontconfig symlink. The blue-build fonts module uses
# `ln -s` (not `ln -sf`) when configuring NerdFontsSymbolsOnly, so a duplicate
# symlink aborts the build. Remove it here and let the module recreate it.
rm -f /etc/fonts/conf.d/10-nerd-font-symbols.conf
