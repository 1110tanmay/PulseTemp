import SwiftUI
import Charts

struct ActivityDetailView: View {
    @AppStorage("distanceUnit") private var distanceUnit: String = "km"
    
    // Mock Data
    let stepsData: [(time: String, steps: Int)] = [
        ("10:00 AM", 1000), ("11:00 AM", 2300), ("12:00 PM", 4500),
        ("1:00 PM", 6000), ("2:00 PM", 7200), ("3:00 PM", 8500)
    ]
    
    let caloriesData: [(time: String, calories: Int)] = [
        ("10:00 AM", 50), ("11:00 AM", 120), ("12:00 PM", 200),
        ("1:00 PM", 270), ("2:00 PM", 350), ("3:00 PM", 410)
    ]
    
    let distanceData: [(time: String, distance: Double)] = [
        ("10:00 AM", 0.5), ("11:00 AM", 1.2), ("12:00 PM", 2.1),
        ("1:00 PM", 3.0), ("2:00 PM", 3.8), ("3:00 PM", 4.5)
    ]

    var convertedDistanceData: [(time: String, distance: Double)] {
        distanceData.map { (time, dist) in
            (time, distanceUnit == "miles" ? kmToMiles(dist) : dist)
        }
    }

    var totalDistanceText: String {
        guard let latest = convertedDistanceData.last else { return "-" }
        return String(format: "%.2f %@", latest.distance, distanceUnit)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Steps Section
                VStack {
                    Text("Steps Walked")
                        .font(.headline)
                    Text("8,500 steps")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }

                Chart {
                    ForEach(stepsData, id: \.time) { dataPoint in
                        BarMark(
                            x: .value("Time", dataPoint.time),
                            y: .value("Steps", dataPoint.steps)
                        )
                        .foregroundStyle(Color.blue)
                    }
                }
                .frame(height: 200)
                .padding()

                // Calories Burned Section
                VStack {
                    Text("Calories Burned")
                        .font(.headline)
                    Text("410 kcal")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }

                Chart {
                    ForEach(caloriesData, id: \.time) { dataPoint in
                        BarMark(
                            x: .value("Time", dataPoint.time),
                            y: .value("Calories", dataPoint.calories)
                        )
                        .foregroundStyle(Color.red)
                    }
                }
                .frame(height: 200)
                .padding()

                // Distance Traveled Section
                VStack {
                    Text("Distance Traveled")
                        .font(.headline)
                    Text(totalDistanceText)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }

                Chart {
                    ForEach(convertedDistanceData, id: \.time) { dataPoint in
                        LineMark(
                            x: .value("Time", dataPoint.time),
                            y: .value("Distance (\(distanceUnit))", dataPoint.distance)
                        )
                        .foregroundStyle(Color.green)
                    }
                }
                .frame(height: 200)
                .padding()

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Activity Details")
    }

    // MARK: - Conversion
    func kmToMiles(_ km: Double) -> Double {
        km * 0.621371
    }
}

