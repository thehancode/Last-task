#!/usr/bin/env bash
# Build and install the Linux release bundle for local use.
#
# Optional overrides:
#   LAST_TASK_INSTALL_DIR=/somewhere scripts/install-linux.sh
#   LAST_TASK_BIN_DIR=/somewhere/bin scripts/install-linux.sh

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
bundle_dir="$repo_root/build/linux/x64/release/bundle"
binary_name="flutter_app"
logo_source="$repo_root/assets/icons/logo.svg"
install_dir="${LAST_TASK_INSTALL_DIR:-$HOME/.local/opt/last-task}"
bin_dir="${LAST_TASK_BIN_DIR:-$HOME/.local/bin}"
command_name="last-task"
staging_dir="${install_dir}.new"
data_dir="${XDG_DATA_HOME:-$HOME/.local/share}"
desktop_dir="$data_dir/applications"
icon_dir="$data_dir/icons/hicolor/scalable/apps"
desktop_file="$desktop_dir/last-task.desktop"
autostart_file="$HOME/.config/autostart/last-task.desktop"

case "$install_dir" in
  /|"$HOME"|"$HOME/.local"|"$HOME/.local/opt")
    echo "Refusing unsafe install directory: $install_dir" >&2
    exit 1
    ;;
esac

cd "$repo_root"

if [[ ! -f "$logo_source" ]]; then
  echo "Application logo is missing: $logo_source" >&2
  exit 1
fi

flutter build linux --release

if [[ ! -x "$bundle_dir/$binary_name" ]]; then
  echo "Release bundle is missing $binary_name: $bundle_dir" >&2
  exit 1
fi

rm -rf "$staging_dir"
mkdir -p "$staging_dir"
cp -a "$bundle_dir/." "$staging_dir/"

mkdir -p "$(dirname "$install_dir")" "$bin_dir"
rm -rf "$install_dir"
mv "$staging_dir" "$install_dir"
ln -sfn "$install_dir/$binary_name" "$bin_dir/$command_name"

# Install the Last Task icon, menu, and login entries.  The hicolor location
# is the standard icon-theme path used by Linux desktop environments.
mkdir -p "$icon_dir" "$desktop_dir" "$(dirname "$autostart_file")"
install -m 0644 "$logo_source" "$icon_dir/$command_name.svg"
cat >"$desktop_file" <<EOF
[Desktop Entry]
Type=Application
Name=Last Task
GenericName=Task List
Comment=Open your keyboard-first task list
Exec=$bin_dir/$command_name
Icon=last-task
Terminal=false
Categories=Office;
StartupNotify=true
StartupWMClass=com.tuikanban.flutter_app
Keywords=last;task;tasks;todo;
EOF

cat >"$autostart_file" <<EOF
[Desktop Entry]
Type=Application
Name=Last Task
Comment=Open Last Task at login
Exec=$bin_dir/$command_name
Icon=last-task
Terminal=false
StartupNotify=false
X-GNOME-Autostart-enabled=true
OnlyShowIn=GNOME;Unity;
EOF

if command -v gtk-update-icon-cache >/dev/null 2>&1; then
  gtk-update-icon-cache --force "$data_dir/icons/hicolor" >/dev/null 2>&1 || true
fi

echo "Installed $command_name to $install_dir"
echo "Run it with: $bin_dir/$command_name"
