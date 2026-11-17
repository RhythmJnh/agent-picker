# agent-picker

[English](README.md) | 简体中文

> 打开终端，先选 agent。

电脑上装了好几个 CLI agent：Claude Code、Codex、OpenClaw、Gemini CLI……每次打开终端都要手动输入命令再启动。
**agent-picker** 在你新开终端时弹出一个小菜单，列出本机已安装的 agent，3 秒内不按键就自动启动默认的那个，想换就按一下数字。agent 退出后回到普通 shell。

```
选择要启动的 agent
  ❯ 1  Claude Code          claude  ★ 默认
    2  OpenClaw             openclaw tui
    3  Shell                不启动 agent
  ↑↓/数字 选择 · Enter 启动 · d 设为默认 · q 进 shell  3s 后启动 Claude Code
```

## 特性

- **自动识别**：内置 15 个常见 CLI agent，只显示本机已安装的，也可以添加自定义 agent
- **零打扰**：默认 3 秒倒计时后自动启动默认 agent；也可以设成直接启动或一直等你选
- **不添乱**：IDE 内置终端、SSH 会话、agent 内部打开的子 shell 都不会弹出
- **零依赖**：纯 bash 编写，兼容 macOS 自带的 bash 3.2，支持 zsh 和 bash
- **干净卸载**：只在 rc 文件末尾写入一段带标记的代码，卸载时只删这一段

## 安装

```bash
git clone https://github.com/RhythmJnh/agent-picker.git
cd agent-picker
./install.sh
```

安装脚本会：

1. 把程序复制到 `~/.agent-picker`
2. 在 `~/.zshrc`（以及已存在的 `~/.bashrc`）末尾加上钩子
3. 列出检测到的 agent，并让你选一个默认项

装好后新开一个终端窗口就能看到菜单。非交互安装用 `./install.sh --yes`，默认项会取检测到的第一个 agent。

还没装 agent？看 [各 CLI agent 安装说明](docs/agents.zh-CN.md)。

## 使用

### 菜单按键

| 按键 | 作用 |
|---|---|
| `↑` `↓` / `j` `k` | 移动 |
| `1`–`9` | 直接启动对应项 |
| `Enter` | 启动当前项 |
| `d` | 把当前项设为默认 |
| `q` / `Esc` / `Ctrl+D` | 不启动 agent，进入普通 shell |

### 命令

```bash
agent-picker                     # 手动弹出菜单
agent-picker list                # 列出支持的 agent 及安装状态
agent-picker default openclaw    # 设置默认 agent（不带参数则弹菜单选）
agent-picker mode auto           # ask=弹菜单（默认）  auto=直接启动默认  off=关闭
agent-picker timeout 3           # 倒计时秒数，0=一直等你选
agent-picker add cc-yolo "Claude YOLO" "claude --dangerously-skip-permissions"
agent-picker remove cc-yolo      # 删除自定义项；对内置项则是隐藏
agent-picker config              # 查看配置
agent-picker uninstall [--purge] # 卸载，--purge 连配置一起删
```

想临时打开一个普通终端：`AGENT_PICKER=0 zsh`，或在菜单里按 `q`。

## 支持的 agent

| id | 名称 | 启动命令 |
|---|---|---|
| `claude` | Claude Code | `claude` |
| `codex` | Codex CLI | `codex` |
| `openclaw` | OpenClaw | `openclaw tui` |
| `gemini` | Gemini CLI | `gemini` |
| `opencode` | OpenCode | `opencode` |
| `qwen` | Qwen Code | `qwen` |
| `aider` | Aider | `aider` |
| `goose` | Goose | `goose session` |
| `crush` | Crush | `crush` |
| `cursor` | Cursor CLI | `cursor-agent` |
| `copilot` | GitHub Copilot CLI | `copilot` |
| `amp` | Amp | `amp` |
| `droid` | Factory Droid | `droid` |
| `kimi` | Kimi CLI | `kimi` |
| `iflow` | iFlow CLI | `iflow` |

不在列表里的 agent，用 `agent-picker add` 加进来即可。想改内置 agent 的启动参数，用同一个 id 再 `add` 一次就会覆盖。

## 配置

配置放在 `~/.config/agent-picker/`（遵循 `XDG_CONFIG_HOME`）。

`config`：

```ini
default=claude   # 默认 agent 的 id，shell 表示默认进普通终端
mode=ask         # ask | auto | off
timeout=3        # 倒计时秒数，0=一直等
skip_ide=1       # VS Code / Cursor / JetBrains 内置终端不弹出
skip_ssh=1       # SSH 会话不弹出
skip_tmux=0      # tmux 中不弹出
```

`agents`：自定义 agent，每行一个，格式 `id|显示名|启动命令`。启动命令写成 `-` 表示隐藏这一项。

## 工作原理

- 钩子挂在 zsh 的 `precmd`（bash 用 `PROMPT_COMMAND`）上，只在**第一次显示提示符前**触发一次。这时 `.zshrc` 已经加载完，nvm 之类设置的 PATH 都已生效，也不会和 powerlevel10k instant prompt 等插件的初始化输出冲突。
- 选中 agent 后用 `exec` 启动它，并设置 `AGENT_PICKER_ACTIVE=1`，这样 agent 里再开的子 shell 不会再弹菜单。
- agent 退出后，回到原来的 shell。

## 开发

```bash
bash tests/run.sh
```

测试使用临时 HOME 和假的 agent 命令，通过 `script` 创建伪终端来模拟按键，不会动你的真实配置。

## License

[MIT](LICENSE)
