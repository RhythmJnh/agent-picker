# agent-picker 界面文案（中英双语），由 bin/agent-picker 引入
# 语言优先级：AGENT_PICKER_LANG > 配置 lang > LC_ALL/LC_MESSAGES/LANG > macOS 系统首选语言 > 英文

detect_lang() {
  local v="${AGENT_PICKER_LANG:-}"
  [ -z "$v" ] && v=$(cfg_get lang)
  case "$v" in zh*) echo zh; return ;; en*) echo en; return ;; esac
  case "${LC_ALL:-${LC_MESSAGES:-${LANG:-}}}" in
    zh*) echo zh; return ;;
    ''|C|C.*|POSIX) ;;
    *) echo en; return ;;
  esac
  if [ "$(uname -s)" = Darwin ] && defaults read -g AppleLanguages 2>/dev/null | sed -n 2p | grep -q zh; then
    echo zh; return
  fi
  echo en
}

# say 文案变量名 [参数...]：按文案格式输出一行
say() {
  case "$1" in ''|[TE]_*[!A-Z_]*|[!TE]*|?[!_]*) return 1 ;; esac
  local fmt; eval "fmt=\$$1"; shift; printf "$fmt\n" "$@"
}
die() { local fmt; eval "fmt=\$$1"; shift; printf "agent-picker: $fmt\n" "$@" >&2; exit 1; }

load_strings() {
  UI_LANG=$(detect_lang)
  if [ "$UI_LANG" = zh ]; then load_strings_zh; else load_strings_en; fi
}

load_strings_zh() {
  T_TITLE="选择要启动的 agent"
  T_TITLE_DEFAULT="选择默认 agent"
  T_DEFAULT_TAG="★ 默认"
  T_SHELL_DESC="不启动 agent"
  T_HINT="↑↓/数字 选择 · Enter 启动 · d 设为默认 · q 进 shell"
  T_COUNTDOWN="%ds 后启动 %s"
  T_NO_AGENTS="agent-picker: 没有检测到已安装的 agent（agent-picker list 查看支持列表）"
  T_HIDDEN="已隐藏"
  T_INSTALLED="✓ 已安装"
  T_MISSING="- 未安装"
  T_DEFAULT_IS="默认 agent: %s"
  T_MODE_IS="模式: %s"
  T_TIMEOUT_IS="倒计时: %ss"
  T_LANG_IS="界面语言: %s（当前生效: %s）"
  T_ADDED="已添加: %s → %s"
  T_HID_BUILTIN="已隐藏内置项: %s"
  T_REMOVED="已删除: %s"
  T_DEFAULT_RESET="默认项已重置为 shell"
  T_CONFIG_PATHS="配置文件: %s\n自定义 agent: %s\n"
  T_UNINSTALLED_PURGE="已卸载，并删除配置 %s"
  T_UNINSTALLED="已卸载（配置保留在 %s，加 --purge 一并删除）"
  T_INSTALLED_TO="已安装到 %s，钩子写入:%s"
  T_NO_RC="没找到 ~/.zshrc 或 ~/.bashrc，未挂载钩子"
  T_INSTALL_FINISH="完成。新开一个终端窗口即可看到选择菜单。\n常用: agent-picker default <id> | mode ask|auto|off | timeout <秒> | lang auto|zh|en"
  T_AGENTS_HEADER="# 自定义 agent，每行一个：id|显示名|启动命令\n# 与内置 id 相同会覆盖内置项；启动命令写 - 表示隐藏该项\n# 例：myagent|My Agent|npx my-agent --flag"
  E_CONFIG_DIR="无法创建配置目录 %s"
  E_UNKNOWN="未知的 agent: %s（agent-picker list 查看可用 id）"
  E_MODE="模式只能是 ask（弹菜单）/ auto（直接启动默认）/ off（关闭）"
  E_TIMEOUT="timeout 需要 0-600 之间的整数秒（0 表示一直等待）"
  E_LANG="语言只能是 auto / zh / en"
  E_ADD_USAGE="用法: agent-picker add <id> <显示名> <启动命令>"
  E_REMOVE_USAGE="用法: agent-picker remove <id>"
  E_ID="id 只能包含小写字母、数字、- 和 _"
  E_RESERVED="shell 是保留 id"
  E_PIPE="显示名和启动命令里不能包含 |"
  T_USAGE="agent-picker $VERSION — 打开终端时选择要启动的 CLI agent

用法:
  agent-picker                  弹出菜单选择并启动
  agent-picker list             列出支持的 agent 及安装状态
  agent-picker default [id]     查看/设置默认 agent（不带 id 时弹菜单选）
  agent-picker mode [ask|auto|off]
                                ask=打开终端弹菜单  auto=直接启动默认  off=关闭
  agent-picker timeout [秒]      菜单倒计时，到时启动默认项（0=一直等）
  agent-picker lang [auto|zh|en] 界面语言，auto 跟随系统
  agent-picker add <id> <名称> <命令>   添加自定义 agent
  agent-picker remove <id>      删除自定义 agent / 隐藏内置 agent
  agent-picker config           查看配置
  agent-picker uninstall [--purge]

临时跳过: AGENT_PICKER=0 打开终端，或在菜单里按 q"
}

load_strings_en() {
  T_TITLE="Choose an agent to launch"
  T_TITLE_DEFAULT="Choose the default agent"
  T_DEFAULT_TAG="★ default"
  T_SHELL_DESC="no agent"
  T_HINT="↑↓/number select · Enter launch · d set default · q shell"
  T_COUNTDOWN="launching in %ds: %s"
  T_NO_AGENTS="agent-picker: no installed agents found (run agent-picker list to see supported ones)"
  T_HIDDEN="hidden"
  T_INSTALLED="✓ installed"
  T_MISSING="- not installed"
  T_DEFAULT_IS="Default agent: %s"
  T_MODE_IS="Mode: %s"
  T_TIMEOUT_IS="Countdown: %ss"
  T_LANG_IS="Language: %s (in effect: %s)"
  T_ADDED="Added: %s → %s"
  T_HID_BUILTIN="Hid built-in agent: %s"
  T_REMOVED="Removed: %s"
  T_DEFAULT_RESET="Default reset to shell"
  T_CONFIG_PATHS="Config: %s\nCustom agents: %s\n"
  T_UNINSTALLED_PURGE="Uninstalled and deleted config %s"
  T_UNINSTALLED="Uninstalled (config kept in %s; add --purge to delete it)"
  T_INSTALLED_TO="Installed to %s, hook added to:%s"
  T_NO_RC="No ~/.zshrc or ~/.bashrc found; hook not installed"
  T_INSTALL_FINISH="Done. Open a new terminal window to see the menu.\nHandy: agent-picker default <id> | mode ask|auto|off | timeout <sec> | lang auto|zh|en"
  T_AGENTS_HEADER="# Custom agents, one per line: id|display name|launch command\n# Reusing a built-in id overrides it; a launch command of - hides it\n# e.g. myagent|My Agent|npx my-agent --flag"
  E_CONFIG_DIR="cannot create config directory %s"
  E_UNKNOWN="unknown agent: %s (run agent-picker list to see ids)"
  E_MODE="mode must be ask (show menu) / auto (launch default) / off (disabled)"
  E_TIMEOUT="timeout must be a whole number of seconds from 0 to 600 (0 = wait)"
  E_LANG="language must be auto / zh / en"
  E_ADD_USAGE="usage: agent-picker add <id> <display name> <launch command>"
  E_REMOVE_USAGE="usage: agent-picker remove <id>"
  E_ID="id may only contain lowercase letters, digits, - and _"
  E_RESERVED="shell is a reserved id"
  E_PIPE="display name and launch command must not contain |"
  T_USAGE="agent-picker $VERSION — pick which CLI agent to launch when a terminal opens

Usage:
  agent-picker                  open the menu and launch the choice
  agent-picker list             list supported agents and install status
  agent-picker default [id]     show/set the default agent (no id: pick from a menu)
  agent-picker mode [ask|auto|off]
                                ask=menu on new terminal  auto=launch default  off=disabled
  agent-picker timeout [sec]    menu countdown before launching the default (0=wait)
  agent-picker lang [auto|zh|en] interface language; auto follows the system
  agent-picker add <id> <name> <command>   add a custom agent
  agent-picker remove <id>      remove a custom agent / hide a built-in one
  agent-picker config           show the config
  agent-picker uninstall [--purge]

Skip once: open the terminal with AGENT_PICKER=0, or press q in the menu"
}
