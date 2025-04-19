//
//  ApiAuthenticationInterface.swift
//  SwiftlyRest
//
//  Created by Pedro Cavaleiro on 19/04/2025.
//

import Foundation

public protocol ApiAuthenticationInterface {
    
    var headers: [String: String] { get }
    
    /// Generates the headers to authenticate with the API
    /// This authenticates both the client and the user
    ///
    /// - Parameters:
    ///   - method: The `HTTPMethod` of the request
    ///   - body: The body of the request, nil `if` none, must be `codable`
    ///   - jwt: The JWT token for the user authentication, `nil` for no authentication
    func generateHeaders<T: Codable>(
        forMethod method: HTTPMethod,
        forBody body: T?,
        withJwt jwt: String?
    ) -> [String: String]
    
}
