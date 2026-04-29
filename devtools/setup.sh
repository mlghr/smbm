#!/usr/bin/env bash
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

if [[ ! -x ./devtools/install-git-hooks.sh ]]; then
  echo "devtools/install-git-hooks.sh is missing or not executable." >&2
  exit 1
fi

./devtools/install-git-hooks.sh

echo "Setup complete. Run git commit normally; the shared pre-commit hook will format .gd files before committing."
