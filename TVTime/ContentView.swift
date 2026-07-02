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
            MediaLibraryPlaceholderView(
                title: "TV Shows",
                systemImage: "tv",
                emptyTitle: "Nessuna serie TV",
                emptyDescription: "Le serie che seguirai appariranno qui."
            )
            .tabItem {
                Label("TV Shows", systemImage: "tv")
            }

            MediaLibraryPlaceholderView(
                title: "Movies",
                systemImage: "film",
                emptyTitle: "Nessun film",
                emptyDescription: "I film che salverai appariranno qui."
            )
            .tabItem {
                Label("Movies", systemImage: "film")
            }

            SearchView(searchService: searchService)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
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

private struct MediaLibraryPlaceholderView: View {
    let title: String
    let systemImage: String
    let emptyTitle: String
    let emptyDescription: String

    var body: some View {
        NavigationStack {
            AlignedEmptyStateView(
                title: emptyTitle,
                systemImage: systemImage,
                description: emptyDescription
            )
            .navigationTitle(title)
        }
    }
}
