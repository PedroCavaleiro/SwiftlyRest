//
//  ApiAuthentication.swift
//  SwiftlyRest
//
//  Created by Pedro Cavaleiro on 19/04/2025.
//

import Foundation
import CryptoKit

/// This is the REST API authentication method that I usually use
/// You can implement your own and set it as default REST API authentication on the SwiftlyRest class
///
/// Check this repository for more information
/// https://github.com/PedroCavaleiro/api-app-authentication
@available(macOS 10.15, *)
public class ApiAuthentication: ApiAuthenticationInterface {
    
    private enum AuthenticationHeader: String {
        case appId = "x-app-id"
        case browser = "x-browser"
        case browserSignature = "x-browser-sig"
        case client = "x-client"
        case requestSignature = "x-req-sig"
        case requestNonce = "x-req-nonce"
        case requestTimestamp = "x-req-timestamp"
    }
    
    public var headers: [String: String] = [:]
    
    init(
        deviceUuid: String,
        appId: String,
        appKey: String,
        userAgent: String = "SwiftlyRest"
    ) {
        let fingerprint = SHA256.hash(
            data: Data("\(deviceUuid) | \(userAgent)".utf8)
        ).compactMap { String(format: "%02x", $0) }.joined()
        
        headers[AuthenticationHeader.appId.rawValue] = appId
        headers[AuthenticationHeader.browser.rawValue] = fingerprint.description
        headers[AuthenticationHeader.browserSignature.rawValue] = SHA256.hash(data: Data(fingerprint.utf8))
            .compactMap { String(format: "%02x", $0) }.joined()
        headers[AuthenticationHeader.client.rawValue] = userAgent
    }
    
    /// Generates the headers to authenticate with the API
    /// This authenticates both the client and the user
    ///
    /// - Parameters:
    ///   - method: The `HTTPMethod` of the request
    ///   - body: The body of the request, nil `if` none, must be `codable`
    ///   - jwt: The JWT token for the user authentication, `nil` for no authentication
    public func generateHeaders<T: Codable>(
        forMethod method: HTTPMethod,
        forBody body: T?,
        withJwt jwt: String?
    ) -> [String: String] {
        var headers = self.headers
        
        let reqNonce = UUID().uuidString
        let timestamp = String(Date().timestamp())
        let appId = self.headers[AuthenticationHeader.appId.rawValue] ?? ""
        
        let bodyHash = body == nil
                        ? ""
                        : SHA256.hash(data: Data(try! JSONEncoder().encode(body!))).compactMap { String(format: "%02x", $0) }.joined()
        
        let plainSignature = body == nil
                                ? "\(appId)\(method)\(timestamp)\(reqNonce)"
                                : "\(appId)\(method)\(timestamp)\(reqNonce)\(bodyHash)"
        
        headers[AuthenticationHeader.requestSignature.rawValue] = HMAC<SHA256>.authenticationCode(
            for: Data(plainSignature.utf8),
            using: SymmetricKey(data: Data("".utf8))
        ).compactMap { String(format: "%02x", $0) }.joined()
        
        headers[AuthenticationHeader.requestNonce.rawValue] = reqNonce
        headers[AuthenticationHeader.requestTimestamp.rawValue] = timestamp
        
        if let jwt = jwt {
            headers["Authorization"] = "Bearer \(jwt)"
        }
        
        return headers
        
    }
    
}
