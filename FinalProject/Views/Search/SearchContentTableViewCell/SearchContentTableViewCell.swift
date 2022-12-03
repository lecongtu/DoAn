//
//  SearchContentTableViewCell.swift
//  FinalProject
//
//  Created by tu.le2 on 23/08/2022.
//

import UIKit

final class SearchContentTableViewCell: UITableViewCell {

    @IBOutlet private weak var contentImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!

    var viewModel: SearchContentViewModel? {
        didSet {
            updateUI()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        contentImageView.layer.cornerRadius = Define.cornerRadius
    }

    private func updateUI() {
        guard let viewModel = viewModel else { return }
        if let image = viewModel.searchContents?.image {
            contentImageView.image = image
        } else {
            let imagePath = (viewModel.searchContents?.posterPath).content.isEmpty ? (viewModel.searchContents?.backdropPath).content : (viewModel.searchContents?.posterPath).content
            contentImageView.downloadImage(url: ApiManager.Path.imageURL + imagePath) { image in
                if let image = image {
                    viewModel.searchContents?.image = image
                    self.contentImageView.image = image
                } else {
                    self.contentImageView.image = nil
                }
            }
        }
        titleLabel.text = (viewModel.searchContents?.originalTitle).content
        contentLabel.text = (viewModel.searchContents?.overview).content
    }
}

extension SearchContentTableViewCell {
    struct Define {
        static let cornerRadius: CGFloat = 10
    }
}
