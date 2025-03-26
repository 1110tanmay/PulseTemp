import SwiftUI
import Charts

struct DistanceDetailView: View {
    @AppStorage("distanceUnit") private var distanceUnit: String = "km"

    // Distance data in kilometers
    let distanceTrendData: [(time: String, distance: Double)] = [
        ("10 AM", 0.5), ("11 AM", 1.2), ("12 PM", 2.1),
        ("1 PM", 3.0), ("2 PM", 3.8), ("3 PM", 4.5)
    ]
    
    var convertedDistanceData: [(time: String, distance: Double)] {
        distanceTrendData.map { (time, dist) in
            (time, distanceUnit == "miles" ? kmToMiles(dist) : dist)
        }
    }

    var latestDistanceText: String {
        guard let latest = convertedDistanceData.last else { return "-" }
        return String(format: "%.2f %@", latest.distance, distanceUnit)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Title
                Text("Distance Covered Details")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                // Distance Trend Chart
                Chart {
                    ForEach(convertedDistanceData, id: \.time) { dataPoint in
                        LineMark(
                            x: .value("Time", dataPoint.time),
                            y: .value("Distance (\(distanceUnit))", dataPoint.distance)
                        )
                        .foregroundStyle(Color.blue)
                    }
                }
                .frame(height: 200)
                .padding()

                // Latest Distance Highlight
                VStack {
                    Text("Latest: 3:00 PM")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    Text(latestDistanceText)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)

                // 🧠 Health Insights (static for now)
                VStack(alignment: .leading, spacing: 15) {
                    Text("🧠 Health Insights")
                        .font(.title2)
                        .fontWeight(.bold)

                    InsightCard(icon: "map.fill", color: .blue, text: "You covered 20% more distance than last week!")
                    InsightCard(icon: "figure.walk", color: .green, text: "Your longest walk was at 1 PM with 3 km covered.")
                }
                .padding()

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Distance Covered")
    }

    // MARK: - Distance Conversion
    func kmToMiles(_ km: Double) -> Double {
        km * 0.621371
    }
}

