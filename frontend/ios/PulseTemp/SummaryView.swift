import SwiftUI

struct SummaryView: View {
    @AppStorage("temperatureUnit") private var temperatureUnit: String = "°C"
    @AppStorage("distanceUnit") private var distanceUnit: String = "km"

    // Simulated metric values (You’ll replace these with real data later)
    let heartRate = 75
    let coreTempC = 37.2
    let steps = 8500
    let calories = 410
    let distanceKm = 4.5

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {

                    // Heart Rate Card
                    NavigationLink(destination: HeartRateDetailView()) {
                        HealthMetricCard(
                            title: "Heart Rate",
                            value: "\(heartRate) BPM",
                            icon: "heart.fill",
                            color: .red
                        )
                    }

                    // Core Temperature Card
                    NavigationLink(destination: CoreTempDetailView()) {
                        HealthMetricCard(
                            title: "Core Temperature",
                            value: formattedTemperature(coreTempC),
                            icon: "thermometer",
                            color: .orange
                        )
                    }

                    // Activity Summary Card
                    NavigationLink(destination: ActivityDetailView()) {
                        HealthMetricCard(
                            title: "Activity",
                            value: "\(steps.formatted()) steps | \(calories) kcal | \(formattedDistance(distanceKm))",
                            icon: "flame.fill",
                            color: .green
                        )
                    }

                    // Calories Burned Card
                    NavigationLink(destination: CaloriesDetailView()) {
                        HealthMetricCard(
                            title: "Calories Burned",
                            value: "\(calories) kcal",
                            icon: "bolt.fill",
                            color: .purple
                        )
                    }

                    // Distance Covered Card
                    NavigationLink(destination: DistanceDetailView()) {
                        HealthMetricCard(
                            title: "Distance Covered",
                            value: formattedDistance(distanceKm),
                            icon: "map.fill",
                            color: .blue
                        )
                    }

                }
                .padding()
            }
            .navigationTitle("Summary")
        }
    }

    // Convert temperature based on unit
    func formattedTemperature(_ celsius: Double) -> String {
        if temperatureUnit == "°F" {
            let fahrenheit = celsius * 9 / 5 + 32
            return String(format: "%.1f°F", fahrenheit)
        } else {
            return String(format: "%.1f°C", celsius)
        }
    }

    // Convert distance based on unit
    func formattedDistance(_ km: Double) -> String {
        if distanceUnit == "miles" {
            let miles = km * 0.621371
            return String(format: "%.2f miles", miles)
        } else {
            return String(format: "%.2f km", km)
        }
    }
}

