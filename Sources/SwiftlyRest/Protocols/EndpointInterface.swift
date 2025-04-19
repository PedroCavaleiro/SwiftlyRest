//
//  EndpointInterface.swift
//  SwiftlyRest
//
//  Created by Pedro Cavaleiro on 19/04/2025.
//

import Foundation

public protocol EndpointInterface {
    
    var url: String { get }
    
    /// Adds a version to the endpoint
    /// This can be added using the `add(path: String)` method but it's better for readability
    /// *NOTE: Do not append nor prepend the foward slash*
    ///
    /// - Parameter version: The version of the endpoint as string
    func withVersion( _ version: String)
    
    /// Adds a version to the endpoint
    /// This can be added using the `add(path: String)` method but it's better for readability
    /// This method accepts a enumerator instead of a string
    ///
    /// - Parameter version: The version of the endpoint as string
    /// - Parameter T: The type of the enumerator containing the version
    func withVersion<T: StringRepresentable>(_ version: T)
    
    /// Adds a controller to the endpoint
    /// This can be added using the `withPath(_ path: String)` method but it's better for readability
    /// *NOTE: Do not append nor prepend the foward slash*
    ///
    /// - Parameter controller: The controller of the endpoint, usually a controller contains muitiple endpoints
    func withController(_ controller: String)
    
    /// Adds a controller to the endpoint
    /// This can be added using the `withPath(_ path: String)` method but it's better for readability
    ///
    /// - Parameter controller: The controller of the endpoint, usually a controller contains muitiple endpoints
    /// - Parameter T: The type of the enumerator containing the controller
    func withController<T: StringRepresentable>(_ controller: T)
    
    /// Adds a path to the endpoint
    /// *NOTE: Do not append nor prepend the foward slash*
    ///
    /// - Parameter path: The path to the endpoint
    func withPath(_ path: String)
    
    /// Adds a path to the endpoint
    /// The path can contain values like `{id}` where `{id}` will be replaced by the key in the dictionary `parameters`
    /// *NOTE: Do not append nor prepend the foward slash*
    ///
    /// - Parameter path: The path to the endpoint
    /// - Parameter parameters: The dictionary with the parameters to replace
    func withPath(_ path: String, parameters: [String: String])
    
    /// Adds query parameters to the url
    ///
    /// - Parameter query: The dictionary of query values to add
    func withQuery(_ query: [String: String])
    
    /// Builds the URL
    ///
    /// - Throws: `SwiftlyRestError.invalidURL` if the provided URL is not valid
    /// - Returns: The built URL
    func build() throws -> String
    
}
