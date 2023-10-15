#!/usr/bin/env sh

# Copyright (c) 2023
# author: MAXWELL KAPRAL
# shellcheck disable=SC2181

exec 2>/dev/null

url="https://github.com/Kapral67/WREC-iOS/releases/download/latest/"
vfile="$HOME/Documents/ver"
mkdir -p "$HOME"/Documents/bin

update() {
  if curl -fsL -o "$HOME"/Documents/bin/"${1}".sh "${url}${1}.sh"; then
    mv "$HOME"/Documents/bin/"${1}".sh "$HOME"/Documents/bin/"${1}"
    chmod +x "$HOME"/Documents/bin/"${1}"
    if [ -n "${2}" ]; then
      echo "${2}" > "$vfile"
    fi
  else
    rm -f "${1}".sh
    exit 1
  fi
}

ver="$(cat "$vfile")"
dat="$(curl -fIsL "${url}index.sh" | awk '/Last-Modified:/ {sub(/Last-Modified:/, ""); print}')"
lat="$(date -j -f "%a, %d, %b %Y %H:%M:%S %Z" "$dat" +%s)"

if ! echo "$lat" | grep -qE '^[0-9]+$'; then
  exit 1
elif ! echo "$ver" | grep -qE '^[0-9]+$' || [ "$ver" -lt "$lat" ]; then
  update index.sh "$lat"
  update update.sh
fi

exit 0
