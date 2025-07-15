# API Jongler Development Guide

## Project Structure

```
api_jongler/
├── api_jongler/                    # Main package
│   ├── __init__.py                # Package initialization
│   ├── __main__.py                # Module entry point
│   ├── api_jongler.py             # Main APIJongler class
│   ├── cli.py                     # Command-line interface
│   └── connectors/                # API connector configurations
│       ├── openai.json           # OpenAI API connector
│       ├── anthropic.json        # Anthropic API connector
│       ├── google.json           # Google API connector
│       └── httpbin.json          # HTTPBin test connector
├── examples/                      # Usage examples
│   ├── basic_usage.py            # Basic usage example
│   └── advanced_usage.py         # Advanced usage with multiple features
├── tests/                        # Test suite
│   ├── __init__.py              # Test runner
│   └── test_api_jongler.py      # Unit tests
├── setup.py                     # Package setup configuration
├── requirements.txt             # Dependencies
├── README.md                    # User documentation
├── LICENSE                      # MIT License
├── MANIFEST.in                  # Package manifest
├── Makefile                     # Development commands
├── .gitignore                   # Git ignore rules
└── APIJongler.ini.example       # Example configuration file
```

## Architecture

### Core Components

1. **APIJongler Class**: Main class that manages API connections and key rotation
2. **APIConnector Class**: Represents API connector configuration loaded from JSON
3. **ColoredFormatter**: Custom logging formatter with colored output
4. **CLI Module**: Command-line interface for easy usage

### Key Features

- **Multiple API Key Management**: Automatically rotates between available keys
- **Lock File System**: Prevents concurrent use of the same API key using .lock files
- **Error Tracking**: Creates .error files for problematic API keys to avoid them
- **Tor Support**: Optional routing through Tor network for enhanced privacy
- **Extensible Design**: Easy to add new API connectors via JSON configuration
- **Comprehensive Logging**: Configurable logging with colored console output and file logging

### File Management

The utility creates files in `~/.api_jongler/`:
- `locks/` - Contains .lock files for active API keys
- `logs/` - Contains log files

Lock and error files follow the naming pattern: `{connector_name}_{key_name}.{lock|error}`

## Configuration

### Environment Variables

- `APIJONGLER_CONFIG`: Path to the configuration INI file (required)
- `APIJONGLER_LOG_LEVEL`: Logging level (DEBUG, INFO, WARNING, ERROR, CRITICAL)

### Configuration File Format

```ini
[connector_name]
key1 = your-api-key-1
key2 = your-api-key-2
key3 = your-api-key-3
```

### API Connector JSON Format

```json
{
    "name": "connector_name",
    "host": "api.example.com",
    "port": 443,
    "protocol": "https",
    "format": "json",
    "requires_api_key": true
}
```

## Usage Patterns

### Programmatic Usage

```python
from api_jongler import APIJongler

# Initialize
jongler = APIJongler("openai", is_tor_enabled=False)

# Make requests
response, status_code = jongler.run("POST", "/v1/chat/completions", data)

# Cleanup (automatic on destruction)
del jongler
```

### Command Line Usage

```bash
# Basic request
apijongler httpbin GET /json

# With Tor
apijongler --tor httpbin GET /ip

# Cleanup
apijongler --cleanup httpbin
apijongler --cleanup-all
```

### Development Commands

```bash
# Install in development mode
make install-dev

# Run tests
make test

# Build package
make build

# Clean artifacts
make clean

# Run examples
make run-example
```

## Testing

Run the test suite:
```bash
python -m pytest tests/ -v
```

Or use the Makefile:
```bash
make test
```

## Building and Distribution

1. Update version in `setup.py`
2. Build the package: `make build`
3. Upload to test PyPI: `make upload-test`
4. Upload to PyPI: `make upload`

## Adding New API Connectors

1. Create a new JSON file in `api_jongler/connectors/`
2. Define the connector configuration
3. Add API keys to your configuration INI file
4. The connector is automatically available

Example connector JSON:
```json
{
    "name": "myapi",
    "host": "api.myservice.com",
    "port": 443,
    "protocol": "https",
    "format": "json",
    "requires_api_key": true
}
```

## Security Considerations

- Store configuration files securely
- Use environment variables for sensitive paths
- Consider using Tor for enhanced privacy
- Regularly rotate API keys
- Monitor lock and error files for issues

## Troubleshooting

### Common Issues

1. **"APIJONGLER_CONFIG environment variable not set"**
   - Set the environment variable to point to your configuration file

2. **"No available API keys"**
   - Check if all keys are locked or have error files
   - Use `APIJongler.cleanUp()` to clear stale locks

3. **"API connector configuration not found"**
   - Ensure the connector JSON file exists in the connectors directory
   - Check the connector name spelling

4. **Authentication errors**
   - Verify API keys are valid and have proper permissions
   - Check if error files exist for the keys

### Debug Mode

Enable debug logging for detailed information:
```bash
export APIJONGLER_LOG_LEVEL=DEBUG
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make changes with tests
4. Run the test suite
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
