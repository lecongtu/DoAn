//
//  DataExt.swift
//  FinalProject
//
//  Created by An Nguyen Q. VN.Danang on 08/06/2022.
//

import Foundation

typealias JSObject = [String: Any]

extension Data {

    func toJSON() -> JSObject {
        var json: [String: Any] = [:]
        do {
            if let jsonObj = try JSONSerialization.jsonObject(with: self, options: .mutableContainers) as? JSObject {
                json = jsonObj
            }
        } catch {
            print("JSON casting error")
        }
        return json
    }
}
