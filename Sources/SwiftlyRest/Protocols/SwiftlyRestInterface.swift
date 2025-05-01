//
//  SwiftlyRestInterface.swift
//  SwiftlyRest
//
//  Created by Pedro Cavaleiro on 19/04/2025.
//

import Foundation

protocol SwiftlyRestInterface {
    
    /// Sets the content type header
    ///
    /// - Parameter contentType: The content type header value, defaults to "application/json"
    func setContentType(_ contentType: String)
    
    /// Configures the base URL to be used
    ///
    /// - Parameter url: The base URL to use
    /// - Throws: `SwiftlyRestError.invalidURL` if the provided URL is not valid
    func setBaseURL(_ url: String) throws
    
    /// Configures the API Auth with the `ApiAuthenticationInterface` protocol
    /// When set the headers will be automatically added to the request
    ///
    /// - Parameter apiAuthConfiguration: The API configuration
    func configureApiAuth(_ apiAuthConfiguration: ApiAuthenticationInterface)
    
    /// Sets the JWT token for the requests
    ///
    /// - Parameter jwtToken: The JWT to use in the requests, when not `nil` they will be automatically added to the request
    func setJwtToken(_ jwtToken: String?)
    
    /// Enables/Disabled the request logging
    ///
    /// - Parameter enabled: The state of the logging
    func loggingEnabled(_ enabled: Bool)
    
    /// Stored the active jwt token on the platform if a jwt is passed that token will be stored instead
    /// The jwt will be stored on the key *token* by default
    ///
    /// - Parameters:
    ///  - token: The token to store, if null it will store the active token, if the active token is null it removes the stored token
    ///  - key: The Keychain key where to store the token
    func storeJwtOnKeychain(jwt token: String?, on key: String)
    
    /// Checks if the user is authenticated
    func hasJwtSet() -> Bool
    
    /// Loads the JWT stored in the keychain onto the JWT variable to use in the requests
    ///
    /// - Parameter key: The key where the token is stored
    func loadJwtFromKeychain(from key: String)
    
    /// Performs a HTTP GET request
    ///
    /// - Parameters:
    ///  - endpoint: The endpoint where to perform the request
    ///  - headers: Extra headers to send to the server
    ///  - T: The type of the response, this will be used to parse from the server
    /// - Returns: `awaitable` `Result<T, SwiftlyRestError>` Where the .success contains the parsed response or a `SwiftlyRestError`
    @available(iOS 15.0, *)
    func get<T: Codable>(
        _ endpoint: EndpointInterface,
        headers: [String: String]
    ) async -> Result<T, SwiftlyRestError>
    
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
    func post<T: Codable, U: Codable>(
        _ endpoint: EndpointInterface,
        body: U,
        headers: [String: String]
    ) async -> Result<T, SwiftlyRestError>
    
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
    func patch<T: Codable, U: Codable>(
        _ endpoint: EndpointInterface,
        body: U,
        headers: [String: String]
    ) async -> Result<T, SwiftlyRestError>
    
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
    func put<T: Codable, U: Codable>(
        _ endpoint: EndpointInterface,
        body: U,
        headers: [String: String]
    ) async -> Result<T, SwiftlyRestError>
    
    /// Performs a HTTP DELETE request
    ///
    /// - Parameters:
    ///  - endpoint: The endpoint where to perform the request
    ///  - headers: Extra headers to send to the server
    ///  - T: The type of the response, this will be used to parse from the server
    /// - Returns: `awaitable` `Result<T, SwiftlyRestError>` Where the .success contains the parsed response or a `SwiftlyRestError`
    @available(iOS 15.0, *)
    func delete<T: Codable>(
        _ endpoint: EndpointInterface,
        headers: [String: String]
    ) async -> Result<T, SwiftlyRestError>
    
    
    /// Generates the headers for a request
    ///
    /// - Parameters:
    ///  - method: The `HTTPMethod` of the request
    ///  - body: The body of the request as nullable data
    /// - Returns: The headers for a request
    func generateHeaders(for method: HTTPMethod, with body: Data?) -> [String: String]
    
}
