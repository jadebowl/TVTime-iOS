//
//  SearchView.swift
//  TVTime
//
//  Created by Giada Ciotola on 02/07/2026.
//

import SwiftUI

struct SearchView: View {
    private let searchService: any MediaSearchProviding
    private let searchEmptyStateOffset: CGFloat = -32

    @State private var searchText = ""
    @State private var results: [MediaSearchResult] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var hasSearched = false

    private var trimmedSearchText: String {
        searchText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    init(searchService: any MediaSearchProviding = TMDBSearchService()) {
        self.searchService = searchService
    }

    var body: some View {
        NavigationStack {
            ZStack {
                if results.isEmpty {
                    SearchStatusView(
                        isLoading: isLoading,
                        errorMessage: errorMessage,
                        hasSearched: hasSearched,
                        verticalOffset: searchEmptyStateOffset
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 14) {
                            ForEach(results) { result in
                                SearchCard(result: result)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(String(localized: "navigation.search"))
            .searchable(text: $searchText, prompt: Text(String(localized: "search.prompt")))
            .task(id: trimmedSearchText) {
                await search(trimmedSearchText)
            }
        }
    }

    @MainActor
    private func search(_ query: String) async {
        guard !query.isEmpty else {
            results = []
            errorMessage = nil
            isLoading = false
            hasSearched = false
            return
        }

        do {
            try await Task.sleep(nanoseconds: 350_000_000)
            try Task.checkCancellation()

            isLoading = true
            errorMessage = nil
            hasSearched = true

            results = try await searchService.search(query: query)
            isLoading = false
        } catch is CancellationError {
            isLoading = false
        } catch {
            results = []
            errorMessage = error.localizedDescription
            isLoading = false
            hasSearched = true
        }
    }
}

private struct SearchStatusView: View {
    let isLoading: Bool
    let errorMessage: String?
    let hasSearched: Bool
    let verticalOffset: CGFloat

    var body: some View {
        if isLoading {
            ProgressView(String(localized: "search.loading"))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .offset(y: verticalOffset)
        } else if let errorMessage {
            AlignedEmptyStateView(
                title: String(localized: "empty.search.unavailable.title"),
                systemImage: "wifi.exclamationmark",
                description: errorMessage,
                verticalOffset: verticalOffset
            )
        } else {
            EmptySearchState(
                hasSearched: hasSearched,
                verticalOffset: verticalOffset
            )
        }
    }
}

private struct EmptySearchState: View {
    let hasSearched: Bool
    let verticalOffset: CGFloat

    var body: some View {
        AlignedEmptyStateView(
            title: hasSearched
                ? String(
                    localized: "empty.search.noResults.title")
                : String(
                    localized: "empty.search.initial.title"),
            systemImage: hasSearched ? "magnifyingglass" : "popcorn",
            description: hasSearched
                ? String(
                    localized: "empty.search.noResults.description")
                : String(
                    localized: "empty.search.initial.description"),
            verticalOffset: verticalOffset
        )
    }
}

#Preview {
    SearchView(searchService: PreviewSearchService())
}

private struct PreviewSearchService: MediaSearchProviding {
    func search(query: String) async throws -> [MediaSearchResult] {
        [
            MediaSearchResult(
                id: "tv-1",
                tmdbID: 1,
                kind: .tvShow,
                title: "Breaking Bad",
                overview: "Un insegnante di chimica si reinventa in un mondo criminale sempre piu' pericoloso.",
                releaseYear: "2008",
                posterURL: nil,
                voteAverage: 8.9
            )
        ]
    }
}
