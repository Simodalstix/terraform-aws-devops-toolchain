# Playwright Test Setup

## Installation

1. Navigate to the tests directory:

   ```bash
   cd tests
   ```

2. Install dependencies:

   ```bash
   npm install
   ```

3. Install browser binaries:
   ```bash
   npm run install-browsers
   ```

## Running Tests

- Run all tests: `npm test`
- Run tests with visible browser: `npm run test:headed`
- Debug tests: `npm run test:debug`

## Test Coverage

The tests validate:

- Feature flag behavior (default vs LaunchDarkly greeting)
- API endpoint accessibility
- Todo CRUD operations
- HTTP status codes and response formats

## Notes

- Tests automatically start the .NET application before running
- The feature flag test will pass regardless of flag state (for demo purposes)
- In production, you would use LaunchDarkly's test harness for deterministic flag testing
