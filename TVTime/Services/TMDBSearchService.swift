//
//  TMDBSearchService.swift
//  TVTime
//
//  Created by Giada Ciotola on 02/07/2026.
//

import Foundation

struct TMDBSearchService: MediaSearchProviding {
    private let apiKey: String
    private let session: URLSession
    private let baseURL = URL(string: "https://api.themoviedb.org/3")!
    private let imageBaseURL = URL(string: "https://image.tmdb.org/t/p/w342")!

    init(
        apiKey: String = TMDBConfiguration.apiKey,
        session: URLSession = .shared
    ) {
        self.apiKey = apiKey
        self.session = session
    }

    func search(query: String) async throws -> [MediaSearchResult] {
        guard !apiKey.isEmpty else {
            throw TMDBSearchError.missingAPIKey
        }

        var components = URLComponents(
            url: baseURL.appending(path: "search/multi"),
            resolvingAgainstBaseURL: false
        )
        components?.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "include_adult", value: "false"),
            URLQueryItem(name: "language", value: preferredLanguage),
            URLQueryItem(name: "page", value: "1")
        ]

        guard let url = components?.url else {
            throw TMDBSearchError.invalidURL
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "accept")

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw TMDBSearchError.invalidResponse
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            throw TMDBSearchError.requestFailed(statusCode: httpResponse.statusCode)
        }

        let decodedResponse = try JSONDecoder().decode(TMDBSearchResponse.self, from: data)
        return decodedResponse.results.compactMap(makeSearchResult)
    }

    private var preferredLanguage: String {
        let language = Locale.current.language.languageCode?.identifier ?? "en"
        let region = Locale.current.region?.identifier ?? "US"
        return "\(language)-\(region)"
    }

    private func makeSearchResult(from result: TMDBSearchItem) -> MediaSearchResult? {
        guard let kind = result.kind else {
            return nil
        }

        let title = result.title ?? result.name ?? "Titolo non disponibile"
        let date = result.releaseDate ?? result.firstAirDate

        return MediaSearchResult(
            id: "\(result.mediaType.rawValue)-\(result.id)",
            tmdbID: result.id,
            kind: kind,
            title: title,
            overview: result.overview ?? "",
            releaseYear: releaseYear(from: date),
            posterURL: posterURL(from: result.posterPath),
            voteAverage: result.voteAverage
        )
    }

    private func posterURL(from path: String?) -> URL? {
        guard let path, !path.isEmpty else {
            return nil
        }

        let normalizedPath = path.hasPrefix("/") ? String(path.dropFirst()) : path
        return imageBaseURL.appending(path: normalizedPath)
    }

    private func releaseYear(from date: String?) -> String? {
        guard let date, date.count >= 4 else {
            return nil
        }

        return String(date.prefix(4))
    }
}
