#!/usr/bin/env bash
# ================================================
# Victor's Dev Environment — install.sh
# Claude Code + Nvim 0.11 + Ghostty workflow
# macOS only
# Usage: git clone https://github.com/victorgalvez56/dotfiles && cd dotfiles && bash install.sh
# ================================================
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Colors ──────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; BOLD='\033[1m'; RESET='\033[0m'

ok()      { echo -e "${GREEN}✓${RESET} $*"; }
info()    { echo -e "${BLUE}→${RESET} $*"; }
warn()    { echo -e "${YELLOW}⚠${RESET}  $*"; }
fail()    { echo -e "${RED}✗${RESET} $*"; exit 1; }
section() { echo -e "\n${BOLD}── $* ──────────────────────────────────${RESET}"; }

backup_if_exists() {
  local target="$1"
  if [[ -e "$target" ]]; then
    local backup="${target}.bak.$(date +%Y%m%d_%H%M%S)"
    cp -r "$target" "$backup"
    warn "Backed up $(basename "$target") → $backup"
  fi
}

# ── Guards ──────────────────────────────────────
[[ "$(uname)" == "Darwin" ]] || fail "This script is macOS only."

section "Homebrew"
if ! command -v brew &>/dev/null; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  [[ -f /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
else
  ok "Homebrew already installed"
fi

# ── CLI tools ────────────────────────────────────
section "CLI Tools"

BREW_PACKAGES=(neovim lazygit node python ripgrep fd fzf make stylua git)

for pkg in "${BREW_PACKAGES[@]}"; do
  if brew list --formula "$pkg" &>/dev/null; then
    ok "$pkg"
  else
    info "Installing $pkg..."
    brew install "$pkg"
    ok "$pkg"
  fi
done

# ── Fonts ────────────────────────────────────────
section "Fonts"

if brew list --cask font-jetbrains-mono-nerd-font &>/dev/null; then
  ok "JetBrainsMono Nerd Font already installed"
else
  info "Installing JetBrainsMono Nerd Font..."
  brew install --cask font-jetbrains-mono-nerd-font
  ok "JetBrainsMono Nerd Font"
fi

# ── Ghostty ──────────────────────────────────────
section "Ghostty"

if [[ -d "/Applications/Ghostty.app" ]]; then
  ok "Ghostty already installed"
else
  info "Installing Ghostty..."
  brew install --cask ghostty || warn "Ghostty install failed — download from https://ghostty.org"
fi

# ── Claude Code CLI ──────────────────────────────
section "Claude Code CLI"

if command -v claude &>/dev/null; then
  ok "Claude Code already installed"
else
  info "Installing Claude Code CLI..."
  npm install -g @anthropic-ai/claude-code
  ok "Claude Code"
fi

# ── Background image ─────────────────────────────
section "Ghostty Background Image"

BG_IMAGE="$HOME/Pictures/ghostty-bg.png"
if [[ -f "$BG_IMAGE" ]]; then
  ok "Background image found at $BG_IMAGE"
else
  warn "No background image found at $BG_IMAGE"
  warn "Copy your Hokusai waves PNG there — Ghostty will work without it."
fi

# ── Ghostty Config ───────────────────────────────
section "Ghostty Config"

GHOSTTY_CONFIG_DIR="$HOME/Library/Application Support/com.mitchellh.ghostty"
mkdir -p "$GHOSTTY_CONFIG_DIR"
GHOSTTY_CONFIG="$GHOSTTY_CONFIG_DIR/config"

backup_if_exists "$GHOSTTY_CONFIG"

# Write config with correct absolute path for this user
sed "s|~/Pictures/ghostty-bg.png|$HOME/Pictures/ghostty-bg.png|g" \
  "$DOTFILES_DIR/ghostty/config" > "$GHOSTTY_CONFIG"

ok "Ghostty config → $GHOSTTY_CONFIG"

# ── Nvim Config ──────────────────────────────────
section "Nvim Config"

NVIM_DIR="$HOME/.config/nvim"
backup_if_exists "$NVIM_DIR"
mkdir -p "$NVIM_DIR/lua/plugins"

cp "$DOTFILES_DIR/nvim/init.lua"                        "$NVIM_DIR/init.lua"
cp "$DOTFILES_DIR/nvim/lua/plugins/ui.lua"              "$NVIM_DIR/lua/plugins/ui.lua"
cp "$DOTFILES_DIR/nvim/lua/plugins/navigation.lua"      "$NVIM_DIR/lua/plugins/navigation.lua"
cp "$DOTFILES_DIR/nvim/lua/plugins/git.lua"             "$NVIM_DIR/lua/plugins/git.lua"
cp "$DOTFILES_DIR/nvim/lua/plugins/lsp.lua"             "$NVIM_DIR/lua/plugins/lsp.lua"
cp "$DOTFILES_DIR/nvim/lua/plugins/dap.lua"             "$NVIM_DIR/lua/plugins/dap.lua"
cp "$DOTFILES_DIR/nvim/lua/plugins/markdown.lua"        "$NVIM_DIR/lua/plugins/markdown.lua"

ok "nvim config → $NVIM_DIR (7 files)"

# ── Claude CLAUDE.md ─────────────────────────────
section "Claude Code Config"

CLAUDE_DIR="$HOME/.claude"
mkdir -p "$CLAUDE_DIR"
backup_if_exists "$CLAUDE_DIR/CLAUDE.md"
cp "$DOTFILES_DIR/claude/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
ok "~/.claude/CLAUDE.md"

# ── Done ─────────────────────────────────────────
section "Done"

cat << EOF

  Next steps:

  1. Copy your background image:
     cp /path/to/hokusai.png ~/Pictures/ghostty-bg.png

  2. Open nvim — lazy.nvim auto-installs all 35 plugins on first launch:
     nvim

  3. Mason will auto-install LSP servers (ts_ls, lua_ls, pyright).
     Swift/sourcekit requires Xcode to be installed separately.

  4. Log in to Claude Code:
     claude

  5. Start your workflow:
     cd my-project
     nvim .                  # left split
     # Cmd+D → split right
     claude                  # right split

EOF

echo -e "${GREEN}Setup complete.${RESET}"
