//
//  Session.swift
//  FinalProject
//
//  Created by tu.le2 on 09/08/2022.
//

import Foundation

final class Session {
    static let shared: Session = Session()

    // MARK: - Initialize
    private init() {}

    // MARK: - Properties
    let movieId = "movieId"
}
