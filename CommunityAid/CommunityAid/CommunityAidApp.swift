import SwiftUI
import SwiftData

@main
struct CommunityAidApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .modelContainer(for: HelpRequest.self)
        }
    }
}
