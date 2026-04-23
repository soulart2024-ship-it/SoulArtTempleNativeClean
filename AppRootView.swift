import SwiftUI

struct AppRootView: View {
    
    
    @StateObject var discoveryStore = DiscoveryStore()
    
    var body: some View {
        TabView {

            NavigationStack {
                TempleEntryView()
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }

            NavigationStack {
                DecodersHomeView()
            }
            .tabItem {
                Label("Decoders", systemImage: "square.grid.2x2")
            }

            NavigationStack {
                DoodleLoungeHomeView()
            }
            .tabItem {
                Label("Doodle", systemImage: "paintbrush.pointed")
            }
            
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

            NavigationStack {
                MembersAreaView()
            }
            .tabItem {
                Label("Members", systemImage: "person.crop.circle")
            }
        }
        .environmentObject(discoveryStore)
    }
}
