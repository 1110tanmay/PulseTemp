import Foundation

struct DistancePoint: Identifiable {
    let id = UUID()
    let timestamp: String
    var distance: Double  
}

struct StepPoint: Identifiable {
    let id = UUID()
    let timestamp: String
    let steps: Int
}

struct CaloriePoint: Identifiable {
    let id = UUID()
    let timestamp: String
    let calories: Double
}

