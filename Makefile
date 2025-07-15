# Makefile for API Jongler

.PHONY: help install install-dev test test-verbose clean build upload upload-test lint format setup-dev run-example

help:
	@echo "Available commands:"
	@echo "  install      - Install the package in the current environment"
	@echo "  install-dev  - Install in development mode with dev dependencies"
	@echo "  test         - Run tests"
	@echo "  test-verbose - Run tests with verbose output"
	@echo "  clean        - Clean build artifacts"
	@echo "  build        - Build the package"
	@echo "  upload       - Upload to PyPI"
	@echo "  upload-test  - Upload to Test PyPI"
	@echo "  lint         - Run linting"
	@echo "  format       - Format code with black"
	@echo "  setup-dev    - Set up development environment"
	@echo "  run-example  - Run basic example"

install:
	pip install -e .

install-dev:
	pip install -e ".[dev]"
	pip install pytest black flake8 twine

test:
	python -m pytest tests/ -v

test-verbose:
	python -m pytest tests/ -v -s

clean:
	rm -rf build/
	rm -rf dist/
	rm -rf *.egg-info/
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete

build: clean
	python setup.py sdist bdist_wheel

upload-test: build
	twine upload --repository testpypi dist/*

upload: build
	twine upload dist/*

lint:
	flake8 api_jongler/ tests/ examples/
	python -m py_compile api_jongler/*.py

format:
	black api_jongler/ tests/ examples/

setup-dev: install-dev
	@echo "Setting up development environment..."
	@echo "Please copy APIJongler.ini.example to a location of your choice"
	@echo "and set APIJONGLER_CONFIG environment variable to point to it"

run-example:
	cd examples && python basic_usage.py

run-advanced-example:
	cd examples && python advanced_usage.py
