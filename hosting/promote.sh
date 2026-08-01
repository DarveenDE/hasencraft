#!/usr/bin/env bash
set -Eeuo pipefail

root="${HASENCRAFT_PACK_ROOT:-/srv/hasencraft-pack-host}"
version="${1:-}"
channel="${2:-}"

[[ "$version" =~ ^[0-9A-Za-z][0-9A-Za-z._-]*$ ]] || {
  echo "Usage: HASENCRAFT_PACK_ROOT=/srv/hasencraft-pack-host $0 <version> <stable|beta>" >&2
  exit 2
}
[[ "$channel" == stable || "$channel" == beta ]] || {
  echo "Channel must be stable or beta." >&2
  exit 2
}
[[ "$root" == /* && "$root" != / ]] || { echo "Unsafe pack root: $root" >&2; exit 1; }

release="$root/releases/$version"
channels="$root/channels"
[[ -d "$release" && ! -L "$release" && -f "$release/pack.toml" && -f "$release/index.toml" && -f "$release/SHA256SUMS" ]] || {
  echo "Release is incomplete: $release" >&2
  exit 1
}

echo "Verifying release $version"
(
  cd -- "$release"
  sha256sum --check --strict --quiet SHA256SUMS
)

mkdir -p "$channels"
tmp="$channels/.${channel}.${version}.$$"
ln -s "../releases/$version" "$tmp"
mv -T "$tmp" "$channels/$channel"
echo "$channel -> $version"
