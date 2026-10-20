#!/bin/bash

# =============================================================================
# Neovim LSP Setup Script
# Run this once after cloning the repo to install all language servers.
# Requires: dnf, npm, pip, go, cargo/rustup (install what you need)
# =============================================================================

set -e

GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
NC="\033[0m"

info()    { echo -e "${GREEN}[INFO]${NC} $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
skip()    { echo -e "${YELLOW}[SKIP]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; }

has() { command -v "$1" &>/dev/null; }

echo ""
echo "========================================"
echo "  Neovim LSP Setup"
echo "========================================"
echo ""

# --- clangd (C / C++) ---
info "Installing clangd..."
if has dnf; then
  sudo dnf install -y clang clang-tools-extra
elif has apt; then
  sudo apt install -y clangd
elif has pacman; then
  sudo pacman -S --noconfirm clang
else
  warn "No supported package manager found for clangd. Install it manually."
fi

# --- lua-language-server (Lua) ---
info "Installing lua-language-server..."
if has dnf; then
  sudo dnf install -y lua-language-server
elif has apt; then
  sudo apt install -y lua-language-server
elif has pacman; then
  sudo pacman -S --noconfirm lua-language-server
else
  warn "No supported package manager found for lua-language-server. Install it manually."
fi

# --- bash-language-server (Bash) ---
if has npm; then
  info "Installing bash-language-server..."
  sudo npm install -g bash-language-server
else
  skip "npm not found — skipping bash-language-server"
fi

# --- typescript-language-server (JS / TS) ---
if has npm; then
  info "Installing typescript-language-server..."
  sudo npm install -g typescript typescript-language-server
else
  skip "npm not found — skipping typescript-language-server"
fi

# --- pyright (Python) ---
if has pip; then
  info "Installing pyright..."
  pip install --user pyright
elif has npm; then
  info "Installing pyright via npm..."
  sudo npm install -g pyright
else
  skip "Neither pip nor npm found — skipping pyright"
fi

# --- rust-analyzer (Rust) ---
if has rustup; then
  info "Installing rust-analyzer via rustup..."
  rustup component add rust-analyzer
elif has cargo; then
  info "Installing rust-analyzer via cargo..."
  cargo install rust-analyzer
else
  skip "rustup/cargo not found — skipping rust-analyzer"
fi

# --- gopls (Go) ---
if has go; then
  info "Installing gopls..."
  go install golang.org/x/tools/gopls@latest
else
  skip "go not found — skipping gopls"
fi

# --- marksman (Markdown) ---
if has cargo; then
  info "Installing marksman..."
  cargo install marksman
else
  skip "cargo not found — skipping marksman. Download from: https://github.com/artempyanykh/marksman/releases"
fi

# --- cmake-language-server (CMake) ---
if has pip; then
  info "Installing cmake-language-server..."
  pip install --user cmake-language-server
else
  skip "pip not found — skipping cmake-language-server"
fi

# --- Mason-managed servers (html, cssls, jsonls, yamlls) ---
info "Launching Neovim to install Mason-managed servers (html, cssls, jsonls, yamlls)..."
info "This may take a moment on first run..."
nvim --headless "+MasonInstall html-lsp css-lsp json-lsp yaml-language-server" +qa 2>/dev/null || \
  warn "Mason install step failed or Neovim not in PATH. Open Neovim and run :MasonInstall manually."

echo ""
echo "========================================"
echo "  Setup complete!"
echo "  Open Neovim and run :checkhealth to"
echo "  verify all language servers are ready."
echo "========================================"
echo ""
