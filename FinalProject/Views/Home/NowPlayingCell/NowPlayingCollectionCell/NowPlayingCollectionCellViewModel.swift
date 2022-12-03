//
//  NowPlayingCollectionCellViewModel.swift
//  FinalProject
//
//  Created by tu.le2 on 25/07/2022.
//

import Foundation

final class NowPlayingCollectionCellViewModel {

    // MARK: - Properties
    private(set) var slider: Slider?

    // MARK: - Initialize
    init(slider: Slider?) {
        self.slider = slider
    }
}
