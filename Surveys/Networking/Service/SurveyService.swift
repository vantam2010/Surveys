//
//  SurveyService.swift
//  Surveys
//
//  Created by Apple on 10/19/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import Foundation

protocol SurveyServiceProtocol : class {
    func fetchData(paging: Paging, completion: @escaping ((Result<[Survey], ErrorResult>) -> Void))
}

final class SurveyService : SurveyServiceProtocol {
    
    static let shared = SurveyService()
    
    var task : URLSessionTask?
    
    func fetchData(paging: Paging, completion: @escaping ((Result<[Survey], ErrorResult>) -> Void)) {
        // cancel previous request if already in progress
        cancelFetchData()
        
        task = Networking().makeRequest(resource: Resource.init(baseUrl: Configuration.BASE_URL, path: "surveys.json", method: .get, params: paging.dictionary ?? [:]), completion: completion)
    }
    
    func cancelFetchData() {
        if let task = task {
            task.cancel()
        }
        
        task = nil
    }
}
