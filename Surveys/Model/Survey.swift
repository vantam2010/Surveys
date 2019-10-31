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
    var coverImageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case coverImageUrl = "cover_image_url"
    }
}
