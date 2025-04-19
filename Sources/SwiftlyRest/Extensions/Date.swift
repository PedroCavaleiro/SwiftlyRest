//
//  Date.swift
//  SwiftlyRest
//
//  Created by Pedro Cavaleiro on 19/04/2025.
//

import Foundation

extension Date {
    
    public func timestamp(inMilliSeconds: Bool = false) -> Int64 {
        return inMilliSeconds
            ? Int64(Date().timeIntervalSince1970)
            : Int64(Date().timeIntervalSince1970 * 1000)
    }
    
}
