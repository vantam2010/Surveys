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
    
    var onErrorHandling: ((ErrorResult) -> Void)?
    
    init(service: SurveyServiceProtocol = SurveyService.shared, dataSource: GenericDataSource<Survey>?) {
        self.dataSource = dataSource
        self.service = service
    }
    
    func fetchData() {
        
        // return when the next page is loading
        if dataSource?.isLoading == true {
            return
        }
        
        // return when is loadMore is false
        if dataSource?.isLoadMore == false {
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
                    if let page = self.dataSource?.paging.page,
                        let currentItems = self.dataSource?.data.value.count,
                        let totalResults = self.dataSource?.paging.totalResults {
                        
                        if page == self.dataSource?.paging.totalPages || currentItems + value.count >= totalResults {
                            self.dataSource?.isLoadMore = false
                        } else {
                            self.dataSource?.paging.page = page + 1
                        }
                    }
                    
                    if value.count > 0 {
                        self.dataSource?.data.value += value
                    } else {
                        // result is empty
                        self.onErrorHandling?(ErrorResult.resultNilOrEmpty)
                    }
                    
                } else if let error = result.error {
                    self.onErrorHandling?(error)
                }
            }
        }
    }
}


