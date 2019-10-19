//
//  Paging.swift
//  Surveys
//
//  Created by Apple on 10/19/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import Foundation

struct Paging {
    var page = 1
    var per_page = 10
    
    init(page: Int, per_page: Int) {
        self.page = page
        self.per_page = per_page
    }
}
