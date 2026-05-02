# #!/usr/bin/env bash
# set -euo pipefail

# cd "$(git rev-parse --show-toplevel)"

# if [[ ! -x ./devtools/install-git-hooks.sh ]]; then
#   echo "devtools/install-git-hooks.sh is missing or not executable." >&2
#   exit 1
# fi

# ./devtools/install-git-hooks.sh

# echo "Setup complete. Run git commit normally; the shared pre-commit hook will format .gd files before committing."

# # Detect OS and provide shell helper instructions
# if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "mingw"* ]]; then
#   echo ""
#   echo "### Optional: shell helper for Windows/Git Bash"
#   echo "If you want a convenient local command for formatting, add this to ~/.bashrc:"
#   echo ""
#   echo "fmtgd() {"
#   echo "  local repo=\"\$HOME/smbm\""
#   echo "  if [[ -x \"\$repo/devtools/format.sh\" ]]; then"
#   echo "    (cd \"\$repo\" && ./devtools/format.sh \"\$@\")"
#   echo "  else"
#   echo "    echo \"devtools/format.sh not found or not executable in \$repo\" >&2"
#   echo "    return 1"
#   echo "  fi"
#   echo "}"
#   echo ""
#   echo "Then reload your shell with:"
#   echo "source ~/.bashrc"
# else
#   echo ""
#   echo "### Optional: shell helper"
#   echo "If you want a convenient local command for formatting, add this to ~/.zshrc:"
#   echo ""
#   echo "fmtgd() {"
#   echo "  local repo=\"\$HOME/smbm\""
#   echo "  if [[ -x \"\$repo/devtools/format.sh\" ]]; then"
#   echo "    (cd \"\$repo\" && ./devtools/format.sh \"\$@\")"
#   echo "  else"
#   echo "    echo \"devtools/format.sh not found or not executable in \$repo\" >&2"
#   echo "    return 1"
#   echo "  fi"
#   echo "}"
#   echo ""
#   echo "Then reload your shell with:"
#   echo "source ~/.zshrc"
# fi
