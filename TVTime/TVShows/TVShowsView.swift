//
//  TVShowsView.swift
//  TVTime
//
//  Created by Giada Ciotola on 02/07/2026.
//

import SwiftUI

struct TVShowsView: View {
    var body: some View {
        NavigationStack {
            AlignedEmptyStateView(
                title: String(localized: "empty.tvshows.title"),
                systemImage: "tv",
                description: String(localized: "empty.tvshows.description")
            )
            .navigationTitle(String(localized: "navigation.tvshows"))
        }
    }
}

#Preview {
    TVShowsView()
}
