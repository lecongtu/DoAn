//
//  SliderTableCellViewModel.swift
//  FinalProject
//
//  Created by tu.le2 on 25/07/2022.
//

import Foundation

final class SliderTableCellViewModel {

    // MARK: - Properties
    private(set) var sliders: [Slider]?

    init (sliders: [Slider]) {
        self.sliders = sliders
    }

    // MARK: - public functions
    func numberOfItemsInSection() -> Int {
        guard let sliders = sliders else {
            return 0
        }

        if sliders.count < Define.numberOfItemsInSection {
            return sliders.count
        } else {
            return Define.numberOfItemsInSection
        }
    }

    func viewModelForItem(at indexPath: IndexPath) -> SliderCollectionCellViewModel {
        guard let sliders = sliders,
            let item = sliders[safe: indexPath.row] else {
            return SliderCollectionCellViewModel(slider: nil)
        }

        let viewModel = SliderCollectionCellViewModel(slider: item)
        if indexPath.row == 0 {
            let userdefault = UserDefaults.standard
            userdefault.set(item.id, forKey: Session.shared.movieId)
        }
        return viewModel
    }

    func getItemFor(indexPath: IndexPath) -> Slider? {
        guard let sliders = sliders else {
            return nil
        }

        return sliders[indexPath.row]
    }
}

// MARK: - Define
extension SliderTableCellViewModel {
    struct Define {
        static let numberOfItemsInSection: Int = 10
    }
}
