//
//  SearchCard.swift
//  TVTime
//
//  Created by Giada Ciotola on 02/07/2026.
//

import SwiftUI

struct SearchCard: View {
    let result: MediaSearchResult

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            PosterImage(url: result.posterURL)

            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .firstTextBaseline) {
                    Text(result.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .lineLimit(2)

                    Spacer(minLength: 8)

                    if let voteAverage = result.voteAverage, voteAverage > 0 {
                        Label(String(format: "%.1f", voteAverage), systemImage: "star.fill")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.yellow)
                    }
                }

                Text(result.metadata)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                if !result.overview.isEmpty {
                    Text(result.overview)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .lineLimit(3)
                }
            }
        }
        .padding(12)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 4)
        .accessibilityElement(children: .combine)
    }
}

private struct PosterImage: View {
    let url: URL?

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            case .failure:
                placeholder
            @unknown default:
                placeholder
            }
        }
        .frame(width: 78, height: 116)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }

    private var placeholder: some View {
        Image(systemName: "photo")
            .font(.title2)
            .foregroundStyle(.secondary)
    }
}

#Preview {
    SearchCard(
        result: MediaSearchResult(
            id: "movie-1",
            tmdbID: 1,
            kind: .movie,
            title: "Inception",
            overview: "Un ladro specializzato nell'estrarre segreti dai sogni riceve un ultimo incarico impossibile.",
            releaseYear: "2010",
            posterURL: nil,
            voteAverage: 8.4
        )
    )
    .padding()
}
