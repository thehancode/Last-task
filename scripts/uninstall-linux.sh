#!/usr/bin/env bash
# Uninstall the legacy Focus List Linux application bundle.
#
# This removes only files installed by the former scripts/install-linux.sh.
# It intentionally preserves your task data under the platform application
# support directory so it remains available after reinstalling Last Task.
#
# Optional overrides:
#   FOCUS_LIST_INSTALL_DIR=/somewhere scripts/uninstall-linux.sh
#   FOCUS_LIST_BIN_DIR=/somewhere/bin scripts/uninstall-linux.sh

set -euo pipefail

install_dir="${FOCUS_LIST_INSTALL_DIR:-$HOME/.local/opt/focus-list}"
bin_dir="${FOCUS_LIST_BIN_DIR:-$HOME/.local/bin}"
command_name="focus-list"
data_dir="${XDG_DATA_HOME:-$HOME/.local/share}"
desktop_file="$data_dir/applications/tui-kanban.desktop"
autostart_file="$HOME/.config/autostart/tui-kanban.desktop"
launcher="$bin_dir/$command_name"
expected_binary="$install_dir/flutter_app"

case "$install_dir" in
  /|"$HOME"|"$HOME/.local"|"$HOME/.local/opt")
    echo "Refusing unsafe install directory: $install_dir" >&2
    exit 1
    ;;
esac

if [[ -L "$launcher" ]]; then
  launcher_target="$(readlink "$launcher")"
  if [[ "$launcher_target" == "$expected_binary" ]]; then
    rm "$launcher"
    echo "Removed launcher: $launcher"
  else
    echo "Kept launcher because it does not point to Focus List: $launcher"
  fi
elif [[ -e "$launcher" ]]; then
  echo "Kept non-symlink launcher: $launcher"
fi

for file in "$desktop_file" "$autostart_file"; do
  if [[ -f "$file" ]] && grep -Fqx "Exec=$launcher" "$file"; then
    rm "$file"
    echo "Removed entry: $file"
  elif [[ -e "$file" ]]; then
    echo "Kept entry with an unexpected command: $file"
  fi
done

if [[ -e "$install_dir" || -L "$install_dir" ]]; then
  rm -rf "$install_dir"
  echo "Removed application bundle: $install_dir"
fi

echo "Focus List has been uninstalled. Your task data was preserved."
