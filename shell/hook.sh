# agent-picker shell 钩子（zsh / bash 通用），由 ~/.zshrc 或 ~/.bashrc 引入
# 在第一次显示提示符前弹出菜单，避免和 .zshrc 里其他插件（如 p10k instant prompt）的初始化输出冲突

AGENT_PICKER_HOME="${AGENT_PICKER_HOME:-$HOME/.agent-picker}"
case ":$PATH:" in
  *":$AGENT_PICKER_HOME/bin:"*) ;;
  *) export PATH="$AGENT_PICKER_HOME/bin:$PATH" ;;
esac

case $- in *i*) ;; *) return 0 ;; esac
[ -n "${AGENT_PICKER_ACTIVE:-}" ] && return 0

_agent_picker_once() {
  if [ -n "${ZSH_VERSION:-}" ]; then
    add-zsh-hook -d precmd _agent_picker_once
  else
    PROMPT_COMMAND="${_AGENT_PICKER_OLD_PC-}"
  fi
  unset -f _agent_picker_once
  agent-picker launch
}

if [ -n "${ZSH_VERSION:-}" ]; then
  autoload -Uz add-zsh-hook
  add-zsh-hook precmd _agent_picker_once
elif [ -n "${BASH_VERSION:-}" ]; then
  _AGENT_PICKER_OLD_PC="${PROMPT_COMMAND-}"
  PROMPT_COMMAND="_agent_picker_once${PROMPT_COMMAND:+;$PROMPT_COMMAND}"
fi
