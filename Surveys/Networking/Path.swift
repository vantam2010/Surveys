//
//  Path.swift
//  Surveys
//
//  Created by Apple on 10/19/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import Foundation

struct Path {
    private var components: [String]
    var absolutePath: String {
        return "/" + components.joined(separator: "/")
    }
    init(_ path: String) {
        components = path.components(separatedBy: "/").filter({ !$0.isEmpty })
    }
    mutating func append(path: Path) {
        components += path.components
    }
    func appending(path: Path) -> Path {
        var copy = self
        copy.append(path: path)
        return copy
    }
}
