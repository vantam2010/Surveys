//
//  URLSessionMock.swift
//  SurveysTests
//
//  Created by Apple on 11/1/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import Foundation

class URLSessionMock: URLSession {
    typealias Completion = (Data?, URLResponse?, Error?) -> Void
    // Properties that enable us to set exactly what data or error
    // we want our mocked URLSession to return for any request.
    var data: Data?
    var error: Error?
    var respone: URLResponse?
    override func dataTask(with request: URLRequest, completionHandler: @escaping Completion) -> URLSessionDataTask {
        let data = self.data
        let error = self.error
        let respone = self.respone
        return URLSessionDataTaskMock {
            completionHandler(data, respone, error)
        }
    }
}
