//
//  SwiftlyRest.swift
//  SwiftlyRest
//
//  Created by Pedro Cavaleiro on 19/04/2025.
//

import Foundation

public enum SwiftlyRestError: Error {
    case invalidURL
    case noResponse
    case badRequest(message: String)
    case unauthorized
    case forbidden
    case notFound
    case internalServerError
    case badGateway
    case serviceUnavailable
    case timeout
    case unknown(code: Int, message: String)
}

public enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case patch  = "PATCH"
    case delete = "DELETE"
}

public enum RetryableCodes: Int {
    case internalServerError = 500
    case badGateway          = 502
    case serviceUnavailable  = 503
    case timeout             = 504
    case unknown             = 999
}

@available(macOS 12.0, *)
public class SwiftlyRest: SwiftlyRestInterface {
    
    public static let shared = SwiftlyRest()
    
    private var baseURL: URL?
    private var loggingEnabled: Bool = false
    private let tag: String = "[SwiftlyRest]"
    private var apiAuthConfiguration: ApiAuthenticationInterface?
    private var jwtToken: String?
    
    private init() {}
    
    /// Configures the base URL to be used
    ///
    /// - Parameter url: The base URL to use
    /// - Throws: `SwiftlyRestError.invalidURL` if the provided URL is not valid
    public func setBaseURL(_ url: String) throws {
        guard let url = URL(string: url) else {
            throw SwiftlyRestError.invalidURL
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
    
    /// Performs a HTTP GET request
    ///
    /// - Parameters:
    ///  - endpoint: The endpoint where to perform the request
    ///  - headers: Extra headers to send to the server
    ///  - T: The type of the response, this will be used to parse from the server
    /// - Returns: `awaitable` `Result<T, SwiftlyRestError>` Where the .success contains the parsed response or a `SwiftlyRestError`
    public func get<T: Codable>(
        _ endpoint: EndpointInterface,
        headers: [String: String] = [:]
    ) async -> Result<T, Error> {
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
    public func post<T: Codable, U: Codable>(
        _ endpoint: EndpointInterface,
        body: U,
        headers: [String: String] = [:]
    ) async -> Result<T, Error> {
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
    public func patch<T: Codable, U: Codable>(
        _ endpoint: EndpointInterface,
        body: U,
        headers: [String: String] = [:]
    ) async -> Result<T, Error> {
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
    public func put<T: Codable, U: Codable>(
        _ endpoint: EndpointInterface,
        body: U,
        headers: [String: String] = [:]
    ) async -> Result<T, Error> {
        return await makeRequest(endpoint: endpoint, method: .put, body: body, responseType: T.self, headers: headers)
    }
    
    /// Performs a HTTP DELETE request
    ///
    /// - Parameters:
    ///  - endpoint: The endpoint where to perform the request
    ///  - headers: Extra headers to send to the server
    ///  - T: The type of the response, this will be used to parse from the server
    /// - Returns: `awaitable` `Result<T, SwiftlyRestError>` Where the .success contains the parsed response or a `SwiftlyRestError`
    public func post<T: Codable>(
        _ endpoint: EndpointInterface,
        headers: [String: String] = [:]
    ) async -> Result<T, Error> {
        return await makeRequest(endpoint: endpoint, method: .post, body: Optional<Data>.none, responseType: T.self, headers: headers)
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
    private func makeRequest<T: Codable, U: Codable>(
        endpoint: EndpointInterface,
        method: HTTPMethod,
        body: U? = nil,
        responseType: T.Type,
        headers: [String: String] = [:]
    ) async -> Result<T, Error> {
        
        guard let endpointUrl = try? endpoint.build() else {
            writeLog("\(tag)[invalidURL] Failed to build the URL: \(endpoint.url)")
            return .failure(SwiftlyRestError.invalidURL)
        }
        
        guard let requestUrl = URL(string: endpointUrl, relativeTo: baseURL) else {
            writeLog("\(tag)[invalidURL] Failed to build the URL: \(baseURL?.absoluteString ?? "")\(endpoint.url)")
            return .failure(SwiftlyRestError.invalidURL)
        }
        
        writeLog("\(tag)[requestURL] Request URL: \(requestUrl.absoluteString)")
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = method.rawValue
        
        var allHeaders: [String: String] = headers
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
        
        let requestResponse = try? await URLSession.shared.data(for: request)
        
        guard let (data, response) = requestResponse else {
            writeLog("\(tag)[requestError] No response from the server")
            return .failure(SwiftlyRestError.noResponse)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            writeLog("\(tag)[requestError] No response from the server")
            return .failure(SwiftlyRestError.noResponse)
        }
        
        writeLog("\(tag)[response] Server Response: \(String(data: data, encoding: .utf8) ?? "Error parsing data")")
        
        if (200...299).contains(httpResponse.statusCode) {
            let decoder = JSONDecoder()
            let decodedData = try! decoder.decode(T.self, from: data)
            return .success(decodedData)
        } else {
            switch httpResponse.statusCode {
            case 400: return .failure(SwiftlyRestError.badRequest(message: String(data: data, encoding: .utf8) ?? "Error reading server response"))
            case 401: return .failure(SwiftlyRestError.unauthorized)
            case 403: return .failure(SwiftlyRestError.forbidden)
            case 404: return .failure(SwiftlyRestError.notFound)
            case 500: return .failure(SwiftlyRestError.internalServerError)
            case 502: return .failure(SwiftlyRestError.badGateway)
            case 503: return .failure(SwiftlyRestError.serviceUnavailable)
            case 504: return .failure(SwiftlyRestError.timeout)
            default: return .failure(
                SwiftlyRestError.unknown(
                    code: httpResponse.statusCode,
                    message: String(data: data, encoding: .utf8) ?? "Error reading server response"
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
