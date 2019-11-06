//
//  Networking.swift
//  Surveys
//
//  Created by Apple on 10/19/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import Foundation

class Networking {
    private let session: URLSession
    var commonParams: JSON = [:]
    init(session: URLSession = .shared) {
        self.session = session
    }
    func makeRequest<T>(resource: Resource<T>, completion: @escaping (Result<T, ErrorResult>) -> Void ) -> URLSessionDataTask? {
        if !Reachability.isConnectedToNetwork() {
            completion(.failure(.noInternetConnection))
        }
        var newResouce = resource
        newResouce.params = newResouce.params.merging(commonParams) { spec, _ in
            return spec
        }
        let request = URLRequest(resource: newResouce)
        let task = session.dataTask(with: request) { data, response, error in
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
                if let error = error {
                    completion(.failure(.unhandledError(error.localizedDescription)))
                } else {
                    completion(.failure(.other))
                }
            }
        }
        task.resume()
        return task
    }
}
