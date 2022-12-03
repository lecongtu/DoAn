//
//  SizeWithScreen.swift
//  FinalProject
//
//  Created by tu.le2 on 28/07/2022.
//

import Foundation
import UIKit

final class SizeWithScreen {

    static let shared: SizeWithScreen = SizeWithScreen()

    // MARK: - Initialize
    private init() {}

    // MARK: - Properties
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    let size = UIScreen.main.bounds.size
}
