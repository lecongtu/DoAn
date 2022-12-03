//
//  LoadingReusableView.swift
//  FinalProject
//
//  Created by tu.le2 on 11/08/2022.
//

import UIKit

final class LoadingReusableView: UICollectionReusableView {

    // MARK: - IBOutlets
   @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    var isShowIndicator: Bool = false {
        didSet {
            if isShowIndicator {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }

    // MARK: - Initialize
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.color = Define.colorIndicator
    }
}

extension LoadingReusableView {
    struct Define {
        static let colorIndicator: UIColor = .black
    }
}
