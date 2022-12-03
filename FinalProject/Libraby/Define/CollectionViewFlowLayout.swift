//
//  CollectionViewFlowLayout.swift
//  FinalProject
//
//  Created by tu.le2 on 11/08/2022.
//

import UIKit

final class CollectionViewFlowLayout: UICollectionViewFlowLayout {

    // MARK: - Properties
    private var tempCellAttributesArray = [UICollectionViewLayoutAttributes]()
    private let leftEdgeInset: CGFloat = 0

    // MARK: - Override functions
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let cellAttributesArray = super.layoutAttributesForElements(in: rect)
        if cellAttributesArray != nil && cellAttributesArray?.count ?? 0 > 1 {
            for i in 1..<(cellAttributesArray?.count ?? 0) {
                let prevLayoutAttributes: UICollectionViewLayoutAttributes = cellAttributesArray?[i - 1] ?? UICollectionViewLayoutAttributes()
                let currentLayoutAttributes: UICollectionViewLayoutAttributes = cellAttributesArray?[i] ?? UICollectionViewLayoutAttributes()
                let prevCellMaxX: CGFloat = prevLayoutAttributes.frame.maxX
                let collectionViewSectionWidth = self.collectionViewContentSize.width - leftEdgeInset
                let currentCellExpectedMaxX = prevCellMaxX + Define.maximumSpacing + (currentLayoutAttributes.frame.size.width )
                if currentCellExpectedMaxX < collectionViewSectionWidth {
                    var frame: CGRect? = currentLayoutAttributes.frame
                    frame?.origin.x = prevCellMaxX + Define.maximumSpacing
                    frame?.origin.y = prevLayoutAttributes.frame.origin.y
                    currentLayoutAttributes.frame = frame ?? CGRect.zero
                } else {
                    currentLayoutAttributes.frame.origin.x = leftEdgeInset
                    if prevLayoutAttributes.frame.origin.x != 0 {
                        currentLayoutAttributes.frame.origin.y = prevLayoutAttributes.frame.origin.y + prevLayoutAttributes.frame.size.height + 08
                    }
                }
            }
        }
        return cellAttributesArray
    }
}

extension CollectionViewFlowLayout {
    struct Define {
        static let maximumSpacing: CGFloat = 8
    }
}
