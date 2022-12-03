//
//  CollectionExt.swift
//  FinalProject
//
//  Created by tu.le2 on 10/08/2022.
//

import Foundation

extension Collection {

    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
