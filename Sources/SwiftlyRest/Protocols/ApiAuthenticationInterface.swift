//
//  ApiAuthenticationInterface.swift
//  SwiftlyRest
//
//  Created by Pedro Cavaleiro on 19/04/2025.
//

import Foundation

/// A protocol that defines the requirements for API authentication mechanisms.
///
/// Conforming types must provide a set of headers for authentication and a method to generate authentication headers
/// for API requests, supporting both client and user authentication via JWT tokens.
public protocol ApiAuthenticationInterface {

    /// The default headers used for API authentication.
    /// These headers are typically included in every request to identify the client or provide static authentication information.
    var headers: [String: String] { get }

    /// Generates the headers required to authenticate with the API for a specific request.
    /// This method should return a dictionary of headers that authenticate both the client and the user (if a JWT is provided).
    ///
    /// - Parameters:
    ///   - method: The HTTP method of the request (e.g., GET, POST).
    ///   - body: The body of the request, or `nil` if none. The body must conform to `Codable`.
    ///   - jwt: The JWT token for user authentication, or `nil` if no user authentication is required.
    /// - Returns: A dictionary of headers to be included in the API request.
    func generateHeaders<T: Codable>(
        forMethod method: HTTPMethod,
        forBody body: T?,
        withJwt jwt: String?
    ) -> [String: String]
}
