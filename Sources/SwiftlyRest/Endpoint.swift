//
//  File.swift
//  SwiftlyRest
//
//  Created by Pedro Cavaleiro on 19/04/2025.
//

import Foundation

public class Endpoint: EndpointInterface {
    
    
    public var url: String = ""
    
    /// Adds a version to the endpoint
    /// This can be added using the `withPath(_ path: String)` method but it's better for readability
    /// *NOTE: Do not append nor prepend the foward slash*
    ///
    /// - Parameter version: The version of the endpoint as string
    public func withVersion(_ version: String) { self.url.append("/\(version)") }
    
    /// Adds a version to the endpoint
    /// This can be added using the `withPath(_ path: String)` method but it's better for readability
    /// This method accepts a enumerator instead of a string
    ///
    /// - Parameter version: The version of the endpoint as string
    /// - Parameter T: The type of the enumerator containing the version
    public func withVersion<T>(_ version: T) where T : StringRepresentable { self.withVersion(version.rawValue) }
    
    /// Adds a controller to the endpoint
    /// This can be added using the `withPath(_ path: String)` method but it's better for readability
    /// *NOTE: Do not append nor prepend the foward slash*
    ///
    /// - Parameter controller: The controller of the endpoint, usually a controller contains muitiple endpoints
    public func withController(_ controller: String) { self.url.append("/\(controller)") }
    
    /// Adds a controller to the endpoint
    /// This can be added using the `withPath(_ path: String)` method but it's better for readability
    ///
    /// - Parameter controller: The controller of the endpoint, usually a controller contains muitiple endpoints
    /// - Parameter T: The type of the enumerator containing the controller
    public func withController<T>(_ controller: T) where T : StringRepresentable { self.withController(controller.rawValue) }
    
    /// Adds a path to the endpoint
    /// *NOTE: Do not append nor prepend the foward slash*
    ///
    /// - Parameter path: The path to the endpoint
    public func withPath(_ path: String) { self.url.append("/\(path)") }
    
    /// Adds a path to the endpoint
    /// The path can contain values like `{id}` where `{id}` will be replaced by the key in the dictionary `parameters`
    /// *NOTE: Do not append nor prepend the foward slash*
    ///
    /// - Parameter path: The path to the endpoint
    /// - Parameter parameters: The dictionary with the parameters to replace
    public func withPath(_ path: String, parameters: [String : String]) {
        self.withPath(path)
        parameters.forEach { (key, value) in
            self.url = self.url.replacingOccurrences(of: "{\(key)}", with: "\(value)")
        }
    }
    
    /// Adds query parameters to the url
    ///
    /// - Parameter query: The dictionary of query values to add
    public func withQuery(_ query: [String : String]) {
        self.url += "?" + query.map { key, value in "\(key)=\(value)" }.joined(separator: "&")
    }
    
    /// Builds the URL
    ///
    /// - Throws: `SwiftlyRestError.invalidURL` if the provided URL is not valid
    /// - Returns: The built URL
    public func build() throws -> String {
        guard URL(string: self.url) != nil else { throw SwiftlyRestError.invalidURL }
        return self.url
    }
    
}
