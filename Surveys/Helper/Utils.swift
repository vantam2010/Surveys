//
//  Utils.swift
//  Surveys
//
//  Created by Apple on 10/19/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import UIKit

public class Utils {
    public static func getErrorMessage(error: Error?) -> String {
        var errorMessage = ErrorMessage.defaultError.rawValue
        
        if let errorResult = error as? ErrorResult<CustomError> {
            switch errorResult {
            case .noInternetConnection:
                errorMessage = ErrorMessage.noInternetConnection.rawValue
            case .requestTimeout:
                errorMessage = ErrorMessage.requestTimeout.rawValue
            case .unauthorized:
                errorMessage = ErrorMessage.unauthorized.rawValue
            case .internalServerError:
                errorMessage = ErrorMessage.internalServerError.rawValue
            case .notFound:
                errorMessage = ErrorMessage.notFound.rawValue
            default:
                break
            }
        }
        
        return errorMessage
    }
    
    public static func visibleViewController() -> UIViewController? {
        let appDelegate = UIApplication.shared.delegate
        if let window = appDelegate!.window {
            return window?.visibleViewController
        }
        return nil
    }
}
