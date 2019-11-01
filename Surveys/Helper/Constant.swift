//
//  Constant.swift
//  Surveys
//
//  Created by Apple on 10/19/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import Foundation

enum ErrorResult: Error {
    case noInternetConnection
    case requestTimeout
    case cancelRequest
    case notFound
    case unauthorized
    case internalServerError
    case unhandledError(String)
    case resultNilOrEmpty
    case other
    case missingService
    case missingPaging
    
    var localizedDescription: String {
        switch self {
        case .noInternetConnection: return "No Internet Connection."
        case .requestTimeout: return "Request timeout."
        case .cancelRequest: return "Cancel Request"
        case .notFound: return "Not Found"
        case .unauthorized: return "Unauthorized"
        case .internalServerError: return "Internal Server Error"
        case .unhandledError(let message): return message
        case .resultNilOrEmpty: return "Result nil or empty"
        case .other: return "Oops, something went wrong"
        case .missingService: return "Missing Service"
        case .missingPaging: return "Cancel Request"
        
        }
    }
}

enum KeychainError: Error {
    case string2DataConversionError
    case data2StringConversionError
    case unhandledError(message: String)
    
    var localizedDescription: String {
        switch self {
        case .string2DataConversionError: return "String to Data conversion error"
        case .data2StringConversionError: return "Data to String conversion error"
        case .unhandledError(let message): return message     
        }
    }
}
