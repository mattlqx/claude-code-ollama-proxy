# Using Claude Code with Ollama

This guide shows you how to use Claude Code with Ollama as the backend.

## Prerequisites

1. Install Ollama from https://ollama.com/
2. Pull the models you want to use:
   ```bash
   ollama pull llama3
   ollama pull llama3:8b
   # Or any other models you want to use
   ```
3. (Optional) Configure Ollama context length:
   ```bash
   export OLLAMA_CONTEXT_LENGTH=30000  # adjust as needed for your prompts
   ```
4. Start Ollama server:
   ```bash
   ollama serve
   ```

## Configuration

1. Configure the proxy in the `.env` file:
   ```
   PREFERRED_PROVIDER="ollama"
   OLLAMA_API_BASE="http://localhost:11434"  # Change if using remote Ollama
   BIG_MODEL="llama3"      # For Claude Sonnet
   SMALL_MODEL="llama3:8b" # For Claude Haiku
   ```

2. Start the proxy server:
   ```bash
   uv run uvicorn server:app --host 0.0.0.0 --port 8082 --reload
   ```

3. Connect with Claude Code:
   ```bash
   ANTHROPIC_BASE_URL=http://localhost:8082 claude
   ```

## Available Ollama Models

The proxy supports these Ollama models out of the box:
- llama3
- llama3:8b
- llama3:70b
- llama2
- mistral
- mistral:instruct
- mixtral
- mixtral:instruct
- phi3:mini
- phi3:medium

To use other models, add them to the `OLLAMA_MODELS` list in server.py.

## Troubleshooting

- Make sure Ollama is running with `ollama serve`
- Check if you can access Ollama directly: `curl http://localhost:11434/api/tags`
- If using a remote Ollama server, ensure the URL is correct in `OLLAMA_API_BASE`