//
//  HeaderViewViewModel.swift
//  FinalProject
//
//  Created by tu.le2 on 17/08/2022.
//

import Foundation

final class HeaderViewViewModel {

    // MARK: - Properties
    private var tags: [Int] = []

    init(tags: [Int]) {
        self.tags = tags
    }

    // MARK: - Public functions
    func numberOfItemsInSection() -> Int {
        return tags.count
    }

    func viewModelForItem(at indexPath: IndexPath) -> TagsCollectionCellViewModel {
        let item = tags[safe: indexPath.row]
        let index = Define.tags.firstIndex { $0.id == item }
        guard let index = index else {
            return TagsCollectionCellViewModel(tag: "")
        }

        return TagsCollectionCellViewModel(tag: Define.tags[index].name)
    }

    func getTagForItem(at indexPath: IndexPath) -> String {
        let item = tags[safe: indexPath.row]
        let index = Define.tags.firstIndex { $0.id == item }
        guard let index = index else {
            return ""
        }
        return Define.tags[index].name
    }
}

extension HeaderViewViewModel {
    struct Tag {
        let id: Int
        let name: String
    }

    struct Define {
        static let tags: [Tag] = [
            Tag(id: 28, name: "Action"),
            Tag(id: 12, name: "Adventure"),
            Tag(id: 16, name: "Animation"),
            Tag(id: 35, name: "Comedy"),
            Tag(id: 80, name: "Crime"),
            Tag(id: 99, name: "Documentary"),
            Tag(id: 18, name: "Drama"),
            Tag(id: 1_751, name: "Family"),
            Tag(id: 14, name: "Fantasy"),
            Tag(id: 36, name: "History"),
            Tag(id: 27, name: "Horror"),
            Tag(id: 10_402, name: "Music"),
            Tag(id: 9_648, name: "Mystery"),
            Tag(id: 10_649, name: "Romance"),
            Tag(id: 878, name: "Science Fiction"),
            Tag(id: 10_770, name: "TV Movie"),
            Tag(id: 53, name: "Thriller"),
            Tag(id: 10_752, name: "War"),
            Tag(id: 37, name: "Western")
        ]
    }
}
