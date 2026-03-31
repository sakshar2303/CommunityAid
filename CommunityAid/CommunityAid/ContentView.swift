import SwiftUI
import MapKit
import SwiftData

struct ContentView: View {
    @Query(sort: \HelpRequest.timestamp, order: .reverse) var allRequests: [HelpRequest]
    @State private var selectedCategory: String = "All"
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var selectedRequest: HelpRequest?
    @State private var showingAddSheet = false
    @State private var animatePulse = false
    
    let filterCategories = ["All", "General", "Tools", "Car", "Food", "Moving"]

    var filteredRequests: [HelpRequest] {
        selectedCategory == "All" ? allRequests : allRequests.filter { $0.category == selectedCategory }
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Map(position: $position, selection: $selectedRequest) {
                    ForEach(filteredRequests) { request in
                        Annotation(request.title, coordinate: request.coordinate) {
                            ZStack {
                                // Pulsing Background for Urgent
                                if request.isUrgent {
                                    Circle()
                                        .stroke(Color.red, lineWidth: 2)
                                        .frame(width: 45, height: 45)
                                        .scaleEffect(animatePulse ? 1.4 : 1.0)
                                        .opacity(animatePulse ? 0.0 : 0.8)
                                }
                                
                                // Main Icon
                                Circle()
                                    .fill(request.isUrgent ? .red : .blue)
                                    .frame(width: 35, height: 35)
                                    .shadow(radius: 3)
                                
                                Image(systemName: iconFor(request.category))
                                    .foregroundColor(.white)
                                    .font(.system(size: 14, weight: .bold))
                            }
                            .onAppear {
                                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: false)) {
                                    animatePulse = true
                                }
                            }
                        }
                        .tag(request)
                    }
                    UserAnnotation()
                }
                .mapControls { MapUserLocationButton(); MapPitchToggle() }
                
                // Horizontal Filter Chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(filterCategories, id: \.self) { cat in
                            Button { withAnimation(.spring) { selectedCategory = cat } } label: {
                                Text(cat).font(.subheadline).bold()
                                    .padding(.horizontal, 16).padding(.vertical, 8)
                                    .background(selectedCategory == cat ? Color.blue : Color(.systemBackground))
                                    .foregroundColor(selectedCategory == cat ? .white : .primary)
                                    .clipShape(Capsule()).shadow(radius: 2)
                            }
                        }
                    }
                    .padding()
                }
                
                // Floating Add Button
                VStack {
                    Spacer()
                    Button { showingAddSheet.toggle() } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 60))
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white, .blue)
                            .shadow(radius: 5)
                    }
                    .padding(.bottom, 25)
                }
            }
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingAddSheet) { AddRequestView() }
            .sheet(item: $selectedRequest) { request in
                DetailView(request: request).presentationDetents([.medium])
            }
        }
    }

    func iconFor(_ category: String) -> String {
        switch category {
            case "Car": return "car.fill"
            case "Tools": return "hammer.fill"
            case "Food": return "fork.knife"
            case "Moving": return "box.truck.fill"
            default: return "figure.wave"
        }
    }
}
