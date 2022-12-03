//
//  StringExt.swift
//  FinalProject
//
//  Created by An Nguyen Q. VN.Danang on 08/06/2022.
//

import Foundation

extension String {
    struct Define {
        static let getValueFailFromRealm = "Can not get value from Realm"
        static let deleteValueFailFromRealm = "Can not delete value from Realm"
    }
}

extension Optional {
    var content: String {
        switch self {
        case .some(let value):
            return String(describing: value)
        case .none:
            return ""
        }
    }
}
