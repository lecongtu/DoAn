//
//  LatestTableCellViewModel.swift
//  FinalProject
//
//  Created by tu.le2 on 26/07/2022.
//

import Foundation

final class LatestTableCellViewModel {

    // MARK: - Properties
    private(set) var latest: [Slider]?

    init(latest: [Slider]) {
        self.latest = latest
    }

    // MARK: - Public functions
    func numberOfItemsInSection() -> Int {
        guard let latest = latest else {
            return 0
        }

        if latest.count < Define.numberOfItemsInSection {
            return latest.count
        } else {
            return Define.numberOfItemsInSection
        }
    }

    func viewModelForItem(at indexPath: IndexPath) -> NowPlayingCollectionCellViewModel {
        guard let latest = latest,
              let item = latest[safe: indexPath.row] else {
            return NowPlayingCollectionCellViewModel(slider: nil)
        }
        let viewModel = NowPlayingCollectionCellViewModel(slider: item)
        return viewModel
    }

    func getItemFor(indexPath: IndexPath) -> Slider? {
        guard let latest = latest else {
            return nil
        }

        return latest[indexPath.row]
    }
}

// MARK: - Define
extension LatestTableCellViewModel {
    struct Define {
        static let numberOfItemsInSection: Int = 10
    }
}
