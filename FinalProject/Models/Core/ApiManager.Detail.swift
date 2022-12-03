//
//  ApiManager.Detail.swift
//  FinalProject
//
//  Created by tu.le2 on 21/08/2022.
//

import Foundation

extension ApiManager.Detail {

    static func getURL(movieID: Int, page: Int) -> URL {
        let url = URL(string: ApiManager.Movie.moviePath + "/\(movieID)/recommendations")
        guard let url = url else {
            return URL(fileURLWithPath: "")
        }

        return url.appending([
            URLQueryItem(name: "api_key", value: ApiManager.Path.apiKey),
            URLQueryItem(name: "page", value: "\(String(describing: page))")
        ])
    }

    static func getDetailApi(url: URL, completion: @escaping Completion<[Slider]>) {
        ApiManager.shared.request(method: .get, with: url) { result in
            switch result {
            case .success(let data):
                var sliders: [Slider] = []
                guard let data = data,
                      let items = data["results"] as? [JSObject] else {
                    completion(.failure(APIError.error("No data result")))
                    return
                }
                for slider in items {
                    sliders.append(Slider(json: slider))
                }
                completion(.success(sliders))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
