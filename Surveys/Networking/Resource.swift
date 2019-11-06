//
//  Resource.swift
//  Surveys
//
//  Created by Apple on 10/19/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import Foundation

typealias JSON = [String: Any]
typealias HTTPHeaders = [String: String]

enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

struct Resource<T> {
    let baseUrl: String
    let path: Path
    let method: RequestMethod
    var headers: HTTPHeaders
    var params: JSON
    let service: KeychainService
    let parse: (Data) -> T?
    init(baseUrl: String,
         path: String,
         method: RequestMethod = .get,
         params: JSON = [:],
         headers: HTTPHeaders = [:],
         service: KeychainService = KeychainService.shared,
         parse: @escaping (Data) -> T?) {
        self.baseUrl = baseUrl
        self.path = Path(path)
        self.method = method
        self.params = params
        self.headers = headers
        self.service = service
        self.parse = parse
    }
}

extension Resource where T: Decodable {
    init(jsonDecoder: JSONDecoder = JSONDecoder(),
         baseUrl: String,
         path: String,
         method: RequestMethod = .get,
         params: JSON = [:],
         headers: HTTPHeaders = [:],
         service: KeychainService = KeychainService.shared) {
        var newHeaders = headers
        newHeaders["Accept"] = "application/json"
        newHeaders["Content-Type"] = "application/json"
        do {
            if let token = try service.getToken() {
                newHeaders["Authorization"] = "bearer \(token)"
            }
        } catch (let error) {
            print(error)
        }
        self.baseUrl = baseUrl
        self.path = Path(path)
        self.method = method
        self.params = params
        self.headers = newHeaders
        self.service = service
        self.parse = {
            try? jsonDecoder.decode(T.self, from: $0)
        }
    }
}
