# Anthropic API Proxy for Gemini, OpenAI & Ollama Models 🔄

**Use Anthropic clients (like Claude Code) with Gemini, OpenAI, or Ollama backends.** 🤝

A proxy server that lets you use Anthropic clients with Gemini, OpenAI, or Ollama models via LiteLLM. 🌉


![Anthropic API Proxy](pic.png)

## Quick Start ⚡

### Prerequisites

- OpenAI API key 🔑
- Google AI Studio (Gemini) API key (if using Google provider) 🔑
- Ollama installed locally or on a server (if using Ollama provider) 🔗
- [uv](https://github.com/astral-sh/uv) installed.

### Setup 🛠️

1. **Clone this repository**:
   ```bash
   git clone https://github.com/1rgs/claude-code-openai.git
   cd claude-code-openai
   ```

2. **Install uv** (if you haven't already):
   ```bash
   curl -LsSf https://astral.sh/uv/install.sh | sh
   ```
   *(`uv` will handle dependencies based on `pyproject.toml` when you run the server)*

3. **Configure Environment Variables**:
   Copy the example environment file:
   ```bash
   cp .env.example .env
   ```
   Edit `.env` and fill in your API keys and model configurations:

   *   `ANTHROPIC_API_KEY`: (Optional) Needed only if proxying *to* Anthropic models.
   *   `OPENAI_API_KEY`: Your OpenAI API key (Required if using the default OpenAI preference or as fallback).
   *   `GEMINI_API_KEY`: Your Google AI Studio (Gemini) API key (Required if PREFERRED_PROVIDER=google).
   *   `OLLAMA_API_BASE`: (Optional) The URL of your Ollama instance (Default: "http://localhost:11434").
   *   `PREFERRED_PROVIDER` (Optional): Set to `openai` (default), `google`, or `ollama`. This determines the primary backend for mapping `haiku`/`sonnet`.
   *   `BIG_MODEL` (Optional): The model to map `sonnet` requests to. Defaults to `gpt-4.1` (if `PREFERRED_PROVIDER=openai`), `gemini-2.5-pro-preview-03-25` (if `PREFERRED_PROVIDER=google`), or can be set to an Ollama model like `llama3`.
   *   `SMALL_MODEL` (Optional): The model to map `haiku` requests to. Defaults to `gpt-4.1-mini` (if `PREFERRED_PROVIDER=openai`), `gemini-2.0-flash` (if `PREFERRED_PROVIDER=google`), or can be set to an Ollama model like `llama3:8b`.

   **Mapping Logic:**
   - If `PREFERRED_PROVIDER=openai` (default), `haiku`/`sonnet` map to `SMALL_MODEL`/`BIG_MODEL` prefixed with `openai/`.
   - If `PREFERRED_PROVIDER=google`, `haiku`/`sonnet` map to `SMALL_MODEL`/`BIG_MODEL` prefixed with `gemini/` *if* those models are in the server's known `GEMINI_MODELS` list (otherwise falls back to OpenAI mapping).
   - If `PREFERRED_PROVIDER=ollama`, `haiku`/`sonnet` map to `SMALL_MODEL`/`BIG_MODEL` prefixed with `ollama/` *if* those models are in the server's known `OLLAMA_MODELS` list (otherwise falls back to OpenAI mapping).

4. **Run the server**:
   ```bash
   uv run uvicorn server:app --host 0.0.0.0 --port 8082 --reload
   ```
   *(`--reload` is optional, for development)*

### Using with Claude Code 🎮

1. **Install Claude Code** (if you haven't already):
   ```bash
   npm install -g @anthropic-ai/claude-code
   ```

2. **Connect to your proxy**:
   ```bash
   ANTHROPIC_BASE_URL=http://localhost:8082 claude
   ```

3. **That's it!** Your Claude Code client will now use the configured backend models (defaulting to Gemini) through the proxy. 🎯

## Using Claude Code with Ollama

This guide shows you how to use Claude Code with Ollama as the backend.

### Prerequisites

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

### Configuration

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

### Available Ollama Models

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

### Troubleshooting

- Make sure Ollama is running with `ollama serve`
- Check if you can access Ollama directly: `curl http://localhost:11434/api/tags`
- If using a remote Ollama server, ensure the URL is correct in `OLLAMA_API_BASE`

## Model Mapping 🗺️

The proxy automatically maps Claude models to OpenAI, Gemini, or Ollama models based on the configured model:

| Claude Model | Default OpenAI | When Gemini | When Ollama |
|--------------|--------------|---------------------------|---------------------------|
| haiku | openai/gpt-4.1-mini | gemini/gemini-2.0-flash | ollama/[model-name] |
| sonnet | openai/gpt-4.1 | gemini/gemini-2.5-pro-preview-03-25 | ollama/[model-name] |

### Supported Models

#### OpenAI Models
The following OpenAI models are supported with automatic `openai/` prefix handling:
- o3-mini
- o1
- o1-mini
- o1-pro
- gpt-4.5-preview
- gpt-4o
- gpt-4o-audio-preview
- chatgpt-4o-latest
- gpt-4o-mini
- gpt-4o-mini-audio-preview
- gpt-4.1
- gpt-4.1-mini

#### Gemini Models
The following Gemini models are supported with automatic `gemini/` prefix handling:
- gemini-2.5-pro-preview-03-25
- gemini-2.0-flash

#### Ollama Models
The following Ollama models are supported with automatic `ollama/` prefix handling:
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

### Model Prefix Handling
The proxy automatically adds the appropriate prefix to model names:
- OpenAI models get the `openai/` prefix 
- Gemini models get the `gemini/` prefix
- Ollama models get the `ollama/` prefix
- The BIG_MODEL and SMALL_MODEL will get the appropriate prefix based on whether they're in the OpenAI, Gemini, or Ollama model lists

For example:
- `gpt-4o` becomes `openai/gpt-4o`
- `gemini-2.5-pro-preview-03-25` becomes `gemini/gemini-2.5-pro-preview-03-25`
- `llama3` becomes `ollama/llama3`
- When BIG_MODEL is set to a Gemini model, Claude Sonnet will map to `gemini/[model-name]`
- When BIG_MODEL is set to an Ollama model, Claude Sonnet will map to `ollama/[model-name]`

### Customizing Model Mapping

Control the mapping using environment variables in your `.env` file or directly:

**Example 1: Default (Use OpenAI)**
No changes needed in `.env` beyond API keys, or ensure:
```dotenv
OPENAI_API_KEY="your-openai-key"
GEMINI_API_KEY="your-google-key" # Needed if PREFERRED_PROVIDER=google
# PREFERRED_PROVIDER="openai" # Optional, it's the default
# BIG_MODEL="gpt-4.1" # Optional, it's the default
# SMALL_MODEL="gpt-4.1-mini" # Optional, it's the default
```

**Example 2: Prefer Google**
```dotenv
GEMINI_API_KEY="your-google-key"
OPENAI_API_KEY="your-openai-key" # Needed for fallback
PREFERRED_PROVIDER="google"
# BIG_MODEL="gemini-2.5-pro-preview-03-25" # Optional, it's the default for Google pref
# SMALL_MODEL="gemini-2.0-flash" # Optional, it's the default for Google pref
```

**Example 3: Prefer Ollama**
```dotenv
PREFERRED_PROVIDER="ollama"
OLLAMA_API_BASE="http://localhost:11434" # Optional, this is the default
OPENAI_API_KEY="your-openai-key" # Needed for fallback
BIG_MODEL="llama3" # Choose your Ollama model
SMALL_MODEL="llama3:8b" # Choose your Ollama model
```

**Example 4: Use Specific OpenAI Models**
```dotenv
OPENAI_API_KEY="your-openai-key"
GEMINI_API_KEY="your-google-key"
PREFERRED_PROVIDER="openai"
BIG_MODEL="gpt-4o" # Example specific model
SMALL_MODEL="gpt-4o-mini" # Example specific model
```

## How It Works 🧩

This proxy works by:

1. **Receiving requests** in Anthropic's API format 📥
2. **Translating** the requests to OpenAI format via LiteLLM 🔄
3. **Sending** the translated request to OpenAI 📤
4. **Converting** the response back to Anthropic format 🔄
5. **Returning** the formatted response to the client ✅

The proxy handles both streaming and non-streaming responses, maintaining compatibility with all Claude clients. 🌊

## Contributing 🤝

Contributions are welcome! Please feel free to submit a Pull Request. 🎁
