//
//  TopRatedTableCellViewModel.swift
//  FinalProject
//
//  Created by tu.le2 on 26/07/2022.
//

import Foundation

final class TopRatedTableCellViewModel {

    // MARK: - Properties
    private(set) var topRated: [Slider]?

    init (topRated: [Slider]) {
        self.topRated = topRated
    }

    // MARK: - Public functions
    func numberOfItemsInSection() -> Int {
        guard let topRated = topRated else {
            return 0
        }

        if topRated.count < Define.numberOfItemsInSection {
            return topRated.count
        } else {
            return Define.numberOfItemsInSection
        }
    }

    func viewModelForItem(at indexPath: IndexPath) -> NowPlayingCollectionCellViewModel {
        guard let topRated = topRated,
              let item = topRated[safe: indexPath.row] else {
            return NowPlayingCollectionCellViewModel(slider: nil)
        }
        let viewModel = NowPlayingCollectionCellViewModel(slider: item)
        return viewModel
    }

    func getItemFor(indexPath: IndexPath) -> Slider? {
        guard let topRated = topRated else {
            return nil
        }

        return topRated[indexPath.row]
    }
}

// MARK: - Define
extension TopRatedTableCellViewModel {
    struct Define {
        static let numberOfItemsInSection: Int = 10
    }
}
