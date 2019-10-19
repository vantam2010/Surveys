//
//  Networking.swift
//  Surveys
//
//  Created by Apple on 10/19/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import Foundation

struct Networking {
    
    static let shared = Networking.init(baseUrl: Configuration.Endpoints)
    
    private var baseUrl: String
    public var commonParams: JSON = [:]
    
    private init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    public func makeRequest<T, CustomError>(resource: Resource<T, CustomError>,
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
        
        let task = URLSession.shared.dataTask(with: request) { data, response, _ in
            // Parsing incoming data
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.other))
                return
            }
            
            if response.statusCode >= 200 && response.statusCode < 300 {
                completion(Result(value: data.flatMap(resource.parse), or: .other))
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
