# CLI agent install guide

English | [简体中文](agents.zh-CN.md)

These are the usual ways to install the CLI agents that agent-picker supports out of the box. After installing one, run `agent-picker list`. Anything marked `✓ 已安装` (installed) shows up in the menu.

> Install commands change as the projects evolve. If anything here disagrees with the official docs, follow the official docs. Many of these agents need Node.js 18+, so install Node first with [nvm](https://github.com/nvm-sh/nvm) or Homebrew.

## Claude Code

Anthropic's terminal coding agent. [Docs](https://docs.anthropic.com/en/docs/claude-code)

```bash
curl -fsSL https://claude.ai/install.sh | bash
# or
npm install -g @anthropic-ai/claude-code
```

Launch: `claude`

## Codex CLI

OpenAI's terminal coding agent. [Repo](https://github.com/openai/codex)

```bash
npm install -g @openai/codex
# or
brew install --cask codex
```

Launch: `codex`

## OpenClaw

An open-source personal AI assistant that connects to many chat channels. [Repo](https://github.com/openclaw/openclaw)

```bash
npm install -g openclaw@latest
openclaw onboard     # first-time setup
```

agent-picker launches it with `openclaw tui`, which needs the Gateway running. To use local mode instead, override it:

```bash
agent-picker add openclaw "OpenClaw" "openclaw chat"
```

## Gemini CLI

From Google. [Repo](https://github.com/google-gemini/gemini-cli)

```bash
npm install -g @google/gemini-cli
# or
brew install gemini-cli
```

Launch: `gemini`

## OpenCode

An open-source terminal coding agent that works with many model providers. [Website](https://opencode.ai)

```bash
curl -fsSL https://opencode.ai/install | bash
# or
npm install -g opencode-ai
```

Launch: `opencode`

## Qwen Code

From Alibaba's Qwen team, built on Gemini CLI. [Repo](https://github.com/QwenLM/qwen-code)

```bash
npm install -g @qwen-code/qwen-code
```

Launch: `qwen`

## Aider

Open-source AI pair programming in the terminal, with deep git integration. [Website](https://aider.chat)

```bash
python -m pip install aider-install
aider-install
```

Launch: `aider`

## Goose

Block's open-source local agent. [Repo](https://github.com/block/goose)

```bash
brew install block-goose-cli
# or
curl -fsSL https://github.com/block/goose/releases/download/stable/download_cli.sh | bash
```

Launch: `goose session`

## Crush

Charm's terminal coding agent. [Repo](https://github.com/charmbracelet/crush)

```bash
brew install charmbracelet/tap/crush
# or
npm install -g @charmland/crush
```

Launch: `crush`

## Cursor CLI

Cursor's command-line agent. [Docs](https://docs.cursor.com/cli)

```bash
curl https://cursor.com/install -fsS | bash
```

Launch: `cursor-agent`

## GitHub Copilot CLI

[Repo](https://github.com/github/copilot-cli)

```bash
npm install -g @github/copilot
```

Launch: `copilot`

## Amp

From Sourcegraph. [Website](https://ampcode.com)

```bash
npm install -g @sourcegraph/amp
```

Launch: `amp`

## Factory Droid

[Website](https://factory.ai)

```bash
curl -fsSL https://app.factory.ai/cli | sh
```

Launch: `droid`

## Kimi CLI

From Moonshot AI. [Repo](https://github.com/MoonshotAI/kimi-cli)

```bash
uv tool install kimi-cli
```

Launch: `kimi`

## iFlow CLI

[Repo](https://github.com/iflow-ai/iflow-cli)

```bash
npm install -g @iflow-ai/iflow-cli
```

Launch: `iflow`

---

## Other agents

Anything you can start with a single terminal command can go in the menu:

```bash
agent-picker add <id> "<display name>" "<launch command>"

# examples
agent-picker add claude-opus "Claude (Opus)" "claude --model opus"
agent-picker add ollama "Ollama Llama" "ollama run llama3"
```

PRs that add popular agents to the built-in list (`BUILTIN_AGENTS` in `bin/agent-picker`) are welcome.
