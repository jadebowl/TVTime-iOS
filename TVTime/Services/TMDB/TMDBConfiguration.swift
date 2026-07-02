//
//  TMDBConfiguration.swift
//  TVTime
//
//  Created by Giada Ciotola on 02/07/2026.
//

import Foundation

enum TMDBConfiguration {
    static var apiKey: String {
        if let value = Bundle.main.object(forInfoDictionaryKey: "TMDB_API_KEY") as? String,
           !value.isEmpty,
           !value.hasPrefix("$(") {
            return value
        }

        return ProcessInfo.processInfo.environment["TMDB_API_KEY"] ?? ""
    }
}
