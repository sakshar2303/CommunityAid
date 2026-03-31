import SwiftUI
import SwiftData

struct RequestListView: View {
    @Query(sort: \HelpRequest.timestamp, order: .reverse) var requests: [HelpRequest]
    @State private var selectedRequest: HelpRequest?

    var body: some View {
        NavigationStack {
            Group {
                if requests.isEmpty {
                    VStack(spacing: 15) {
                        Image(systemName: "hand.thumbsup.fill").font(.system(size: 60)).foregroundColor(.gray.opacity(0.5))
                        Text("All caught up!").font(.headline)
                        Text("No active requests in this area.").font(.subheadline).foregroundColor(.secondary)
                    }
                } else {
                    List(requests) { request in
                        HStack(spacing: 15) {
                            ZStack {
                                Circle().fill(request.isUrgent ? .red.opacity(0.1) : .blue.opacity(0.1)).frame(width: 45, height: 45)
                                Image(systemName: iconFor(request.category)).foregroundColor(request.isUrgent ? .red : .blue)
                            }
                            
                            VStack(alignment: .leading) {
                                Text(request.title).font(.headline)
                                Text(request.category).font(.subheadline).foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            if request.isUrgent {
                                Text("URGENT").font(.caption2).bold().padding(5).background(.red).foregroundColor(.white).cornerRadius(5)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture { selectedRequest = request }
                    }
                }
            }
            .navigationTitle("Help Feed")
            .sheet(item: $selectedRequest) { request in
                DetailView(request: request).presentationDetents([.medium])
            }
        }
    }
    
    func iconFor(_ category: String) -> String {
        switch category {
            case "Car": return "car"
            case "Tools": return "hammer"
            case "Food": return "fork.knife"
            default: return "figure.wave"
        }
    }
}
