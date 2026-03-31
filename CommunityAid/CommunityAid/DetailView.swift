import SwiftUI
import MapKit
import SwiftData

struct DetailView: View {
    var request: HelpRequest
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // PHOTO HEADER
            if let data = request.imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 180)
                    .clipped()
            }
            
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Text(request.category).font(.caption).bold().padding(6).background(.blue.opacity(0.1)).cornerRadius(8)
                    if request.isUrgent { Text("URGENT").font(.caption).bold().padding(6).background(.red).foregroundColor(.white).cornerRadius(8) }
                    Spacer()
                    Button { dismiss() } label: { Image(systemName: "xmark.circle.fill").foregroundColor(.secondary).font(.title2) }
                }
                
                Text(request.title).font(.title2).bold()
                Text(request.details).font(.body).foregroundColor(.secondary)
                
                Spacer()
                
                HStack(spacing: 15) {
                    Button(action: openInMaps) {
                        Label("Navigate", systemImage: "map.fill").frame(maxWidth: .infinity).padding().background(.blue).foregroundColor(.white).cornerRadius(15)
                    }
                    Button(action: { modelContext.delete(request); dismiss() }) {
                        Image(systemName: "checkmark.seal.fill").padding().background(.green.opacity(0.1)).foregroundColor(.green).cornerRadius(15)
                    }
                }
            }
            .padding(25)
        }
    }
    
    func openInMaps() {
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: request.coordinate))
        mapItem.name = request.title
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}
