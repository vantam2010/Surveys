//
//  SurveyListViewModel.swift
//  Surveys
//
//  Created by Apple on 10/19/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import Foundation

struct SurveyListViewModel {
    
    weak var dataSource: GenericDataSource<Survey>?
    weak var service: SurveyServiceProtocol?
    
    var onErrorHandling: ((ErrorResult<CustomError>?) -> Void)?
    
    init(service: SurveyServiceProtocol = SurveyService.shared, dataSource: GenericDataSource<Survey>?) {
        self.dataSource = dataSource
        self.service = service
    }
    
    func fetchData() {
        
        if let page = dataSource?.paging.page,
            let per_page = dataSource?.paging.per_page,
            let max_item = dataSource?.paging.max_item,
            let total_item = dataSource?.data.value.count {
            // return when all page was loaded or total items equals max item
            if page > per_page || total_item >= max_item {
                return
            }
        }
        
        // return when the next page is loading
        if dataSource?.isLoading == true {
            return
        }
        
        guard let service = service else {
            onErrorHandling?(.missingService)
            return
        }
        
        guard let paging = dataSource?.paging else {
            onErrorHandling?(.missingPaging)
            return
        }
        
        dataSource?.isLoading = true
        
        service.fetchData(paging: paging) { result in
            DispatchQueue.main.async {
                self.dataSource?.isLoading = false
                
                if let value = result.value {
                    if let page = self.dataSource?.paging.page {
                        self.dataSource?.paging.page = page + 1
                    }
                    
                    if value.count > 0 {
                        self.dataSource?.data.value += value
                    } else {
                        // call next page when data return empty
                        self.fetchData()
                    }
                    
                } else if let error = result.error {
                    switch error {
                    case .resultNil:
                        if let page = self.dataSource?.paging.page {
                            self.dataSource?.paging.page = page + 1
                            
                            // call next page when data return nil
                            self.fetchData()
                        }
                    default:
                        self.onErrorHandling?(error)
                    }
                }
            }
        }
    }
}


