//
//  ContentMovieCollectionCellViewModel.swift
//  FinalProject
//
//  Created by tu.le2 on 10/08/2022.
//

import Foundation

final class ContentMovieCollectionCellViewModel {

    // MARK: - Properties
    private(set) var contentMovieSlider: Slider?

    // MARK: - Initialize
    init(contentMovieSlider: Slider?) {
        self.contentMovieSlider = contentMovieSlider
    }
}
