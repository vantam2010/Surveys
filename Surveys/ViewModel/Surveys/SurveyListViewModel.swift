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
        
        if let page = dataSource?.paging.page, let per_page = dataSource?.paging.per_page {
            // the last page was loaded
            if page > per_page {
                return
            }
        }
        
        // the next page is loading
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
                    self.dataSource?.data.value += value
                    
                    if let page = self.dataSource?.paging.page {
                        self.dataSource?.paging.page = page + 1
                    }
                } else if let error = result.error {
                    self.onErrorHandling?(error)
//                    switch error {
//                    case .resultNil:
//                        #warning("Need contact with back end team, why page 3 return empty and page 4 to 10 return nil")
//                        if let page = self.dataSource?.paging.page {
//                            self.dataSource?.paging.page = page + 1
//                        }
//                    default:
//                        self.onErrorHandling?(error)
//                    }
                }
            }
        }
    }
}


