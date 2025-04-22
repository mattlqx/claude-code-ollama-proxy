# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands
- Run server: `uv run uvicorn server:app --host 0.0.0.0 --port 8082 --reload`
- Run tests: `python tests.py`
- Run specific test: `python tests.py --simple` or `python tests.py --tools-only` or `python tests.py --no-streaming`
- Check code style: `ruff check .`
- Format code: `black .`

## Code Style
- Python 3.10+ compatible code
- Use type hints throughout codebase (Pydantic for data modeling)
- Use FastAPI for API endpoints
- Follow PEP 8 conventions for naming:
  - snake_case for variables/functions
  - CamelCase for classes
- Prefer explicit error handling with try/except blocks
- Use descriptive variable names and add comments for complex logic
- Log errors and significant events with the logging module
- Use f-strings for string formatting