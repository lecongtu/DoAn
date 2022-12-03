//
//  ApiManager.Video.swift
//  FinalProject
//
//  Created by tu.le2 on 25/07/2022.
//

import Foundation

extension ApiManager.Movie {

    // MARK: - Enum
    enum Path {
        case upComing
        case topRated
        case popular
        case nowPlaying
        case latest
        case videos
        case details
        case recommendations
    }

    // MARK: - Properties
    static let moviePath: String = "\(ApiManager.Path.baseURL)\(ApiManager.Path.version)\(ApiManager.Path.moviePath)"

    // MARK: - Static functions
    static func getURL(type: Path, typePath: String, movieId: Int?) -> URL {
        var url: URL?
        switch type {
        case .popular, .topRated, .nowPlaying, .upComing:
            url = URL(string: ApiManager.Movie.moviePath + typePath)
        case .latest, .videos, .recommendations:
            guard let movieId = movieId else {
                return URL(fileURLWithPath: "")
            }
            url = URL(string: ApiManager.Movie.moviePath + "/\(movieId)" + typePath)
        case .details:
            url = URL(string: ApiManager.Movie.moviePath + "/\(String(describing: movieId))/")
        }

        guard let url = url else {
            return URL(fileURLWithPath: "")
        }

        return url.appending([
            URLQueryItem(name: "api_key", value: ApiManager.Path.apiKey)
        ])
    }

    static func getSliderURL() -> URL {
        return getURL(type: .popular, typePath: ApiManager.Path.popular, movieId: nil)
    }

    static func getNowPlayingURL() -> URL {
        return getURL(type: .nowPlaying, typePath: ApiManager.Path.nowPlaying, movieId: nil)
    }

    static func getTopRated() -> URL {
        return getURL(type: .topRated, typePath: ApiManager.Path.topRated, movieId: nil)
    }

    static func getLatest(movieId: Int) -> URL {
        return getURL(type: .latest, typePath: ApiManager.Path.latest, movieId: movieId)
    }

    static func getUpComing() -> URL {
        return getURL(type: .upComing, typePath: ApiManager.Path.upComing, movieId: nil)
    }

    static func getHomeApi(url: URL, completion: @escaping Completion<[Slider]>) {
        ApiManager.shared.request(method: .get, with: url) { result in
            switch result {
            case .success(let data):
                if let data = data {
                    var sliders: [Slider] = []
                    if let items = data["results"] as? [JSObject] {
                        for slider in items {
                            sliders.append(Slider(json: slider))
                        }
                    }
                    completion(.success(sliders))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
