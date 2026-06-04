//
//  FrequencyGuideView.swift
//  SoulArtTempleNativeClean
//
//  Created by Soraya Roberts on 29/03/2026.
//
import SwiftUI

struct FrequencyGuideView: View {
    var body: some View {
        ScrollView {
            Image("frequency_chart")
                .resizable()
                .scaledToFit()
                .padding()
        }
        .background(Theme.templeParchment)
    }
}
