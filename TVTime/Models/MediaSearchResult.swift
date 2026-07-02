//
//  MediaSearchResult.swift
//  TVTime
//
//  Created by Giada Ciotola on 02/07/2026.
//

import Foundation

struct MediaSearchResult: Identifiable, Hashable {
    enum Kind: String {
        case movie = "Film"
        case tvShow = "Serie TV"
    }

    let id: String
    let tmdbID: Int
    let kind: Kind
    let title: String
    let overview: String
    let releaseYear: String?
    let posterURL: URL?
    let voteAverage: Double?

    var metadata: String {
        [kind.rawValue, releaseYear]
            .compactMap { $0 }
            .joined(separator: " • ")
    }
}
