//
//  ApiManager.Video.swift
//  FinalProject
//
//  Created by tu.le2 on 18/08/2022.
//

import Foundation

extension ApiManager.Video {
    static let videoPath = ApiManager.Path.baseURL + ApiManager.Path.version + ApiManager.Path.moviePath

    static func getURL(movieID: Int) -> URL {
        guard let url = URL(string: videoPath + "/\(movieID)/videos") else { return URL(fileURLWithPath: "") }
        return url.appending([
            URLQueryItem(name: "api_key", value: ApiManager.Path.apiKey)
        ])
    }

    static func getVideoApi(url: URL, completion: @escaping Completion<[Video]>) {
        ApiManager.shared.request(method: .get, with: url) { result in
            switch result {
            case .success(let data):
                var videos: [Video] = []
                guard let data = data,
                      let items = data["results"] as? [JSObject] else {
                    completion(.failure(APIError.error("No data result")))
                    return
                }
                for video in items {
                    videos.append(Video(json: video))
                }
                completion(.success(videos))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
