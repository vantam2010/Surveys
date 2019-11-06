//
//  MockSurveyService.swift
//  SurveysTests
//
//  Created by Apple on 11/1/19.
//  Copyright © 2019 TamNguyen. All rights reserved.
//

import Foundation

@testable import Surveys

final class SurveyServiceMock {
    var shouldSuccess: Bool = true
    var emptyData: Bool = false
}

// MARK: - SurveyServiceProtocol
extension SurveyServiceMock: SurveyServiceProtocol {
    func fetchData(paging: Paging, completion: @escaping ((Result<[Survey], ErrorResult>) -> Void)) {
        if shouldSuccess {
            if emptyData {
                completion(.success([]))
            } else {
                completion(.success(Survey.list))
            }
        } else {
            completion(.failure(.resultNilOrEmpty))
        }
    }
}

// MARK: - Dummy
extension Survey {
    static let dummy: Survey = {
        return Survey.init(id: "id", title: "title", description: "description", coverImageUrl: "coverImageUrl")
    }()
    static let list: [Survey] = {
        return [Survey](repeating: Survey.dummy, count: 20)
    }()
}
