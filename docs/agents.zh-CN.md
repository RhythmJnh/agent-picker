# CLI agent 安装说明

[English](agents.md) | 简体中文

下面是 agent-picker 内置支持的 CLI agent 的常用安装方式。装好任意一个之后，执行 `agent-picker list`，状态显示为 `✓ 已安装` 就会出现在菜单里。

> 安装命令会随官方更新而变化，如果和官方文档不一致，以官方文档为准。很多 agent 依赖 Node.js 18+，建议先用 [nvm](https://github.com/nvm-sh/nvm) 或 Homebrew 装好 Node。

## Claude Code

Anthropic 出品的终端编码 agent。[文档](https://docs.anthropic.com/en/docs/claude-code)

```bash
curl -fsSL https://claude.ai/install.sh | bash
# 或
npm install -g @anthropic-ai/claude-code
```

启动：`claude`

## Codex CLI

OpenAI 出品的终端编码 agent。[仓库](https://github.com/openai/codex)

```bash
npm install -g @openai/codex
# 或
brew install --cask codex
```

启动：`codex`

## OpenClaw

开源的个人 AI 助手，可以连接多个聊天渠道。[仓库](https://github.com/openclaw/openclaw)

```bash
npm install -g openclaw@latest
openclaw onboard     # 首次初始化
```

agent-picker 默认用 `openclaw tui` 启动（需要 Gateway 在运行）。如果想用本地模式，可以覆盖成：

```bash
agent-picker add openclaw "OpenClaw" "openclaw chat"
```

## Gemini CLI

Google 出品。[仓库](https://github.com/google-gemini/gemini-cli)

```bash
npm install -g @google/gemini-cli
# 或
brew install gemini-cli
```

启动：`gemini`

## OpenCode

开源的终端编码 agent，支持多家模型。[官网](https://opencode.ai)

```bash
curl -fsSL https://opencode.ai/install | bash
# 或
npm install -g opencode-ai
```

启动：`opencode`

## Qwen Code

阿里通义千问出品，基于 Gemini CLI 改造。[仓库](https://github.com/QwenLM/qwen-code)

```bash
npm install -g @qwen-code/qwen-code
```

启动：`qwen`

## Aider

开源的终端结对编程工具，和 git 深度集成。[官网](https://aider.chat)

```bash
python -m pip install aider-install
aider-install
```

启动：`aider`

## Goose

Block 开源的本地 agent。[仓库](https://github.com/block/goose)

```bash
brew install block-goose-cli
# 或
curl -fsSL https://github.com/block/goose/releases/download/stable/download_cli.sh | bash
```

启动：`goose session`

## Crush

Charm 出品的终端编码 agent。[仓库](https://github.com/charmbracelet/crush)

```bash
brew install charmbracelet/tap/crush
# 或
npm install -g @charmland/crush
```

启动：`crush`

## Cursor CLI

Cursor 的命令行 agent。[文档](https://docs.cursor.com/cli)

```bash
curl https://cursor.com/install -fsS | bash
```

启动：`cursor-agent`

## GitHub Copilot CLI

[仓库](https://github.com/github/copilot-cli)

```bash
npm install -g @github/copilot
```

启动：`copilot`

## Amp

Sourcegraph 出品。[官网](https://ampcode.com)

```bash
npm install -g @sourcegraph/amp
```

启动：`amp`

## Factory Droid

[官网](https://factory.ai)

```bash
curl -fsSL https://app.factory.ai/cli | sh
```

启动：`droid`

## Kimi CLI

月之暗面出品。[仓库](https://github.com/MoonshotAI/kimi-cli)

```bash
uv tool install kimi-cli
```

启动：`kimi`

## iFlow CLI

[仓库](https://github.com/iflow-ai/iflow-cli)

```bash
npm install -g @iflow-ai/iflow-cli
```

启动：`iflow`

---

## 其他 agent

不在上面列表里的，只要能在终端里用一个命令启动，就能加进菜单：

```bash
agent-picker add <id> "<显示名>" "<启动命令>"

# 例如
agent-picker add claude-opus "Claude (Opus)" "claude --model opus"
agent-picker add ollama "Ollama Llama" "ollama run llama3"
```

欢迎提 PR，把常用 agent 加进内置列表（`bin/agent-picker` 里的 `BUILTIN_AGENTS`）。
