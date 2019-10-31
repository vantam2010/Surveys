//
//  Result.swift
//  Surveys
//
//  Created by Apple on 10/19/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import Foundation

enum Result<T, Error: Swift.Error> {
    case success(T)
    case failure(Error)
}

extension Result {
    init(value: T?, or error: Error) {
        guard let value = value else {
            self = .failure(error)
            return
        }
        
        self = .success(value)
    }
    
    var value: T? {
        guard case let .success(value) = self else { return nil }
        return value
    }
    
    var error: Error? {
        guard case let .failure(error) = self else { return nil }
        return error
    }
}
