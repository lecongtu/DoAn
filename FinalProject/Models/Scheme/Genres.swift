//
//  Genres.swift
//  FinalProject
//
//  Created by tu.le2 on 10/08/2022.
//

import Foundation

final class Genres {

    // MARK: - Properties
    var id: Int?
    var name: String?
    var isSelect: Bool

    // MARK: - Initialize
    init(json: JSObject, isSelect: Bool = false) {
        id = json["id"] as? Int
        name = json["name"] as? String
        self.isSelect = isSelect
    }
}
