import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem { Label("Map", systemImage: "map.fill") }
            
            RequestListView()
                .tabItem { Label("Feed", systemImage: "list.bullet") }
            
            // Profile Placeholder
            NavigationStack {
                VStack {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 80)).foregroundColor(.blue)
                    Text("Your Profile").font(.title3).bold()
                    Text("Helping your neighborhood since 2026").font(.subheadline).foregroundColor(.secondary)
                }
                .navigationTitle("Account")
            }
            .tabItem { Label("Profile", systemImage: "person.circle") }
        }
    }
}
