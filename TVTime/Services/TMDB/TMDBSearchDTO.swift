//
//  TMDBSearchDTO.swift
//  TVTime
//
//  Created by Giada Ciotola on 02/07/2026.
//

struct TMDBSearchResponse: Decodable {
    let results: [TMDBSearchItem]
}

struct TMDBSearchItem: Decodable {
    enum MediaType: String, Decodable {
        case movie
        case tv
        case person
    }

    let id: Int
    let mediaType: MediaType
    let title: String?
    let name: String?
    let overview: String?
    let releaseDate: String?
    let firstAirDate: String?
    let posterPath: String?
    let voteAverage: Double?

    var kind: MediaSearchResult.Kind? {
        switch mediaType {
        case .movie:
            .movie
        case .tv:
            .tvShow
        case .person:
            nil
        }
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case mediaType = "media_type"
        case title
        case name
        case overview
        case releaseDate = "release_date"
        case firstAirDate = "first_air_date"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
    }
}
