// BodyDecoderView.swift
import SwiftUI

struct BodyDecoderView: View {
    var body: some View {
        ZStack {
            AppBackground(imageName: "sacred-rooms") {
            }
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    Text("Body Decoder")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)

                    Text("Body Decoder placeholder")
                        .foregroundStyle(.white.opacity(0.85))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 120)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}
