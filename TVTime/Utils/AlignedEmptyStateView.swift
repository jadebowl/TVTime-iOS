//
//  AlignedEmptyStateView.swift
//  TVTime
//
//  Created by Giada Ciotola on 02/07/2026.
//

import SwiftUI

struct AlignedEmptyStateView: View {
    let title: String
    let systemImage: String
    let description: String
    var verticalOffset: CGFloat = 0

    var body: some View {
        VStack {
            Spacer()

            ContentUnavailableView(
                title,
                systemImage: systemImage,
                description: Text(description)
            )

            Spacer()
        }
        .offset(y: verticalOffset)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}
