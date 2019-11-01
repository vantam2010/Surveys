//
//  Paging.swift
//  Surveys
//
//  Created by Apple on 10/19/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import Foundation

struct Paging {
    var page: Int
    var totalPages: Int
    var totalResults: Int
    
    init(page: Int, totalPages: Int, totalResults: Int) {
        self.page = page
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
}
