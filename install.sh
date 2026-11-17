#!/usr/bin/env bash
# 安装 agent-picker：复制到 ~/.agent-picker，并在 shell rc 中挂上钩子
#   ./install.sh          安装并选择默认 agent
#   ./install.sh --yes    非交互安装（默认 agent 取第一个检测到的）
set -euo pipefail

SRC="$(cd "$(dirname "$0")" && pwd)"
DEST="${AGENT_PICKER_HOME:-$HOME/.agent-picker}"
BIN="$DEST/bin/agent-picker"

mkdir -p "$DEST/bin"
cp "$SRC/bin/agent-picker" "$BIN"
cp "$SRC/shell/hook.sh" "$DEST/hook.sh"
chmod +x "$BIN"

export AGENT_PICKER_HOME="$DEST"
installed_rc=""
case "${SHELL:-}" in */zsh) touch "$HOME/.zshrc" ;; esac
for rc in "$HOME/.zshrc" "$HOME/.bashrc"; do
  if [ -f "$rc" ]; then
    "$BIN" _rc-add "$rc"
    installed_rc="$installed_rc $rc"
  fi
done
[ -n "$installed_rc" ] || { echo "没找到 ~/.zshrc 或 ~/.bashrc，未挂载钩子" >&2; exit 1; }

echo "已安装到 ${DEST}，钩子写入:$installed_rc"
echo
"$BIN" list
echo

if [ "${1:-}" != "--yes" ] && [ -t 0 ] && [ -t 1 ]; then
  "$BIN" default
fi

echo
echo "完成。新开一个终端窗口即可看到选择菜单。"
echo "常用: agent-picker default <id> | mode ask|auto|off | timeout <秒> | add <id> <名称> <命令>"
