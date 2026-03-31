import Foundation
import SwiftData
import MapKit

@Model
class HelpRequest {
    var title: String
    var details: String
    var latitude: Double
    var longitude: Double
    var category: String
    var timestamp: Date
    var isUrgent: Bool
    @Attribute(.externalStorage) var imageData: Data? // NEW: Stores the photo
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(title: String, details: String, latitude: Double, longitude: Double, category: String = "General", isUrgent: Bool = false, imageData: Data? = nil) {
        self.title = title
        self.details = details
        self.latitude = latitude
        self.longitude = longitude
        self.category = category
        self.timestamp = Date()
        self.isUrgent = isUrgent
        self.imageData = imageData
    }
}
