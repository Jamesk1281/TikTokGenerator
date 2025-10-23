//
//  UnsplashManager.swift
//  TikTokGenerator
//
//  Created by James . on 7/27/25.
//

import Foundation

actor UnsplashManager { // 50 PER HOUR MAX
    func fetchUnsplashImage(for topic: String) async throws -> URL? {
        let accessKey = fetchAccessKey()
        guard let encodedTopic = topic.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.unsplash.com/search/photos?query=\(encodedTopic)&client_id=\(accessKey)") else {
            return nil
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        let decoded = try JSONDecoder().decode(UnsplashSearchResult.self, from: data)
        guard let firstPhoto = decoded.results.first else {
            return nil
        }

        return URL(string: firstPhoto.urls.regular)
    }
    
    private func fetchAccessKey() -> String {
        "lKpxACBLvDMK9gO-ptL3ZZ9fQvXKHzeDDfwumOrR44w"
    }

}

struct UnsplashSearchResult: Decodable {
    let results: [UnsplashPhoto]
}

struct UnsplashPhoto: Decodable {
    let urls: UnsplashURLs
    let alt_description: String?
    let user: UnsplashUser
}

struct UnsplashURLs: Decodable {
    let regular: String
}

struct UnsplashUser: Decodable {
    let name: String
    let username: String
}
