//
//  SliderCollectionViewCell.swift
//  FinalProject
//
//  Created by tu.le2 on 25/07/2022.
//

import UIKit

final class SliderCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlets
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!

    // MARK: - Properties
    var viewModel: SliderCollectionCellViewModel? {
        didSet {
            updateCell()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    // MARK: - Private functions
    private func updateCell() {
        guard let viewModel = viewModel else {
            return
        }
        nameLabel.text = viewModel.slider?.originalTitle
        if let imgURL = viewModel.slider?.backdropPath {
            imageView.downloadImage(url: ApiManager.Path.imageURL + imgURL)
        }
    }
}
