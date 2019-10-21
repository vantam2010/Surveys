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
    var per_page: Int
    var max_item: Int
    
    init(page: Int, per_page: Int, max_item: Int) {
        self.page = page
        self.per_page = per_page
        self.max_item = max_item
    }
}
