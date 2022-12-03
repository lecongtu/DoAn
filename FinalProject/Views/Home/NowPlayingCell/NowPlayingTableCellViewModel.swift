//
//  NowPlayingTableCellViewModel.swift
//  FinalProject
//
//  Created by tu.le2 on 25/07/2022.
//

import Foundation

final class NowPlayingTableCellViewModel {

    // MARK: - Properties
    private(set) var nowPlayings: [Slider]?

    init (nowPlayings: [Slider]) {
        self.nowPlayings = nowPlayings
    }

    // MARK: - Public functions
    func numberOfItemsInSection() -> Int {
        guard let nowPlayings = nowPlayings else {
            return 0
        }
        if nowPlayings.count < Define.numberOfItemsInSection {
            return nowPlayings.count
        } else {
            return Define.numberOfItemsInSection
        }
    }

    func viewModelForItem(at indexPath: IndexPath) -> NowPlayingCollectionCellViewModel {
        guard let nowPlayings = nowPlayings,
              let item = nowPlayings[safe: indexPath.row] else {
            return NowPlayingCollectionCellViewModel(slider: nil)
        }
        let viewModel = NowPlayingCollectionCellViewModel(slider: item)
        return viewModel
    }

    func getItemFor(indexPath: IndexPath) -> Slider? {
        guard let nowPlayings = nowPlayings else {
            return nil
        }

        return nowPlayings[indexPath.row]
    }
}

// MARK: - Define
extension NowPlayingTableCellViewModel {
    struct Define {
        static let numberOfItemsInSection: Int = 10
    }
}
