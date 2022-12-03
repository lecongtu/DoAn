//
//  GenresCollectionCellViewModel.swift
//  FinalProject
//
//  Created by tu.le2 on 10/08/2022.
//

import Foundation

final class GenresCollectionCellViewModel {

    // MARK: - Properties
    private(set) var genre: Genres?

    // MARK: - Initialize
    init(genre: Genres?) {
        self.genre = genre
    }
}
