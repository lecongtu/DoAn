//
//  Slider.swift
//  FinalProject
//
//  Created by tu.le2 on 08/08/2022.
//

import Foundation
import UIKit

final class Slider {

    // MARK: - Properties
    var backdropPath: String?
    var posterPath: String?
    var id: Int?
    var originalTitle: String?
    var overview: String?
    var voteAverage: Double?
    var genres: [Int]?
    var image: UIImage?

    // MARK: - Initialize
    init(json: JSObject) {
        backdropPath = json["backdrop_path"] as? String
        id = json["id"] as? Int
        originalTitle = json["original_title"] as? String
        overview = json["overview"] as? String
        voteAverage = json["vote_average"] as? Double
        genres = json["genre_ids"] as? [Int]
        posterPath = json["poster_path"] as? String
    }
}
