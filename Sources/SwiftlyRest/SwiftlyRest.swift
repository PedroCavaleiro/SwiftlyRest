//
//  SwiftlyRest.swift
//  SwiftlyRest
//
//  Created by Pedro Cavaleiro on 19/04/2025.
//

import Foundation
import KeychainSwift


/// Represents errors that can occur when making REST API requests using SwiftlyRest.
///
/// Each case corresponds to a specific error scenario, including HTTP status codes, network issues, and unexpected responses.
public enum SwiftlyRestError: Error, Equatable, Sendable {
    /// The provided URL is invalid.
    /// - Parameter url: The invalid URL string that caused the error.
    case invalidURL(_ url: String)
    /// No response was received from the server.
    /// - Parameters:
    ///   - url: The URL that was requested.
    ///   - headers: The headers sent with the request.
    ///   - body: The body of the request, if any.
    case noResponse(_ url: String, headers: [String: String] = [:], body: String? = nil)
    /// The server returned a bad request (400) with an optional message.
    /// - Parameters:
    ///   - url: The URL that was requested.
    ///   - headers: The headers sent with the request.
    ///   - body: The body of the request, if any.
    ///   - response: The response body from the server, if available.
    case badRequest(_ url: String, headers: [String: String] = [:], body: String? = nil, response: String = "")
    /// The request was unauthorized (401).
    /// - Parameters:
    ///   - url: The URL that was requested.
    ///   - headers: The headers sent with the request.
    ///   - body: The body of the request, if any.
    ///   - response: The response body from the server, if available.
    case unauthorized(_ url: String, headers: [String: String] = [:], body: String? = nil, response: String = "")
    /// The request was forbidden (403).
    /// - Parameters:
    ///   - url: The URL that was requested.
    ///   - headers: The headers sent with the request.
    ///   - body: The body of the request, if any.
    ///   - response: The response body from the server, if available.
    case forbidden(_ url: String, headers: [String: String] = [:], body: String? = nil, response: String = "")
    /// The requested resource was not found (404).
    /// - Parameters:
    ///   - url: The URL that was requested.
    ///   - headers: The headers sent with the request.
    ///   - body: The body of the request, if any.
    case notFound(_ url: String, headers: [String: String] = [:], body: String? = nil)
    /// The server encountered an internal error (500).
    /// - Parameters:
    ///   - url: The URL that was requested.
    ///   - headers: The headers sent with the request.
    ///   - body: The body of the request, if any.
    ///   - response: The response body from the server, if available.
    case internalServerError(_ url: String, headers: [String: String] = [:], body: String? = nil, response: String = "")
    /// The server returned a bad gateway error (502).
    /// - Parameters:
    ///   - url: The URL that was requested.
    ///   - headers: The headers sent with the request.
    ///   - body: The body of the request, if any.
    case badGateway(_ url: String, headers: [String: String] = [:], body: String? = nil)
    /// The service is unavailable (503).
    /// - Parameters:
    ///   - url: The URL that was requested.
    ///   - headers: The headers sent with the request.
    ///   - body: The body of the request, if any.
    case serviceUnavailable(_ url: String, headers: [String: String] = [:], body: String? = nil)
    /// The request timed out (408).
    /// - Parameters:
    ///   - url: The URL that was requested.
    ///   - headers: The headers sent with the request.
    ///   - body: The body of the request, if any.
    case timeout(_ url: String, headers: [String: String] = [:], body: String? = nil)
    /// The request timed out (504).
    /// - Parameters:
    ///   - url: The URL that was requested.
    ///   - headers: The headers sent with the request.
    ///   - body: The body of the request, if any.
    case gatewayTimeout(_ url: String, headers: [String: String] = [:], body: String? = nil)
    /// The response format was unexpected or could not be parsed.
    /// - Parameters:
    ///   - url: The URL that was requested.
    ///   - headers: The headers sent with the request.
    ///   - body: The body of the request, if any.
    ///   - response: The response body from the server, if available.
    case unexpectedResponseFormat(_ url: String, headers: [String: String] = [:], body: String? = nil, response: String = "")
    /// An unknown error occurred, with code and message.
    /// - Parameters:
    ///   - url: The URL that was requested.
    ///   - headers: The headers sent with the request.
    ///   - body: The body of the request, if any.
    ///   - response: The response body from the server, if available.
    case unknown(_ url: String, headers: [String: String] = [:], body: String? = nil, code: Int, response: String = "")
    /// The request body was invalid or could not be encoded.
    /// - Parameters:
    ///   - url: The URL that was requested.
    ///   - headers: The headers sent with the request.
    ///   - body: The body of the request, if any.
    case badRequestBody(_ url: String, headers: [String: String] = [:], body: String? = nil)

    /// Compares two SwiftlyRestError values for equality.
    public static func == (lhs: SwiftlyRestError, rhs: SwiftlyRestError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL),
            (.noResponse, .noResponse),
            (.unauthorized, .unauthorized),
            (.forbidden, .forbidden),
            (.notFound, .notFound),
            (.internalServerError, .internalServerError),
            (.badGateway, .badGateway),
            (.serviceUnavailable, .serviceUnavailable),
            (.timeout, .timeout),
            (.badRequestBody, .badRequestBody):
            return true
        case (.badRequest(let lhsUrl, let lhsHeaders, let lhsBody, let lhsMessage), .badRequest(let rhsUrl, let rhsHeaders, let rhsBody, let rhsMessage)):
            return lhsMessage == rhsMessage && lhsUrl == rhsUrl && lhsHeaders == rhsHeaders && lhsBody == rhsBody
        case (.unknown(let lhsUrl, let lhsHeaders, let lhsBody, let lhsCode, let lhsMessage), .unknown(let rhsUrl, let rhsHeaders, let rhsBody, let rhsCode, let rhsMessage)):
            return lhsCode == rhsCode && lhsMessage == rhsMessage && lhsUrl == rhsUrl && lhsHeaders == rhsHeaders && lhsBody == rhsBody
        default:
            return false
        }
    }
}

/// Represents the HTTP methods used in REST API requests.
///
/// Each case corresponds to a standard HTTP method for interacting with RESTful services.
public enum HTTPMethod: String, Equatable {
    /// HTTP GET method, used to retrieve data from the server.
    case get    = "GET"
    /// HTTP POST method, used to send new data to the server.
    case post   = "POST"
    /// HTTP PUT method, used to update existing data on the server.
    case put    = "PUT"
    /// HTTP PATCH method, used to partially update data on the server.
    case patch  = "PATCH"
    /// HTTP DELETE method, used to remove data from the server.
    case delete = "DELETE"
}


/// Represents HTTP status codes that are considered retryable for REST API requests.
///
/// Use this enum to identify errors where a retry attempt may be appropriate.
public enum RetryableCodes: Int, Equatable {
    /// Internal server error (500).
    case internalServerError = 500
    /// Bad gateway error (502).
    case badGateway          = 502
    /// Service unavailable error (503).
    case serviceUnavailable  = 503
    /// Timeout error (504).
    case timeout             = 504
    /// Unknown error code (custom value).
    case unknown             = 999
}


/// Main class for interacting with REST APIs using SwiftlyRest.
///
/// Provides methods for configuring authentication, base URL, content type, and for performing HTTP requests (GET, POST, PUT, PATCH, DELETE).
/// Handles JWT storage, request logging, and header generation. Use the shared instance for most operations.
@available(macOS 12.0, *)
public class SwiftlyRest: SwiftlyRestInterface {
    
    /// Singleton for SwiftlyRest if needed you can use the `init`
    @MainActor public static let shared = SwiftlyRest()
    
    private var baseURL: URL?
    private var loggingEnabled: Bool = false
    private var tag: String = "[SwiftlyRest]"
    private var apiAuthConfiguration: ApiAuthenticationInterface?
    private var jwtToken: String?
    private var contentTypeHeader: String = "application/json"
    
    private init() {}
    
    /// Initializer to use SwiftlyRest as a single instance instead of a singleton
    /// - Parameters:
    ///   - baseURL: The base URL of the server
    ///   - loggingEnabled: When true it logs all requests in a detailed manner (including successfull requests)
    ///   - tag: Tag to idenfiy the logs
    ///   - apiAuthConfiguration: The API Configuration system
    ///   - jwtToken: The JWT token for the authentication
    ///   - contentTypeHeader: The content type header (recommended application/json)
    public init(
        baseURL: URL? = nil,
        loggingEnabled: Bool = false,
        tag: String = "[SwiftlyRest]",
        apiAuthConfiguration: ApiAuthenticationInterface? = nil,
        jwtToken: String? = nil,
        contentTypeHeader: String = "application/json"
    ) {
        self.baseURL = baseURL
        self.loggingEnabled = loggingEnabled
        self.tag = tag
        self.apiAuthConfiguration = apiAuthConfiguration
        self.jwtToken = jwtToken
        self.contentTypeHeader = contentTypeHeader
    }
    
    /// Sets the content type header
    ///
    /// - Parameter contentType: The content type header value, defaults to "application/json"
    public func setContentType(_ contentType: String) {
        self.contentTypeHeader = contentType
    }
    
    /// Configures the base URL to be used
    ///
    /// - Parameter url: The base URL to use
    /// - Throws: `SwiftlyRestError.invalidURL` if the provided URL is not valid
    public func setBaseURL(_ url: String) throws {
        guard let url = URL(string: url) else {
            throw SwiftlyRestError.invalidURL(url)
        }
        self.baseURL = url
    }
    
    /// Configures the API Auth with the `ApiAuthenticationInterface` protocol
    /// When set the headers will be automatically added to the request
    ///
    /// - Parameter apiAuthConfiguration: The API configuration
    public func configureApiAuth(_ apiAuthConfiguration: ApiAuthenticationInterface) {
        self.apiAuthConfiguration = apiAuthConfiguration
    }
    
    /// Sets the JWT token for the requests
    ///
    /// - Parameter jwtToken: The JWT to use in the requests, when not `nil` they will be automatically added to the request
    public func setJwtToken(_ jwtToken: String?) {
        self.jwtToken = jwtToken
    }
    
    /// Enables/Disabled the request logging
    ///
    /// - Parameter enabled: The state of the logging
    public func loggingEnabled(_ enabled: Bool) {
        self.loggingEnabled = enabled
    }
    
    /// Checks if the user is authenticated
    public func hasJwtSet() -> Bool {
        return self.jwtToken != nil
    }
    
    /// Stored the active jwt token on the platform if a jwt is passed that token will be stored instead
    /// The jwt will be stored on the key *token* by default
    ///
    /// - Parameters:
    ///  - token: The token to store, if null it will store the active token, if the active token is null it removes the stored token
    ///  - key: The Keychain key where to store the token
    public func storeJwtOnKeychain(jwt token: String? = nil, on key: String = "token") {
        let keychain = KeychainSwift()
        if let token = token {
            keychain.set(token, forKey: key)
        } else if let token = self.jwtToken {
            keychain.set(token, forKey: key)
        } else {
            keychain.delete(key)
        }
    }
    
    /// Loads the JWT stored in the keychain onto the JWT variable to use in the requests
    ///
    /// - Parameter key: The key where the token is stored
    public func loadJwtFromKeychain(from key: String = "token") {
        let keychain = KeychainSwift()
        guard let token = keychain.get(key) else { return }
        self.jwtToken = token
    }
    
    /// Performs a HTTP GET request
    ///
    /// - Parameters:
    ///  - endpoint: The endpoint where to perform the request
    ///  - headers: Extra headers to send to the server
    ///  - T: The type of the response, this will be used to parse from the server
    /// - Returns: `awaitable` `Result<T, SwiftlyRestError>` Where the .success contains the parsed response or a `SwiftlyRestError`
    @available(iOS 15.0, *)
    public func get<T: Codable>(
        _ endpoint: EndpointInterface,
        headers: [String: String] = [:]
    ) async -> Result<T, SwiftlyRestError> {
        return await makeRequest(endpoint: endpoint, method: .get, body: Optional<Data>.none, responseType: T.self, headers: headers)
    }
    
    /// Performs a HTTP POST request
    ///
    /// - Parameters:
    ///  - endpoint: The endpoint where to perform the request
    ///  - body: The request body to send to the server
    ///  - headers: Extra headers to send to the server
    ///  - T: The type of the response, this will be used to parse from the server
    ///  - U: The type of the body
    /// - Returns: `awaitable` `Result<T, SwiftlyRestError>` Where the .success contains the parsed response or a `SwiftlyRestError`
    @available(iOS 15.0, *)
    public func post<T: Codable, U: Codable>(
        _ endpoint: EndpointInterface,
        body: U? = nil,
        headers: [String: String] = [:]
    ) async -> Result<T, SwiftlyRestError> {
        return await makeRequest(endpoint: endpoint, method: .post, body: body, responseType: T.self, headers: headers)
    }
    
    /// Performs a HTTP PATCH request
    ///
    /// - Parameters:
    ///  - endpoint: The endpoint where to perform the request
    ///  - body: The request body to send to the server
    ///  - headers: Extra headers to send to the server
    ///  - T: The type of the response, this will be used to parse from the server
    ///  - U: The type of the body
    /// - Returns: `awaitable` `Result<T, SwiftlyRestError>` Where the .success contains the parsed response or a `SwiftlyRestError`
    @available(iOS 15.0, *)
    public func patch<T: Codable, U: Codable>(
        _ endpoint: EndpointInterface,
        body: U? = nil,
        headers: [String: String] = [:]
    ) async -> Result<T, SwiftlyRestError> {
        return await makeRequest(endpoint: endpoint, method: .patch, body: body, responseType: T.self, headers: headers)
    }
    
    /// Performs a HTTP PUT request
    ///
    /// - Parameters:
    ///  - endpoint: The endpoint where to perform the request
    ///  - body: The request body to send to the server
    ///  - headers: Extra headers to send to the server
    ///  - T: The type of the response, this will be used to parse from the server
    ///  - U: The type of the body
    /// - Returns: `awaitable` `Result<T, SwiftlyRestError>` Where the .success contains the parsed response or a `SwiftlyRestError`
    @available(iOS 15.0, *)
    public func put<T: Codable, U: Codable>(
        _ endpoint: EndpointInterface,
        body: U? = nil,
        headers: [String: String] = [:]
    ) async -> Result<T, SwiftlyRestError> {
        return await makeRequest(endpoint: endpoint, method: .put, body: body, responseType: T.self, headers: headers)
    }
    
    /// Performs a HTTP DELETE request
    ///
    /// - Parameters:
    ///  - endpoint: The endpoint where to perform the request
    ///  - headers: Extra headers to send to the server
    ///  - T: The type of the response, this will be used to parse from the server
    /// - Returns: `awaitable` `Result<T, SwiftlyRestError>` Where the .success contains the parsed response or a `SwiftlyRestError`
    @available(iOS 15.0, *)
    public func delete<T: Codable>(
        _ endpoint: EndpointInterface,
        headers: [String: String] = [:]
    ) async -> Result<T, SwiftlyRestError> {
        return await makeRequest(endpoint: endpoint, method: .delete, body: Optional<Data>.none, responseType: T.self, headers: headers)
    }
    
    /// Generates the headers for a request
    ///
    /// - Parameters:
    ///  - method: The `HTTPMethod` of the request
    ///  - body: The body of the request as nullable data
    /// - Returns: The headers for a request
    public func generateHeaders(for method: HTTPMethod, with body: Data?) -> [String : String] {
        var headers: [String: String] = [:]
        if let authConfig = apiAuthConfiguration {
            let authHeaders = authConfig.generateHeaders(forMethod: method, forBody: body, withJwt: jwtToken)
            authHeaders.forEach { (key, value) in
                headers[key] = value
            }
        } else {
            if let jwtToken = self.jwtToken {
                headers["Authorization"] = "Bearer \(jwtToken)"
            }
        }
        
        return headers
    }
    
    /// Performs a HTTP request to a REST API
    ///
    /// - Parameters:
    ///  - endpoint: The endpoint where to send the request
    ///  - method: The `HTTPMethod` of the request
    ///  - body: The body of the request, can be nil
    ///  - responseType: The type of the response to parse from the server response
    ///  - headers: The extra headers to send to the server
    @available(iOS 15.0, *)
    private func makeRequest<T: Codable, U: Codable>(
        endpoint: EndpointInterface,
        method: HTTPMethod,
        body: U? = nil,
        responseType: T.Type,
        headers: [String: String] = [:]
    ) async -> Result<T, SwiftlyRestError> {
        
        guard let endpointUrl = try? endpoint.build() else {
            writeLog("\(tag)[invalidURL] Failed to build the URL: \(endpoint.url)")
            return .failure(SwiftlyRestError.invalidURL(endpoint.url))
        }
        
        guard let requestUrl = URL(string: endpointUrl, relativeTo: baseURL) else {
            writeLog("\(tag)[invalidURL] Failed to build the URL: \(baseURL?.absoluteString ?? "")\(endpoint.url)")
            return .failure(SwiftlyRestError.invalidURL(endpointUrl))
        }
        
        writeLog("\(tag)[requestURL] Request URL: \(requestUrl.absoluteString)")
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = method.rawValue
        
        var allHeaders: [String: String] = headers
        allHeaders["Content-Type"] = self.contentTypeHeader
        if let authConfig = apiAuthConfiguration {
            let authHeaders = authConfig.generateHeaders(forMethod: method, forBody: body, withJwt: jwtToken)
            authHeaders.forEach { (key, value) in
                allHeaders[key] = value
            }
        } else {
            if let jwtToken = self.jwtToken {
                allHeaders["Authorization"] = "Bearer \(jwtToken)"
            }
        }
        
        if loggingEnabled {
            allHeaders.forEach { (key, value) in
                writeLog("\(tag)[requestHeader] \(key): \(value)")
            }
        }
        
        request.allHTTPHeaderFields = allHeaders
        
        if let reqBody = body {
            if let jsonData = try? JSONEncoder().encode(reqBody) {
                request.httpBody = jsonData
                writeLog("\(tag)[requestBody] \(String(describing: String(data: jsonData, encoding: .utf8)))")
            }
        }
        
        let requestResponse = try? await URLSession.shared.data(for: request)
        
        guard let (data, response) = requestResponse else {
            writeLog("\(tag)[requestError] No response from the server")
            return .failure(
                SwiftlyRestError.noResponse(
                    requestUrl.absoluteString,
                    headers: allHeaders,
                    body: String(data: request.httpBody ?? Data(), encoding: .utf8)
                )
            )
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            writeLog("\(tag)[requestError] No response from the server")
            return .failure(
                SwiftlyRestError.noResponse(
                    requestUrl.absoluteString,
                    headers: allHeaders,
                    body: String(data: request.httpBody ?? Data(), encoding: .utf8)
                )
            )
        }
        
        writeLog("\(tag)[response] Server Response: \(String(data: data, encoding: .utf8) ?? "Error parsing data")")
        
        if (200...299).contains(httpResponse.statusCode) {
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(T.self, from: data)
                return .success(decodedData)
            } catch (_) {
                return .failure(
                    SwiftlyRestError.unexpectedResponseFormat(
                        requestUrl.absoluteString,
                        headers: allHeaders,
                        body: String(data: request.httpBody ?? Data(), encoding: .utf8),
                        response: String(data: data, encoding: .utf8) ?? "Error reading server response"
                    )
                )
            }
        } else {
            switch httpResponse.statusCode {
            case 400: return .failure(
                SwiftlyRestError.badRequest(
                    requestUrl.absoluteString,
                    headers: allHeaders,
                    body: String(data: request.httpBody ?? Data(), encoding: .utf8),
                    response: String(data: data, encoding: .utf8) ?? "Error reading server response"
                )
            )
            case 401: return .failure(
                SwiftlyRestError.unauthorized(
                    requestUrl.absoluteString,
                    headers: allHeaders,
                    body: String(data: request.httpBody ?? Data(), encoding: .utf8),
                    response: String(data: data, encoding: .utf8) ?? "Error reading server response"
                )
            )
            case 403: return .failure(
                SwiftlyRestError.forbidden(
                    requestUrl.absoluteString,
                    headers: allHeaders,
                    body: String(data: request.httpBody ?? Data(), encoding: .utf8),
                    response: String(data: data, encoding: .utf8) ?? "Error reading server response"
                )
            )
            case 404: return .failure(
                SwiftlyRestError.notFound(
                    requestUrl.absoluteString,
                    headers: allHeaders,
                    body: String(data: request.httpBody ?? Data(), encoding: .utf8)
                )
            )
            case 408: return .failure(
                SwiftlyRestError.timeout(
                    requestUrl.absoluteString,
                    headers: allHeaders,
                    body: String(data: request.httpBody ?? Data(), encoding: .utf8)
                )
            )
            case 500: return .failure(
                SwiftlyRestError.internalServerError(
                    requestUrl.absoluteString,
                    headers: allHeaders,
                    body: String(data: request.httpBody ?? Data(), encoding: .utf8),
                    response: String(data: data, encoding: .utf8) ?? "Error reading server response"
                )
            )
            case 502: return .failure(
                SwiftlyRestError.badGateway(
                    requestUrl.absoluteString,
                    headers: allHeaders,
                    body: String(data: request.httpBody ?? Data(), encoding: .utf8)
                )
            )
            case 503: return .failure(
                SwiftlyRestError.serviceUnavailable(
                    requestUrl.absoluteString,
                    headers: allHeaders,
                    body: String(data: request.httpBody ?? Data(), encoding: .utf8)
                )
            )
            case 504: return .failure(
                SwiftlyRestError.gatewayTimeout(
                    requestUrl.absoluteString,
                    headers: allHeaders,
                    body: String(data: request.httpBody ?? Data(), encoding: .utf8)
                )
            )
            default: return .failure(
                SwiftlyRestError.unknown(
                    requestUrl.absoluteString,
                    headers: allHeaders,
                    body: String(data: request.httpBody ?? Data(), encoding: .utf8),
                    code: httpResponse.statusCode,
                    response: String(data: data, encoding: .utf8) ?? "Error reading server response"
                ))
            }
        }
        
    }
    
    /// This just shows a log in the console if the logging is enabled, not fancy stuff is done here, it's just to avoid typing the if everytime
    ///
    /// - Parameter message: The message to log
    private func writeLog(_ message: String) {
        if loggingEnabled {
            print(message)
        }
    }
    
}
