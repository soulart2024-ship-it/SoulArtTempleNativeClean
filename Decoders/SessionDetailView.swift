import SwiftUI

struct SessionDetailView: View {

    var session: SessionEntry

    var body: some View {

        ZStack {
            Theme.templeParchment
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {

                    // 📅 DATE
                    Text(session.date, format: .dateTime.day().month().year())
                        .font(Theme.smallText)
                        .foregroundStyle(Theme.textSecondary.opacity(0.7))
                        .padding(.top, 20)

                    // 🎨 IMAGE
                    if let data = session.imageData,
                       let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 240)
                            .cornerRadius(16)
                            .shadow(radius: 6)
                            .padding(.horizontal, 20)
                    }

                    // 🧠 CONTENT
                    VStack(spacing: 20) {

                        if session.type == "journal" {
                            journalView

                        } else if session.type == "oracle" {
                            oracleView

                        } else if session.type == "creative" {
                            creativeView

                        } else {
                            releaseView
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white.opacity(0.12))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Theme.goldSoft.opacity(0.2), lineWidth: 1)
                    )
                    .padding(.horizontal, 20)

                    Spacer(minLength: 40)
                }
            }
        }
        .navigationTitle("Your Journey")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - JOURNAL VIEW

    var journalView: some View {
        VStack(spacing: 12) {
            Text("Your Reflection")
                .font(.headline)
                .foregroundStyle(Theme.textSecondary)

            if let reflection = session.reflection {
                Text(reflection)
                    .font(Theme.bodyText)
                    .foregroundStyle(Theme.textPrimary)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    // MARK: - ORACLE VIEW

    var oracleView: some View {
        VStack(spacing: 12) {
            Text("Your Oracle Reading")
                .font(.headline)
                .foregroundStyle(Theme.textSecondary)

            if let reflection = session.reflection {

                // Split oracle cards from personal reflection
                let parts = reflection.components(separatedBy: "\n\n📝 My reflection:\n")
                let cardContent = parts[0]
                let personalReflection = parts.count > 1 ? parts[1] : nil

                // Oracle cards
                VStack(spacing: 10) {
                    ForEach(cardContent.components(separatedBy: "\n\n"), id: \.self) { line in
                        if !line.trimmingCharacters(in: .whitespaces).isEmpty {
                            Text(line)
                                .font(Theme.bodyText)
                                .foregroundStyle(Theme.textPrimary)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white.opacity(0.15))
                                )
                        }
                    }
                }

                // Personal reflection if present
                if let personal = personalReflection, !personal.isEmpty {
                    Divider().padding(.vertical, 8)

                    Text("My Reflection")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(Theme.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(personal)
                        .font(Theme.bodyText)
                        .foregroundStyle(Theme.textPrimary)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }

    // MARK: - CREATIVE VIEW

    var creativeView: some View {
        VStack(spacing: 12) {
            Text("Creative Expression")
                .font(.headline)
                .foregroundStyle(Theme.textSecondary)

            if let reflection = session.reflection {
                // Split creative note from creative reflection
                let parts = reflection.components(separatedBy: "\n\n🎨 Creative reflection:\n")
                let mainNote = parts[0]
                let creativeNote = parts.count > 1 ? parts[1] : nil

                if !mainNote.isEmpty {
                    Text(mainNote)
                        .font(Theme.bodyText)
                        .foregroundStyle(Theme.textPrimary)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                if let note = creativeNote, !note.isEmpty {
                    Divider().padding(.vertical, 4)
                    Text("Doodle Reflection")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(Theme.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(note)
                        .font(Theme.bodyText)
                        .foregroundStyle(Theme.textPrimary)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }

    // MARK: - RELEASE VIEW

    var releaseView: some View {
        VStack(spacing: 12) {

            Text("You Released")
                .font(.headline)
                .foregroundStyle(Theme.textSecondary)

            Text(session.emotion)
                .font(Theme.sectionTitle)
                .foregroundStyle(Theme.textPrimary)
                .multilineTextAlignment(.center)

            Divider().padding(.vertical, 4)

            Text("And stepped into")
                .font(.headline)
                .foregroundStyle(Theme.textSecondary)

            Text(session.replacement)
                .font(Theme.sectionTitle)
                .foregroundStyle(Theme.textPrimary)
                .multilineTextAlignment(.center)

            if !session.meaning.isEmpty {
                Text(session.meaning)
                    .font(Theme.bodyText)
                    .foregroundStyle(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }

            // Journal reflection if present
            if let reflection = session.reflection {
                let parts = reflection.components(separatedBy: "\n\n🎨 Creative reflection:\n")
                let journalNote = parts[0]
                let creativeNote = parts.count > 1 ? parts[1] : nil

                if !journalNote.isEmpty {
                    Divider().padding(.vertical, 4)
                    Text("Your Reflection")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(Theme.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(journalNote)
                        .font(Theme.bodyText)
                        .foregroundStyle(Theme.textPrimary)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                if let note = creativeNote, !note.isEmpty {
                    Divider().padding(.vertical, 4)
                    Text("Doodle Reflection")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(Theme.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(note)
                        .font(Theme.bodyText)
                        .foregroundStyle(Theme.textPrimary)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}
