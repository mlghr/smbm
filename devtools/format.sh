#!/usr/bin/env bash
set -euo pipefail

binary=$(find "$HOME/.vscode/extensions" -maxdepth 3 -type f -path '*/dohe.godot-format*/binaries/gdscript-formatter' | head -n 1)
if [[ -z "$binary" ]]; then
  echo "Could not find dohe.godot-format gdscript-formatter binary in ~/.vscode/extensions" >&2
  exit 1
fi

target=${1:-scripts}
if [[ ! -e "$target" ]]; then
  echo "Target path '$target' does not exist." >&2
  exit 1
fi

echo "Formatting GDScript files under '$target' using '$binary'..."
find "$target" -name '*.gd' -type f -exec "$binary" {} +
echo "Done."
