//
//  SurveyService.swift
//  Surveys
//
//  Created by Apple on 10/19/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import Foundation

protocol SurveyServiceProtocol : class {
    func fetchData(paging: Paging, completion: @escaping ((Result<[Survey], CustomError>) -> Void))
}

final class SurveyService : SurveyServiceProtocol {
    
    static let shared = SurveyService()
    
    var task : URLSessionTask?
    
    func fetchData(paging: Paging, completion: @escaping ((Result<[Survey], CustomError>) -> Void)) {
        // cancel previous request if already in progress
        cancelFetchData()
        
        let params: [String: Any] = ["page": paging.page, "per_page": paging.per_page]
        task = Networking.shared.makeRequest(resource: Resource.init(path: "surveys.json", method: .get, params: params), completion: completion)
    }
    
    func cancelFetchData() {
        if let task = task {
            task.cancel()
        }
        
        task = nil
    }
}
