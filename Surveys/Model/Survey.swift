//
//  Survey.swift
//  Surveys
//
//  Created by Apple on 10/19/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import Foundation

class Survey: Decodable {
    let id: String?
    let title: String?
    let description: String?
    let coverImageUrl: String?
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case coverImageUrl = "cover_image_url"
    }
    init(id: String, title: String, description: String, coverImageUrl: String) {
        self.id = id
        self.title = title
        self.description = description
        self.coverImageUrl = coverImageUrl
    }

}
