#!/usr/bin/env bash
# agent-picker 测试：隔离的 HOME + 假 agent 命令，不碰真实配置
set -u

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PASS=0; FAIL=0

setup() {
  T="$(mktemp -d)"
  export HOME="$T/home" AGENT_PICKER_HOME="$T/home/.agent-picker"
  export AGENT_PICKER_CONFIG_DIR="$T/home/.config/agent-picker"
  unset AGENT_PICKER_ACTIVE CLAUDECODE TMUX SSH_CONNECTION SSH_TTY TERM_PROGRAM AGENT_PICKER
  mkdir -p "$HOME" "$T/stubs"
  for c in claude codex; do
    printf '#!/bin/sh\necho "STUB_%s_RAN $* active=$AGENT_PICKER_ACTIVE"\n' "$c" > "$T/stubs/$c"
    chmod +x "$T/stubs/$c"
  done
  export PATH="$T/stubs:/usr/bin:/bin"
  AP="$ROOT/bin/agent-picker"
}
teardown() { rm -rf "$T"; }

check() { # 描述 期望子串 实际输出
  if printf '%s' "$3" | grep -qF -- "$2"; then PASS=$((PASS + 1)); printf '  ✓ %s\n' "$1"
  else FAIL=$((FAIL + 1)); printf '  ✗ %s\n    期望包含: %s\n    实际: %s\n' "$1" "$2" "$3"; fi
}
check_not() {
  if printf '%s' "$3" | grep -qF -- "$2"; then FAIL=$((FAIL + 1)); printf '  ✗ %s\n    不应包含: %s\n' "$1" "$2"
  else PASS=$((PASS + 1)); printf '  ✓ %s\n' "$1"; fi
}
in_pty() { # stdin 作为按键输入，在伪终端里运行命令
  script -q /dev/null "$@" 2>&1 | tr -d '\r'
}
keys() { # 等菜单进入 raw 模式后再发送按键，并保持输入不立刻 EOF
  sleep 0.5; printf "$1"; sleep 1
}

echo "检测与配置"
setup
out=$("$AP" list)
check "检测到已安装的 claude" "claude     Claude Code          claude             ✓ 已安装" "$out"
check "未安装的 gemini 标记为未安装" "- 未安装" "$(echo "$out" | grep gemini)"
check "首次运行默认取第一个已安装 agent" "★ claude" "$out"
check "default 设置" "默认 agent: codex" "$("$AP" default codex)"
check "default 拒绝未知 id" "未知的 agent" "$("$AP" default nope 2>&1)"
check "mode 校验" "模式只能是" "$("$AP" mode weird 2>&1)"
"$AP" mode auto >/dev/null
check "mode 写入" "auto" "$("$AP" mode)"
check "timeout 校验" "0-600" "$("$AP" timeout abc 2>&1)"
"$AP" timeout 3 >/dev/null
check "timeout 写入且不重复" "1" "$(grep -c '^timeout=' "$AGENT_PICKER_CONFIG_DIR/config")"
teardown

echo "自定义 agent"
setup
check "add 拒绝非法 id" "id 只能包含" "$("$AP" add 'Bad Id' X y 2>&1)"
check "add 拒绝 |" "不能包含" "$("$AP" add my 'a|b' y 2>&1)"
"$AP" add my "My Agent" "codex --profile x" >/dev/null
check "自定义 agent 被检测" "my         My Agent" "$("$AP" list)"
"$AP" add my "My Agent 2" "codex" >/dev/null
check "同 id 覆盖而非重复" "1" "$(grep -c '^my|' "$AGENT_PICKER_CONFIG_DIR/agents")"
"$AP" default claude >/dev/null
"$AP" remove claude >/dev/null
check "remove 隐藏内置项" "已隐藏" "$("$AP" list | grep claude)"
check "删除默认项后重置为 shell" "shell" "$("$AP" default </dev/null)"
"$AP" remove my >/dev/null
check_not "remove 删除自定义项" "My Agent" "$("$AP" list)"
teardown

echo "启动行为"
setup
check_not "非 tty 时 launch 静默跳过" "STUB_" "$("$AP" launch)"
"$AP" default codex >/dev/null; "$AP" mode auto >/dev/null
out=$(in_pty "$AP" launch </dev/null)
check "auto 模式直接启动默认" "STUB_codex_RAN" "$out"
check "agent 继承 AGENT_PICKER_ACTIVE 防止嵌套弹出" "active=1" "$out"
check_not "AGENT_PICKER=0 跳过" "STUB_" "$(AGENT_PICKER=0 in_pty "$AP" launch </dev/null)"
check_not "嵌套在 agent 内跳过" "STUB_" "$(AGENT_PICKER_ACTIVE=1 in_pty "$AP" launch </dev/null)"
"$AP" mode off >/dev/null
check_not "off 模式不弹出" "STUB_" "$(in_pty "$AP" launch </dev/null)"
"$AP" mode ask >/dev/null; "$AP" timeout 1 >/dev/null
check "ask 模式倒计时后启动默认" "STUB_codex_RAN" "$(sleep 3 | in_pty "$AP" launch)"
check_not "Ctrl+D 进入 shell" "STUB_" "$(in_pty "$AP" pick </dev/null)"
check "数字键选择" "STUB_claude_RAN" "$(keys '1' | in_pty "$AP" pick)"
check "方向键 + 回车选择" "STUB_claude_RAN" "$(keys '\033[B\033[B\r' | in_pty "$AP" pick)"
check_not "q 进入 shell 不启动" "STUB_" "$(keys 'q' | in_pty "$AP" pick)"
keys 'kd\r' | in_pty "$AP" pick >/dev/null
check "菜单内按 d 设为默认" "claude" "$("$AP" default </dev/null)"
teardown

echo "安装与卸载"
setup
printf 'export FOO=1\n' > "$HOME/.zshrc"
"$ROOT/install.sh" --yes >/dev/null
"$ROOT/install.sh" --yes >/dev/null
check "rc 钩子只写入一次" "1" "$(grep -c '>>> agent-picker >>>' "$HOME/.zshrc")"
check "保留原 rc 内容" "export FOO=1" "$(cat "$HOME/.zshrc")"
check "可执行文件已安装" "0.1.0" "$("$AGENT_PICKER_HOME/bin/agent-picker" --version)"
out=$(zsh -c ". '$AGENT_PICKER_HOME/hook.sh'; echo \$PATH")
check "非交互 shell 只加 PATH" "$AGENT_PICKER_HOME/bin" "$out"
out=$(zsh -ic 'typeset -f _agent_picker_once >/dev/null && echo HOOKED' 2>/dev/null)
check "交互 zsh 注册 precmd 钩子" "HOOKED" "$out"
"$AGENT_PICKER_HOME/bin/agent-picker" uninstall --purge >/dev/null
check_not "卸载移除 rc 钩子" "agent-picker" "$(cat "$HOME/.zshrc")"
check "卸载后 rc 原内容还在" "export FOO=1" "$(cat "$HOME/.zshrc")"
[ -e "$AGENT_PICKER_HOME" ] && r=exists || r=gone
check "卸载删除安装目录" "gone" "$r"
teardown

echo
echo "通过 ${PASS}，失败 $FAIL"
[ "$FAIL" -eq 0 ]
