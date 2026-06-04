import SwiftUI

struct JournalViewWithImage: View {
    
    @EnvironmentObject var discoveryStore: DiscoveryStore
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss

    var image: UIImage?
    @State private var reflection: String = ""
    @State private var showNextStepOptions = false
    @State private var showSaved = false

    var body: some View {

        ZStack {

            Theme.templeParchment.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {

                    // 🎨 IMAGE
                    if let image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.1), radius: 8)
                            .padding(.horizontal, 20)
                    }

                    // 🌿 PROMPT
                    VStack(spacing: 6) {
                        Text("What did this express?")
                            .font(Theme.sectionTitle)
                            .foregroundStyle(Theme.textPrimary)
                        Text("Let your feeling find words")
                            .font(Theme.smallText)
                            .foregroundStyle(Theme.textSecondary.opacity(0.6))
                    }

                    // ✍️ REFLECTION
                    TextEditor(text: $reflection)
                        .frame(height: 150)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.6))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Theme.goldSoft.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.horizontal, 20)

                    if !showNextStepOptions {

                        // 💾 SAVE BUTTON
                        Button {
                            saveReflection()
                        } label: {
                            Text("Save Reflection")
                                .font(Theme.cardTitle)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Theme.deepBrown)
                                .foregroundStyle(Theme.warmParchment)
                                .cornerRadius(14)
                                .padding(.horizontal, 40)
                        }

                    } else {

                        // ✅ SAVED CONFIRMATION
                        VStack(spacing: 12) {

                            Text("🌿 Saved to your journey")
                                .font(Theme.smallText)
                                .foregroundStyle(Theme.textSecondary)

                            Button {
                                dismiss()
                            } label: {
                                Text("Create Again")
                                    .font(Theme.cardTitle)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(Theme.deepBrown.opacity(0.4), lineWidth: 1)
                                    )
                                    .foregroundStyle(Theme.deepBrown)
                                    .padding(.horizontal, 40)
                            }

                            Button {
                                            dismiss()
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                appState.returnToHome = true
                                            }
                                        } label: {
                                            Text("Complete")
                                                .font(Theme.cardTitle)
                                                .frame(maxWidth: .infinity)
                                                .padding()
                                                .background(Theme.deepBrown)
                                                .foregroundStyle(Theme.warmParchment)
                                                .cornerRadius(14)
                                                .padding(.horizontal, 40)
                                        }
                        }
                    }

                    Spacer(minLength: 40)
                }
                .padding(.top, 30)
            }
        }
        .navigationTitle("Creative Reflection")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - SAVE

    func saveReflection() {

        let imageData = image?.jpegData(compressionQuality: 0.8)

        if let releaseIndex = discoveryStore.sessions.firstIndex(where: { $0.type == "release" }) {
            discoveryStore.sessions[releaseIndex].imageData = imageData
            if discoveryStore.sessions[releaseIndex].reflection == nil {
                discoveryStore.sessions[releaseIndex].reflection = reflection.isEmpty ? nil : reflection
            } else if !reflection.isEmpty {
                discoveryStore.sessions[releaseIndex].reflection = (discoveryStore.sessions[releaseIndex].reflection ?? "") + "\n\n🎨 Creative reflection:\n" + reflection
            }
            discoveryStore.saveSessions()
        } else {
            let session = SessionEntry(
                id: UUID(),
                type: "creative",
                emotion: "Creative Expression",
                category: "Creative",
                date: Date(),
                reflection: reflection.isEmpty ? nil : reflection,
                replacement: "",
                meaning: "Artwork Expression",
                imageData: imageData
            )
            discoveryStore.sessions.insert(session, at: 0)
            discoveryStore.saveSessions()
        }

        withAnimation {
            showNextStepOptions = true
        }
    }
}
