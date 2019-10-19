//
//  Constant.swift
//  Surveys
//
//  Created by Apple on 10/19/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import Foundation

public enum ErrorResult<CustomError>: Error {
    case noInternetConnection
    case requestTimeout
    case notFound
    case unauthorized
    case internalServerError
    case custom(CustomError)
    case other
    case missingService
}


public enum ErrorMessage: String {
    case noInternetConnection = "No Internet Connection"
    case requestTimeout = "Request timeout"
    case unauthorized = "Unauthorized"
    case internalServerError = "Internal Server Error"
    case notFound = "Not Found"
    case defaultError = "Oops, something went wrong!"
    case titleError = "Error"
}
