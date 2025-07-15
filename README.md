# API Jongler

A middleware utility for calling external APIs using multiple API keys to reduce the need for paid tiers.

## Description

APIJongler is a Python utility that manages multiple API keys for external services, automatically handles key rotation, and provides optional Tor connectivity for enhanced privacy. It's designed to help developers distribute API calls across multiple keys to stay within free tier limits.

## Features

- **Multiple API Key Management**: Automatically rotates between available API keys
- **Lock Management**: Prevents concurrent use of the same API key
- **Error Handling**: Tracks and avoids problematic API keys
- **Tor Support**: Optional routing through Tor network
- **Extensible**: Easy to add new API connectors via JSON configuration
- **Comprehensive Logging**: Configurable logging with colored console output

## Installation

```bash
pip install api-jongler
```

## Configuration

1. Set the configuration file path:
```bash
export APIJONGLER_CONFIG=/path/to/your/APIJongler.ini
```

2. Create your configuration file (APIJongler.ini):
```ini
[openai]
key1 = your-openai-api-key-1
key2 = your-openai-api-key-2
key3 = your-openai-api-key-3

[anthropic]
key1 = your-anthropic-api-key-1
key2 = your-anthropic-api-key-2
```

## Usage

```python
from api_jongler import APIJongler

# Initialize with an API connector
jongler = APIJongler("openai", is_tor_enabled=False)

# Make API calls
response, status_code = jongler.run(
    method="POST",
    endpoint="/v1/chat/completions",
    request='{"model": "gpt-3.5-turbo", "messages": [{"role": "user", "content": "Hello!"}]}'
)

print(f"Response: {response}")
print(f"Status Code: {status_code}")

# Clean up when done (automatically called on destruction)
del jongler

# Or manually clean up all locks and errors
APIJongler.cleanUp()
```

## API Connectors

API connectors are defined in JSON files in the `connectors/` directory. Example:

```json
{
    "name": "openai",
    "host": "api.openai.com",
    "port": 443,
    "protocol": "https",
    "format": "json",
    "requires_api_key": true
}
```

## License

MIT License
