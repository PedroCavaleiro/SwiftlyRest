//
//  File.swift
//  SwiftlyRest
//
//  Created by Pedro Cavaleiro on 19/04/2025.
//

import Foundation

/// A class that implements the `EndpointInterface` protocol, providing methods to build and manipulate API endpoint URLs.
/// This class allows for the addition of versions, controllers, paths, and query parameters to create a complete URL for API requests.
/// It supports both string and enumerator-based inputs for flexibility and readability.
public class Endpoint: EndpointInterface {
    
    /// The URL of the request.
    public var url: String
    
    /// Initializes the Endpoint with an optional URL.
    /// If no URL is provided, it defaults to an empty string.
    /// - Parameter url: The initial URL of the endpoint, defaulting to an empty string.
    public init(url: String = "") {
        self.url = url
    }
    
    /// Adds a version to the endpoint
    /// This can be added using the `withPath(_ path: String)` method but it's better for readability
    /// *NOTE: Do not append nor prepend the foward slash*
    ///
    /// - Parameter version: The version of the endpoint as string
    @discardableResult
    public func withVersion(_ version: String)  -> Endpoint {
        self.url.append("/\(version)")
        return self
    }
    
    /// Adds a version to the endpoint
    /// This can be added using the `withPath(_ path: String)` method but it's better for readability
    /// This method accepts a enumerator instead of a string
    ///
    /// - Parameter version: The version of the endpoint as string
    /// - Parameter T: The type of the enumerator containing the version
    @discardableResult
    public func withVersion<T>(_ version: T) -> Endpoint where T : StringRepresentable {
        self.withVersion(version.rawValue)
        return self
    }
    
    /// Adds a controller to the endpoint
    /// This can be added using the `withPath(_ path: String)` method but it's better for readability
    /// *NOTE: Do not append nor prepend the foward slash*
    ///
    /// - Parameter controller: The controller of the endpoint, usually a controller contains muitiple endpoints
    @discardableResult
    public func withController(_ controller: String) -> Endpoint {
        self.url.append("/\(controller)")
        return self
    }
    
    /// Adds a controller to the endpoint
    /// This can be added using the `withPath(_ path: String)` method but it's better for readability
    ///
    /// - Parameter controller: The controller of the endpoint, usually a controller contains muitiple endpoints
    /// - Parameter T: The type of the enumerator containing the controller
    @discardableResult
    public func withController<T>(_ controller: T) -> Endpoint where T : StringRepresentable {
        self.url.append("/\(controller.rawValue)")
        return self
    }
    
    /// Adds a path to the endpoint
    /// *NOTE: Do not append nor prepend the foward slash*
    ///
    /// - Parameter path: The path to the endpoint
    @discardableResult
    public func withPath(_ path: String) -> Endpoint {
        self.url.append("/\(path)")
        return self
    }
    
    /// Adds a path to the endpoint
    /// The path can contain values like `{id}` where `{id}` will be replaced by the key in the dictionary `parameters`
    /// *NOTE: Do not append nor prepend the foward slash*
    ///
    /// - Parameter path: The path to the endpoint
    /// - Parameter parameters: The dictionary with the parameters to replace
    @discardableResult
    public func withPath(_ path: String, parameters: [String : String]) -> Endpoint {
        self.withPath(path)
        parameters.forEach { (key, value) in
            self.url = self.url.replacingOccurrences(of: "{\(key)}", with: "\(value)")
        }
        return self
    }
    
    /// Adds query parameters to the url
    ///
    /// - Parameter query: The dictionary of query values to add
    @discardableResult
    public func withQuery(_ query: [String : String]) -> Endpoint {
        self.url += "?" + query.map { key, value in "\(key)=\(value)" }.joined(separator: "&")
        return self
    }
    
    /// Builds the URL
    ///
    /// - Throws: `SwiftlyRestError.invalidURL` if the provided URL is not valid
    /// - Returns: The built URL
    public func build() throws -> String {
        guard URL(string: self.url) != nil else {
            throw SwiftlyRestError.invalidURL(
                self.url
            )
        }
        return self.url
    }
    
}
