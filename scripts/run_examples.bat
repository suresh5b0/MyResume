@echo off
REM Example Windows script to demonstrate Anthropic (Claude), OpenAI (Codex), and Ollama usage.

if "%ANTHROPIC_API_KEY%"=="" (
  echo Please set ANTHROPIC_API_KEY environment variable.
)

if "%OPENAI_API_KEY%"=="" (
  echo Please set OPENAI_API_KEY environment variable.
)

echo === Anthropic (Claude) example ===
curl https://api.anthropic.com/v1/complete -H "x-api-key: %ANTHROPIC_API_KEY%" -H "Content-Type: application/json" -d "{\"model\":\"claude-2\",\"prompt\":\"Write a short Python function that reverses a string\",\"max_tokens\":200}"

echo.
echo === OpenAI (Codex) example ===
curl https://api.openai.com/v1/engines/code-davinci-002/completions -H "Authorization: Bearer %OPENAI_API_KEY%" -H "Content-Type: application/json" -d "{\"prompt\":\"# Python\n# Reverse a string\ndef reverse(s):\",\"max_tokens\":100}"

echo.
echo === Ollama local model example ===
echo (Requires `ollama` in PATH and a local model installed)
ollama run <model> --prompt "Explain recursion in simple terms"

pause
