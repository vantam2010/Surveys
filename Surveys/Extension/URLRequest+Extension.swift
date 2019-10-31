//
//  URLRequest+Extension.swift
//  Surveys
//
//  Created by Apple on 10/19/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import Foundation

extension URLRequest {
    init<T>(baseUrl: String, resource: Resource<T>) {
        let url = URL(baseUrl: baseUrl, resource: resource)
        
        self.init(url: url)
        
        httpMethod = resource.method.rawValue
        
        resource.headers.forEach{
            setValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        switch resource.method {
        case .post, .put:
            httpBody = try? JSONSerialization.data(withJSONObject: resource.params, options: [])
        default:
            break
        }
    }
}
