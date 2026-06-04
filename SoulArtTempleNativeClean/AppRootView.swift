import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var selectedTab: Int = 0
    @Published var returnToHome: Bool = false
}



struct AppRootView: View {

    @StateObject var discoveryStore = DiscoveryStore()
    @EnvironmentObject var appState: AppState

    var body: some View {
        TabView(selection: $appState.selectedTab) {
            NavigationStack {
                TempleEntryView()
            }

            .tabItem {
                Label("Home", systemImage: "house")
            }
            .tag(0)


            NavigationStack {
                DecodersHomeView()
            }
            .tabItem {
                Label("Decoders", systemImage: "square.grid.2x2")
            }
            .tag(1)

            NavigationStack {
                DoodleLoungeHomeView()
            }
            .tabItem {
                Label("Doodle", systemImage: "paintbrush.pointed")
            }
            .tag(2)

            NavigationStack {
                JournalView(
                    emotion: nil,
                    replacementWord: "",
                    affirmation: ""
                )
            }
            .tabItem {
                Label("Journal", systemImage: "book")
            }
            .tag(3)

            NavigationStack {
                MembersAreaView()
            }
            .tabItem {
                Label("Members", systemImage: "person.crop.circle")
            }
            .tag(4)
        }
        .environmentObject(discoveryStore)
        .environmentObject(appState)
    }
}
