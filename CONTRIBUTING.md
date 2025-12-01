# Contributing to BaseVault

Thank you for your interest in contributing to BaseVault!

## Development Setup

```bash
# Clone the repository
git clone git@github.com:Martins-O/Base-vault.git
cd BaseVault

# Install dependencies
forge install

# Run tests
forge test
```

## Code Style

- Follow Solidity style guide
- Use meaningful variable and function names
- Add NatSpec comments for all public functions
- Keep functions focused and modular

## Testing Requirements

- Write unit tests for all new features
- Ensure >95% code coverage
- Include integration tests for cross-contract interactions
- Add fork tests for DEX integrations

## Pull Request Process

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes with descriptive messages
4. Push to your fork
5. Open a Pull Request

## Security

- Never commit private keys or sensitive data
- Follow checks-effects-interactions pattern
- Use reentrancy guards where applicable
- Report security vulnerabilities privately

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
