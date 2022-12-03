//
//  SearchCollectionViewCell.swift
//  FinalProject
//
//  Created by tu.le2 on 22/08/2022.
//

import UIKit

final class SearchCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var titleLabel: UILabel!

    var viewModel: SearchCollectionCellViewModel? {
        didSet {
            updateUI()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = Define.cornerRadius
    }

    private func updateUI() {
        guard let viewModel = viewModel else {
            return
        }

        titleLabel.text = viewModel.title
    }
}

extension SearchCollectionViewCell {
    struct Define {
        static let cornerRadius: CGFloat = 15
    }
}
