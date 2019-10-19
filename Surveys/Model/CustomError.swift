//
//  CustomError.swift
//  Surveys
//
//  Created by Apple on 10/19/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import Foundation

struct CustomError: Error, Decodable {
    var message: String
}
