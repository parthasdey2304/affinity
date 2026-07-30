#!/usr/bin/env bash
set -e

print_affinity_banner() {
cat <<'BANNER'
╭────────────────────────────────────────────────────────────────────╮
│  █████╗  ███████╗ ███████╗ ██╗ ███╗   ██╗ ██╗ ████████╗ ██╗   ██╗  │
│ ██╔══██╗ ██╔════╝ ██╔════╝ ██║ ████╗  ██║ ██║ ╚══██╔══╝ ╚██╗ ██╔╝  │
│ ███████║ █████╗   █████╗   ██║ ██╔██╗ ██║ ██║    ██║     ╚████╔╝   │
│ ██╔══██║ ██╔══╝   ██╔══╝   ██║ ██║╚██╗██║ ██║    ██║      ╚██╔╝    │
│ ██║  ██║ ██║      ██║      ██║ ██║ ╚████║ ██║    ██║       ██║     │
│ ╚═╝  ╚═╝ ╚═╝      ╚═╝      ╚═╝ ╚═╝  ╚═══╝ ╚═╝    ╚═╝       ╚═╝     │
╰────────────────────────────────────────────────────────────────────╯
BANNER

    printf "\n"
    printf "                    Affinity CLI\n"
    printf "           premium terminal code viewer\n\n"
}

print_affinity_banner

# ──────────────────────────────────────────────────────────────────────
#  Affinity — Installation Script
#  Installs affinity-code-viewer locally (user-level, no sudo needed)
# ──────────────────────────────────────────────────────────────────────

PYTHON="${PYTHON:-python3}"

echo "▸ Checking for Python..."
if ! command -v "$PYTHON" &>/dev/null; then
    echo "✗ Python 3 is required but not found."
    echo "  Install it from https://python.org and re-run this script."
    exit 1
fi

PY_VERSION=$("$PYTHON" -c 'import sys; print(f"{sys.version_info[0]}.{sys.version_info[1]}")')
echo "  Found Python $PY_VERSION ✓"

echo ""
echo "▸ Upgrading pip..."
"$PYTHON" -m pip install --upgrade pip --user --quiet

echo ""
echo "▸ Installing Affinity..."
"$PYTHON" -m pip install affinity-code-viewer --user --quiet

# Ensure ~/.local/bin is in PATH
LOCAL_BIN="$HOME/.local/bin"
case ":$PATH:" in
    *":$LOCAL_BIN:")
        ;;
    *)
        echo ""
        echo "⚠  $LOCAL_BIN is not in your PATH."
        echo "  Add this line to your ~/.bashrc or ~/.zshrc:"
        echo ""
        echo '    export PATH="$HOME/.local/bin:$PATH"'
        echo ""
        echo "  Then run: source ~/.bashrc  (or restart your terminal)"
        ;;
esac

echo ""
echo "▸ Verifying installation..."
if command -v affinity &>/dev/null; then
    echo "  $(affinity --version 2>/dev/null || echo 'affinity command found ✓')"
else
    echo "  Installation complete. If 'affinity' is not found,"
    echo "  make sure $LOCAL_BIN is in your PATH (see above)."
fi

echo ""
echo "▸ Done! Try it out:"
echo "    affinity main.py"
echo "    affinity --help"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Built with ❤ for developers everywhere."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
