import SwiftUI

struct CategoryCheckView: View {
    
    let category: String
    
    @State private var navigateToNextStep = false
    @State private var showHowToTest = false
    @State private var showGuidedCheck = false
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var discoveryStore: DiscoveryStore
    
    var body: some View {
        
        ZStack {
            
            Theme.templeBackground
                .ignoresSafeArea()
            
            VStack(spacing: 28) {
                
                Spacer(minLength: 40)
                
                // 🌿 TITLE
                Text("Category Identified")
                    .font(Theme.sectionTitle)
                    .foregroundStyle(Theme.textPrimary)
                
                Text("Your body has highlighted an area for awareness.")
                    .font(Theme.smallText)
                    .foregroundStyle(Theme.textSecondary.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                // 🌿 CATEGORY SELECTION (simple)
                Text(category)
                    .font(.title2.bold())
                    .foregroundStyle(Theme.textPrimary)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Theme.templeParchment)
                    )
                    .padding(.horizontal, 30)
                
                // 🌿 EXPLANATION
                Text(explanationText)
                    .font(Theme.bodyText)
                    .foregroundStyle(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .lineSpacing(4)
                
                // 🌿 REFINED GUIDANCE (UPDATED)
                Text("""
            Notice what feels open, neutral, or slightly easier.

            There is no need to think.
            Your first response is enough.
            """)
                .font(Theme.smallText)
                .foregroundStyle(Theme.textSecondary.opacity(0.6))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                
                // 🧭 GUIDED CHECK BUTTON
                Button {
                    Haptics.soft()
                    showGuidedCheck = true
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "sparkles")
                        Text("Try Guided Check")
                    }
                    .font(Theme.smallText)
                    .foregroundStyle(Theme.textPrimary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Theme.templeParchment)
                    .cornerRadius(12)
                }
                .padding(.top, 6)
                
                Spacer()
                
                // 🔘 ACTION
                Button {
                    Haptics.medium()
                    saveCategoryOnly()
                    navigateToNextStep = true
           
                } label: {
                    Text("Continue to release")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.brandBlue)
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 30)
                
                Spacer(minLength: 40)
            }
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $navigateToNextStep) {
            EmotionDecoderView(
                category: category,
                count: 12,
                hasLayers: false
            )
            .environmentObject(discoveryStore)
        }
      
        .sheet(isPresented: $showHowToTest) {
            HowToTestView()
        }

        .sheet(isPresented: $showGuidedCheck) {
            GuidedCheckView(category: category)
        }
    }
    func saveCategoryOnly() {
        UserDefaults.standard.set(true, forKey: "hasCompletedDiscovery")
        UserDefaults.standard.set(category, forKey: "discoveryCategory")
    }
    func saveToJournal() {
        
        let newEntry: [String: String] = [
            "type": "discovery",
            "category": category,
            "date": Date().formatted(date: .abbreviated, time: .shortened)
        ]
        
        var saved = UserDefaults.standard.array(forKey: "journalEntries") as? [[String: String]] ?? []
        
        saved.append(newEntry)
        
        UserDefaults.standard.set(saved, forKey: "journalEntries")
    }
        
        // MARK: - Explanation Logic
        
        var explanationText: String {
            switch category {

            case "Common":
                return "Everyday stored emotional patterns held within the body, often linked to recent or repeated experiences."

            case "Ancestral":
                return "Inherited emotional imprints passed through family lines, carried at a subconscious level."

            case "Heart Shadows":
                return "Protective emotional layers built around the heart, often formed through hurt, rejection, or emotional defence."

            case "Etheric":
                return "Subtle energetic imprints stored beyond the physical body, often linked to past emotional experiences."

            case "Aura / Field":
                return "Emotional imprints held within your surrounding energy field, influenced by environments and interactions."

            case "DNA":
                return "This reflects deeper emotional patterns held within your system, often connected to generational memory and inherited experience."

            case "Third Trimester":
                return "Emotional imprints formed before birth, particularly during late-stage development in the womb."

            case "Twin (Dual)":
                return "Emotional patterns connected to another person, often through strong energetic or relational bonds."

            case "Deeply Hidden":
                return "Emotions stored deeply within the system, often not immediately accessible without guided awareness."

            case "Stealth":
                return "Subtle, concealed emotional patterns that may influence behaviour without conscious recognition."

            case "Body Coded":
                return "Emotions stored in specific areas of the body, often presenting as tension, discomfort, or sensitivity."

            case "Unidentified":
                return "A category your body has selected without conscious recognition. Trust that this is where your attention is needed."

            default:
                return "This category contains stored emotional patterns ready to be identified."
            }
        }
    }

