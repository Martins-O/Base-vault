# Testing Guide

## Running Tests

### Unit Tests
```bash
forge test --match-contract Unit
```

### Integration Tests
```bash
forge test --match-contract Integration
```

### Fork Tests
```bash
forge test --fork-url $BASE_SEPOLIA_RPC_URL
```

### Coverage
```bash
forge coverage --report lcov
```

## Test Organization

- `test/unit/` - Unit tests for individual contracts
- `test/integration/` - Integration tests for contract interactions
- `test/fork/` - Fork tests against live networks

## Writing Tests

Follow the Foundry testing patterns:
- Use `setUp()` for test initialization
- Use descriptive test names (test + WhatIsBeingTested)
- Use fuzz testing where applicable
- Test both success and failure cases
