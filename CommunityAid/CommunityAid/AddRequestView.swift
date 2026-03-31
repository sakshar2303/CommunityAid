import SwiftUI
import SwiftData
import PhotosUI

struct AddRequestView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var details = ""
    @State private var category = "General"
    @State private var isUrgent = false
    @State private var locationManager = LocationManager()
    
    // Photo Selection States
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImageData: Data?
    
    let categories = ["General", "Tools", "Car", "Moving", "Food"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("What's happening?") {
                    TextField("Title", text: $title)
                    TextField("Tell us more...", text: $details, axis: .vertical).lineLimit(3)
                }
                
                Section("Visuals") {
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        HStack {
                            Image(systemName: "camera.fill")
                            Text(selectedImageData == nil ? "Add a Photo" : "Photo Added!")
                        }
                    }
                    if let data = selectedImageData, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .cornerRadius(10)
                    }
                }
                
                Section("Settings") {
                    Picker("Category", selection: $category) {
                        ForEach(categories, id: \.self) { Text($0) }
                    }
                    Toggle("Mark as Urgent", isOn: $isUrgent).tint(.red)
                }
            }
            .navigationTitle("New Request")
            .onChange(of: selectedItem) { loadPhoto() }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Post") { saveRequest() }.disabled(title.isEmpty)
                }
            }
            .onAppear { locationManager.requestLocation() }
        }
    }
    
    func loadPhoto() {
        Task {
            if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                selectedImageData = data
            }
        }
    }
    
    private func saveRequest() {
        let lat = locationManager.userLocation?.coordinate.latitude ?? 37.334
        let lon = locationManager.userLocation?.coordinate.longitude ?? -122.009
        let newReq = HelpRequest(title: title, details: details, latitude: lat, longitude: lon, category: category, isUrgent: isUrgent, imageData: selectedImageData)
        modelContext.insert(newReq)
        dismiss()
    }
}
