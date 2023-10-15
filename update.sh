#!/usr/bin/env sh

# Copyright (c) 2023
# author: MAXWELL KAPRAL
# shellcheck disable=SC2181

url="https://github.com/Kapral67/WREC-iOS/releases/download/latest/"
vfile="$HOME/Documents/ver"
mkdir -p "$HOME"/Documents/bin 2>/dev/null

update() {
  if curl -fsL -o "$HOME"/Documents/bin/"${1}".sh "${url}${1}.sh"; then
    mv "$HOME"/Documents/bin/"${1}".sh "$HOME"/Documents/bin/"${1}" 2>/dev/null
    chmod +x "$HOME"/Documents/bin/"${1}" 2>/dev/null
    if [ -n "${2}" ]; then
      echo "${2}" > "$vfile" 2>/dev/null
    fi
  else
    rm -f "${1}".sh 2>/dev/null
    exit 1
  fi
}

ver="$(cat "$vfile" 2>/dev/null)"
dat="$(curl -fIsL "${url}index.sh" | awk '/Last-Modified: / {sub(/Last-Modified: /, ""); print}' 2>/dev/null)"
lat="$(date -j -f "%a, %d %b %Y %T %Z" "$dat" +%s 2>/dev/null)"

if ! echo "$lat" 2>/dev/null | grep -qE '^[0-9]+$' 2>/dev/null; then
  exit 1
elif ! echo "$ver" 2>/dev/null | grep -qE '^[0-9]+$' 2>/dev/null || [ "$ver" -lt "$lat" ]; then
  update index "$lat"
  update update
fi

exit 0
