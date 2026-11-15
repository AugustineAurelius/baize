#!/usr/bin/env bash
set -euo pipefail
setup_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/nvim-rust"
install_dir="$HOME/.local/opt"
bin_dir="$HOME/.local/bin"
if [[ -e "$config_dir" ]]; then
  echo "Already exists: $config_dir. Move it aside before installing." >&2
  exit 1
fi
if [[ "$(uname -m)" != x86_64 ]]; then
  echo "This installer requires x86_64 WSL." >&2
  exit 1
fi
for tool in curl git tar rustup python3; do
  command -v "$tool" >/dev/null || { echo "Missing: $tool" >&2; exit 1; }
done
temp_dir="$(mktemp -d)"
trap 'rm -rf -- "$temp_dir"' EXIT
curl -fL https://github.com/neovim/neovim/releases/download/v0.12.6/nvim-linux-x86_64.tar.gz -o "$temp_dir/nvim.tar.gz"
mkdir -p "$install_dir" "$bin_dir" "$(dirname "$config_dir")"
if ! command -v unzip >/dev/null || ! command -v rg >/dev/null; then
  (cd "$temp_dir" && apt-get download unzip ripgrep)
  for package in "$temp_dir"/*.deb; do
    dpkg-deb -x "$package" "$temp_dir/dependencies"
  done
  cp "$temp_dir/dependencies/usr/bin/unzip" "$temp_dir/dependencies/usr/bin/rg" "$bin_dir/"
fi
tar -xzf "$temp_dir/nvim.tar.gz" -C "$install_dir"
git clone --depth 1 https://github.com/NvChad/starter "$config_dir"
cp -R "$setup_dir/lua/." "$config_dir/lua/"
mkdir -p "$config_dir/after"
cp -R "$setup_dir/after/." "$config_dir/after/"
rustup component add rust-analyzer rust-src rustfmt clippy
cat > "$bin_dir/nvim-rust" <<'WRAPPER'
#!/usr/bin/env bash
export NVIM_APPNAME=nvim-rust
export PATH="$HOME/.local/share/nvim-rust/mason/bin:$HOME/.cargo/bin:$HOME/.local/bin:$PATH"
exec "$HOME/.local/opt/nvim-linux-x86_64/bin/nvim" "$@"
WRAPPER
chmod +x "$bin_dir/nvim-rust"
"$bin_dir/nvim-rust" --headless '+Lazy! sync' +qa > "$temp_dir/plugins.log" 2>&1 || {
  cat "$temp_dir/plugins.log" >&2
  exit 1
}
BAIZE_NVIM_BOOTSTRAP="$setup_dir/bootstrap.lua" "$bin_dir/nvim-rust" --headless \
  '+lua local ok, err = pcall(dofile, os.getenv("BAIZE_NVIM_BOOTSTRAP")); if not ok then print(err); vim.cmd("cquit 1") end' +qa
echo "Run: $bin_dir/nvim-rust"
