//
//  ApiManagerPath.swift
//  FinalProject
//
//  Created by An Nguyen Q. VN.Danang on 08/06/2022.
//

import Foundation

extension ApiManager.Path {

    // MARK: - Properties
    static let baseURL: String = "https://api.themoviedb.org"
    static let imageURL: String = "https://image.tmdb.org/t/p/w500"

    static let version: String = "/3"

    static let moviePath: String = "/movie"
    static let searchPath: String = "/search"
    static let discoverPath: String = "/discover"
    static let genrePath: String = "/genre\(moviePath)/list"

    static let popular: String = "/popular"
    static let upComing: String = "/upcoming"
    static let topRated: String = "/top_rated"
    static let nowPlaying: String = "/now_playing"
    static let latest: String = "/similar"

    static let apiKey: String = "be80edab20fccfb19907902f8eccdd6b"
}
