#!/usr/bin/env bash
# cc_openrouter.sh
# Usage: source ./cc_openrouter.sh

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  echo "⚠️  This script must be sourced, not executed:"
  echo "    source ${0}"
  exit 1
fi

# Model prompt
DEFAULT_MODEL="qwen/qwen3-coder"

echo -n "Enter model [$DEFAULT_MODEL]: "
read -r ANTHROPIC_MODEL
if [[ -z "$ANTHROPIC_MODEL" ]]; then
  ANTHROPIC_MODEL="$DEFAULT_MODEL"
fi

# API key prompt (silent)
echo -n "Enter your OpenRouter API key: "
read -rs OPENROUTER_API_KEY
echo

if [[ -z "$OPENROUTER_API_KEY" ]]; then
  echo "❌ No key entered. Aborting."
  return 1
fi

export OPENROUTER_API_KEY
export ANTHROPIC_BASE_URL="https://openrouter.ai/api"
export ANTHROPIC_AUTH_TOKEN="$OPENROUTER_API_KEY"
export ANTHROPIC_MODEL
export ANTHROPIC_API_KEY=""

echo "✅ OpenRouter envs set for this session."
echo "   Model: $ANTHROPIC_MODEL"