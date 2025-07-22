# SwiftlyRest

SwiftlyRest is a lightweight and extensible Swift package for making REST API requests with modern Swift features. It provides a simple interface for configuring authentication, building endpoints, handling JWT tokens, and performing HTTP requests with built-in error handling and retry logic.

## Features
- Easy configuration of base URL, authentication, and content type
- Support for JWT token management and secure storage using Keychain
- Protocol-based endpoint building for clean and readable API paths
- Async/await HTTP requests (GET, POST, PUT, PATCH, DELETE)
- Customizable authentication via protocols
- Detailed error handling with `SwiftlyRestError` and retryable codes
- Request logging for debugging

## Installation
Add SwiftlyRest to your `Package.swift` dependencies:

```swift
.package(url: "https://github.com/yourusername/SwiftlyRest.git", from: "1.0.0")
```

Then add it to your target:

```swift
.target(
    name: "YourApp",
    dependencies: ["SwiftlyRest"]
)
```

## Usage

### Basic Setup
```swift
import SwiftlyRest

let rest = SwiftlyRest.shared
try? rest.setBaseURL("https://api.example.com")
rest.setContentType("application/json")
rest.loggingEnabled(true)
```

### JWT Token Management
```swift
rest.setJwtToken("your-jwt-token")
rest.storeJwtOnKeychain()
rest.loadJwtFromKeychain()
```

### Configuring API Authentication
Implement `ApiAuthenticationInterface` to customize authentication headers:
```swift
class MyAuth: ApiAuthenticationInterface {
    var headers: [String: String] { ["X-Api-Key": "your-key"] }
    func generateHeaders<T: Codable>(forMethod method: HTTPMethod, forBody body: T?, withJwt jwt: String?) -> [String: String] {
        // Custom header logic
        return headers
    }
}
rest.configureApiAuth(MyAuth())
```

### Making Requests
```swift
let endpoint: EndpointInterface = ... // Build your endpoint
let result = await rest.get(endpoint)
switch result {
case .success(let data):
    // Handle data
case .failure(let error):
    // Handle error
}
```

## Error Handling
All requests return a `Result<T, SwiftlyRestError>`. See `SwiftlyRestError` for all error cases, including retryable codes in `RetryableCodes`.

## Protocols
- `ApiAuthenticationInterface`: For custom authentication header logic
- `EndpointInterface`: For building endpoint URLs

## Full documentation

Check the GitHub pages for docs [https://PedroCavaleiro.github.io/SwiftlyRest/](https://PedroCavaleiro.github.io/SwiftlyRest/)

## License
MIT
