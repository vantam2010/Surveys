//
//  Networking.swift
//  Surveys
//
//  Created by Apple on 10/19/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import Foundation

struct Networking {
    
    static let shared = Networking.init(baseUrl: Configuration.BASE_URL)
    
    private let baseUrl: String
    var commonParams: JSON = [:]
    
    private init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    func makeRequest<T, CustomError>(resource: Resource<T, CustomError>,
                            completion: @escaping (Result<T, CustomError>) ->()) -> URLSessionDataTask? {
        
        if !Reachability.isConnectedToNetwork() {
            completion(.failure(.noInternetConnection))
            return nil
        }
        
        var newResouce = resource
        newResouce.params = newResouce.params.merging(commonParams) { spec, common in
            return spec
        }
        
        let request = URLRequest(baseUrl: baseUrl, resource: newResouce)
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 30.0
        sessionConfig.timeoutIntervalForResource = 60.0
        
        let task = URLSession.init(configuration: sessionConfig).dataTask(with: request) { data, response, error in
            // Parsing incoming data
            guard let response = response as? HTTPURLResponse else {
                if let error = error {
                    if error.localizedDescription.contains("cancelled") {
                        completion(.failure(.cancelRequest))
                        return
                    } else if error.localizedDescription.contains("timeout") {
                        completion(.failure(.requestTimeout))
                        return
                    }
                }
                completion(.failure(.other))
                return
            }
            
            if response.statusCode >= 200 && response.statusCode < 300 {
                completion(Result(value: data.flatMap(resource.parse), or: .resultNilOrEmpty))
            } else if response.statusCode == 401 {
                completion(.failure(.unauthorized))
            } else if response.statusCode == 404 {
                completion(.failure(.notFound))
            } else if response.statusCode == 500 {
                completion(.failure(.internalServerError))
            } else {
                completion(.failure(data.flatMap(resource.parseError).map({.custom($0)}) ?? .other))
            }
        }
        
        task.resume()
        
        return task
        
    }
}
