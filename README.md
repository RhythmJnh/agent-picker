# agent-picker

English | [简体中文](README.zh-CN.md)

> Open a terminal, pick an agent.

You have several CLI agents installed (Claude Code, Codex, OpenClaw, Gemini CLI, …) and you type a command to launch one every time you open a terminal.
**agent-picker** shows a small menu when a new terminal opens. It lists the agents installed on your machine and launches your default after 3 seconds if you don't press anything. Press a number to launch a different one. When the agent exits, you're back in your normal shell.

```
Choose an agent to launch
  ❯ 1  Claude Code          claude  ★ default
    2  OpenClaw             openclaw tui
    3  Shell                no agent
  ↑↓/number select · Enter launch · d set default · q shell  launching in 3s: Claude Code
```

## Features

- **Auto-detection**: 15 popular CLI agents are built in. Only the ones you have installed are shown, and you can add your own.
- **Stays out of the way**: a 3-second countdown launches your default. You can also launch it straight away or wait for your choice.
- **No surprises**: the menu is skipped in IDE terminals, in SSH sessions and in shells opened from inside an agent.
- **No dependencies**: plain bash that runs on the bash 3.2 bundled with macOS. Supports zsh and bash.
- **English and Chinese**: the interface follows your system language, or you can set it yourself.
- **Clean uninstall**: one marked block is appended to your rc file, and only that block is removed on uninstall.

## Install

```bash
git clone https://github.com/RhythmJnh/agent-picker.git
cd agent-picker
./install.sh
```

The installer:

1. copies the program to `~/.agent-picker`
2. appends a hook to `~/.zshrc` (and to `~/.bashrc` if it exists)
3. lists the detected agents and asks you to pick a default

Open a new terminal window to see the menu. For a non-interactive install, use `./install.sh --yes`, which picks the first detected agent as the default.

No agents installed yet? See the [CLI agent install guide](docs/agents.md).

## Usage

### Menu keys

| Key | Action |
|---|---|
| `↑` `↓` / `j` `k` | Move |
| `1`–`9` | Launch that item |
| `Enter` | Launch the selected item |
| `d` | Make the selected item the default |
| `q` / `Esc` / `Ctrl+D` | Skip the agent and drop into your shell |

### Commands

```bash
agent-picker                     # open the menu manually
agent-picker list                # list supported agents and whether they're installed
agent-picker default openclaw    # set the default agent (no argument: choose from a menu)
agent-picker mode auto           # ask = show menu (default)  auto = launch default  off = disabled
agent-picker timeout 3           # countdown in seconds, 0 = wait for your choice
agent-picker lang en             # interface language: auto (follow system) | zh | en
agent-picker add cc-yolo "Claude YOLO" "claude --dangerously-skip-permissions"
agent-picker remove cc-yolo      # remove a custom agent, or hide a built-in one
agent-picker config              # show the config
agent-picker uninstall [--purge] # uninstall; --purge also deletes the config
```

To open a plain terminal once, run `AGENT_PICKER=0 zsh` or press `q` in the menu.

## Supported agents

| id | Name | Launch command |
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

To add an agent that isn't listed, use `agent-picker add`. To change how a built-in agent launches, `add` it again with the same id and the new command.

## Configuration

Config lives in `~/.config/agent-picker/` (`XDG_CONFIG_HOME` is respected).

`config`:

```ini
default=claude   # id of the default agent; "shell" means default to a plain terminal
mode=ask         # ask | auto | off
timeout=3        # countdown in seconds, 0 = wait
lang=auto        # auto | zh | en
skip_ide=1       # skip in VS Code / Cursor / JetBrains terminals
skip_ssh=1       # skip in SSH sessions
skip_tmux=0      # skip inside tmux
```

With `lang=auto`, the language is taken from `LC_ALL` / `LC_MESSAGES` / `LANG`. If none of these is set, macOS's preferred system language is used. Chinese locales get Chinese, and everything else gets English. The `AGENT_PICKER_LANG` environment variable overrides all of this.

`agents`: custom agents, one per line, as `id|display name|launch command`. A launch command of `-` hides that entry.

## How it works

- The hook runs once, just before the **first prompt**, through zsh's `precmd` (or `PROMPT_COMMAND` in bash). By then your `.zshrc` has finished loading, so PATH changes from tools like nvm are in place, and nothing clashes with plugins that print during startup, such as the powerlevel10k instant prompt.
- The chosen agent is started with `exec`, with `AGENT_PICKER_ACTIVE=1` set so shells opened from inside the agent don't show the menu again.
- When the agent exits, you're back in the original shell.

## Development

```bash
bash tests/run.sh
```

The tests use a temporary HOME and fake agent commands, and simulate key presses in a pseudo-terminal created with `script`. Your real config is never touched.

## License

[MIT](LICENSE)
