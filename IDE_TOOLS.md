IDE Tools — Ollama, Claude, Codex, OpenCode, and IDE integration

Overview

- This document collects practical steps to access Claude (via Anthropic API) and local models via Ollama, plus examples for OpenAI Codex/OpenCode and integrating AI coding agents into editors/IDEs.

Prerequisites

- Have API keys for services you plan to use (Anthropic, OpenAI, etc.).
- Install `ollama` if you want local model hosting: https://ollama.ai
- A terminal (PowerShell / cmd) and a text editor or IDE (VS Code recommended).

Environment
Create a `.env` or set environment variables in your shell:

- `ANTHROPIC_API_KEY=...`
- `OPENAI_API_KEY=...`

Accessing Claude (Anthropic)

1. Using Anthropic HTTP API (recommended for cloud-hosted Claude):

Example (curl):

```
curl https://api.anthropic.com/v1/complete \
  -H "x-api-key: $ANTHROPIC_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"claude-2","prompt":"Write a short Python function that reverses a string","max_tokens":300}'
```

2. Notes:

- Replace `claude-2` with the specific model name your Anthropic account can use.
- Check Anthropic docs for rate limits and param names.

Using Ollama (local models)

- Install `ollama` and pull a local model: `ollama pull <model>` (see Ollama docs).
- Example run with the Ollama CLI:

```
ollama run <model> --prompt "Explain recursion in simple terms"
```

- Ollama can serve local models and expose a local HTTP API (consult Ollama docs for current endpoints and flags).

OpenAI Codex / OpenCode examples

- If you want to use OpenAI Codex (or code-capable models), use the OpenAI completions endpoint.

Example (curl):

```
curl https://api.openai.com/v1/engines/code-davinci-002/completions \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"prompt":"# Python\n# Reverse a string\ndef reverse(s):","max_tokens":100}'
```

Integrating with IDEs

- VS Code: install extensions such as CodeGPT, Tabnine, or other AI assistants that support custom API endpoints or local proxies.
- Many extensions accept an API key or an HTTP proxy — configure them to point to a local Ollama server or use the cloud API keys.

AI Coding Agents and automation

- Simple agent pattern:
  1. Tooling: a CLI that sends prompts to a model (Ollama, Anthropic, OpenAI).
  2. Orchestration: a small script that sequences prompts, validates results, and runs tests.
  3. IDE integration: wire the agent to an editor command or extension that calls the script.

Example `.env.template`

```
ANTHROPIC_API_KEY=your_anthropic_key_here
OPENAI_API_KEY=your_openai_key_here
```

Example Windows script: see `scripts/run_examples.bat` for runnable examples.

Security and best practices

- Store API keys in environment variables or credential stores, never in source control.
- Rate-limit and cost control: add safeguards when running agents on cloud APIs.

Further reading and links

- Ollama: https://ollama.ai
- Anthropic docs: https://www.anthropic.com
- OpenAI (Codex): https://platform.openai.com/docs
