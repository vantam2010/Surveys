//
//  Survey.swift
//  Surveys
//
//  Created by Apple on 10/19/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import Foundation

class Survey: Decodable {
    var id: String?
    var title: String?
    var description: String?
    var cover_image_url: String?
}
