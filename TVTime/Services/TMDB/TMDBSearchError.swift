//
//  TMDBSearchError.swift
//  TVTime
//
//  Created by Giada Ciotola on 02/07/2026.
//

import Foundation

enum TMDBSearchError: LocalizedError {
    case missingAPIKey
    case invalidURL
    case invalidResponse
    case requestFailed(statusCode: Int)

    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            "Aggiungi la chiave TMDB in TMDB_API_KEY per cercare film e serie."
        case .invalidURL:
            "Non riesco a creare l'URL di ricerca."
        case .invalidResponse:
            "La risposta del server non e' valida."
        case .requestFailed(let statusCode):
            "La ricerca non e' riuscita. Codice \(statusCode)."
        }
    }
}
