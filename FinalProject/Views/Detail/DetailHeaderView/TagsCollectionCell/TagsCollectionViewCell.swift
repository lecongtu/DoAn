//
//  TagsCollectionViewCell.swift
//  FinalProject
//
//  Created by tu.le2 on 18/08/2022.
//

import UIKit

final class TagsCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlets
    @IBOutlet private var tagLabel: UILabel!

    // MARK: - Properties
    var viewModel: TagsCollectionCellViewModel? {
        didSet {
            updateCell()
        }
    }

    // MARK: - Override functions
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = Define.cornerRadius
    }

    // MARK: - Private functions
    private func updateCell() {
        guard let viewModel = viewModel else {
            return
        }

        tagLabel.text = viewModel.tag
    }
}

// MARK: - Define
extension TagsCollectionViewCell {

    struct Define {
        static let cornerRadius: CGFloat = 10
        static let fontSize: CGFloat = 14
    }
}
