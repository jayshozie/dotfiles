#!/usr/bin/env bash

# Where the binaries will actually live
BIN_DIR="$HOME/.local/bin"
# A temporary spot to extract things before moving them
TMP_DIR="/tmp/lsp-update"

mkdir -p "$BIN_DIR" "$TMP_DIR"

# Function to pull the latest GitHub release binary
# Usage: install_github_release <repo> <pattern> <binary_name>
install_github_release() {
    local repo="$1"
    local pattern="$2"      # e.g., "x86_64-linux"
    local bin_name="$3"     # The final name of the executable

    echo "==> Updating $bin_name from $repo"

    # 1. Use the GitHub API to find the latest release URL that matches our platform pattern
    local download_url=$(curl -s "https://api.github.com/repos/$repo/releases/latest" | \
                         grep "browser_download_url" | grep "$pattern" | cut -d '"' -f 4 | head -n 1)

    if [[ -z "$download_url" ]]; then
        echo "    [ERROR] Could not find release matching '$pattern' for $repo"
        return 1
    fi

    # 2. Download into temp dir
    local filename=$(basename "$download_url")
    curl -sL "$download_url" -o "$TMP_DIR/$filename"

    # 3. Extract or move based on file extension
    pushd "$TMP_DIR" > /dev/null
    if [[ "$filename" == *.tar.gz ]]; then
        tar -xzf "$filename"
        # Find the executable and move it
        find . -type f -executable -name "$bin_name" -exec mv {} "$BIN_DIR/" \;
    elif [[ "$filename" == *.zip ]]; then
        unzip -q -o "$filename"
        find . -type f -executable -name "$bin_name" -exec mv {} "$BIN_DIR/" \;
    else
        # It's a raw binary
        mv "$filename" "$BIN_DIR/$bin_name"
    fi
    popd > /dev/null

    chmod +x "$BIN_DIR/$bin_name"
    echo "    [OK] $bin_name updated."
}

# Function for NPM-based servers (bash-language-server, pyright, vtsls)
install_npm_lsp() {
    local package="$1"
    echo "==> Updating $package via npm"
    # Assuming you have npm installed, this installs it globally to your user prefix
    npm install -g "$package"
}

# ==========================================
# THE REGISTRY
# ==========================================
# Clear temp dir for a fresh start
rm -rf "$TMP_DIR/*"

# --- GitHub Releases (Compiled Binaries) ---
# Example: lua-language-server
install_github_release "LuaLS/lua-language-server" "linux-x64.tar.gz" "lua-language-server"

# Example: harper-ls (if you want to switch from cargo to binaries)
install_github_release "Automattic/harper" "x86_64-unknown-linux-gnu.tar.gz" "harper-ls"

# --- NPM Packages ---
install_npm_lsp "bash-language-server"
install_npm_lsp "pyright"
install_npm_lsp "@vtsls/language-server" # Note: you need to link 'vtsls' or call it via its bin name

# Cleanup
rm -rf "$TMP_DIR"
echo "Done!"
