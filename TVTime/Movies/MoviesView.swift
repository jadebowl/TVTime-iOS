//
//  MoviesView.swift
//  TVTime
//
//  Created by Giada Ciotola on 02/07/2026.
//

import SwiftUI

struct MoviesView: View {
    var body: some View {
        NavigationStack {
            AlignedEmptyStateView(
                title: String(localized: "empty.movies.title"),
                systemImage: "film",
                description: String(localized: "empty.movies.description")
            )
            .navigationTitle(String(localized: "navigation.movies"))
        }
    }
}

#Preview {
    MoviesView()
}
