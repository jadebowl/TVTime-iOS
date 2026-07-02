//
//  MediaSearchProviding.swift
//  TVTime
//
//  Created by Giada Ciotola on 02/07/2026.
//

protocol MediaSearchProviding {
    func search(query: String) async throws -> [MediaSearchResult]
}
