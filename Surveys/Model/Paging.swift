//
//  Paging.swift
//  Surveys
//
//  Created by Apple on 10/19/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import Foundation

struct Paging: Codable {
    var page: Int
    var totalPages: Int
    var totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "per_page"
        case totalResults
    }
    
    init(page: Int, totalPages: Int, totalResults: Int) {
        self.page = page
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
}
