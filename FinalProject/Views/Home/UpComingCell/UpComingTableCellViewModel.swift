//
//  UpComingTableCellViewModel.swift
//  FinalProject
//
//  Created by tu.le2 on 26/07/2022.
//

import Foundation

final class UpComingTableCellViewModel {

    // MARK: - Properties
    private(set) var upComings: [Slider]?

    init (upComings: [Slider]) {
        self.upComings = upComings
    }

    // MARK: - Public functions
    func numberOfItemsInSection() -> Int {
        guard let upComings = upComings else {
            return 0
        }

        if upComings.count < Define.numberOfItemsInSection {
            return upComings.count
        } else {
            return Define.numberOfItemsInSection
        }
    }

    func viewModelForItem(at indexPath: IndexPath) -> NowPlayingCollectionCellViewModel {
        guard let upComings = upComings,
              let item = upComings[safe: indexPath.row] else {
            return NowPlayingCollectionCellViewModel(slider: nil)
        }
        let viewModel = NowPlayingCollectionCellViewModel(slider: item)
        return viewModel
    }

    func getItemFor(indexPath: IndexPath) -> Slider? {
        guard let upComings = upComings else {
            return nil
        }

        return upComings[indexPath.row]
    }
}

// MARK: - Define
extension UpComingTableCellViewModel {
    struct Define {
        static let numberOfItemsInSection: Int = 10
    }
}
