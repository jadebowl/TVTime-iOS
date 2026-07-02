//
//  ContentView.swift
//  TVTime
//
//  Created by Giada Ciotola on 02/07/2026.
//

import SwiftUI

struct ContentView: View {
    private let searchService: any MediaSearchProviding
    
    init(searchService: any MediaSearchProviding = TMDBSearchService()) {
        self.searchService = searchService
    }
    
    var body: some View {
        TabView {
            TVShowsView()
                .tabItem {
                    Label(String(localized: "navigation.tvshows"), systemImage: "tv")
                }
            
            MoviesView()
                .tabItem {
                    Label(String(localized: "navigation.movies"), systemImage: "film")
                }
            
            SearchView(searchService: searchService)
                .tabItem {
                    Label(String(localized: "navigation.search"), systemImage: "magnifyingglass")
                }
        }
    }
}

#Preview {
    ContentView(searchService: ContentPreviewSearchService())
}

private struct ContentPreviewSearchService: MediaSearchProviding {
    func search(query: String) async throws -> [MediaSearchResult] {
        [
            MediaSearchResult(
                id: "movie-1",
                tmdbID: 1,
                kind: .movie,
                title: "Interstellar",
                overview: "Un viaggio attraverso lo spazio alla ricerca di una nuova casa per l'umanita'.",
                releaseYear: "2014",
                posterURL: nil,
                voteAverage: 8.5
            )
        ]
    }
}
