//
//  SurveyListViewModel.swift
//  Surveys
//
//  Created by Apple on 10/19/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import Foundation

struct SurveyListViewModel {
    
    weak var dataSource : GenericDataSource<Survey>?
    weak var service: SurveyServiceProtocol?
    
    var paging = Paging.init(page: 1, per_page: 10)
    var onErrorHandling : ((ErrorResult<CustomError>?) -> Void)?
    
    init(service: SurveyServiceProtocol = SurveyService.shared, dataSource : GenericDataSource<Survey>?) {
        self.dataSource = dataSource
        self.service = service
    }
    
    func fetchData() {
        
        guard let service = service else {
            onErrorHandling?(.missingService)
            return
        }
        
        service.fetchData(paging: paging) { result in
            DispatchQueue.main.async {
                if let value = result.value {
                    self.dataSource?.data.value += value
                } else if let error = result.error {
                    self.onErrorHandling?(error)
                }
            }
        }
    }
    
    func refreshData() {
        self.dataSource?.data.value = []
    }
}
