import SwiftUI
import Charts

struct SummaryView: View {
    @AppStorage("temperatureUnit") private var temperatureUnit: String = "°C"
    @AppStorage("distanceUnit") private var distanceUnit: String = "km"
    @AppStorage("firstName") private var firstName: String = "Tanmay" // 👈 Pulled from user profile

    // Simulated metric values (replace with real data later)
    let heartRate = 75
    let coreTempC = 37.2
    let steps = 8500
    let calories = 410
    let distanceKm = 4.5

    // Mock temperature trend
    let mockTempTrend: [TemperatureData] = [
        TemperatureData(time: "8AM", temperature: 36.8),
        TemperatureData(time: "10AM", temperature: 37.1),
        TemperatureData(time: "12PM", temperature: 37.2),
        TemperatureData(time: "2PM", temperature: 37.3),
        TemperatureData(time: "4PM", temperature: 37.0)
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // 👋 Dynamic Greeting
                    Text("\(timeBasedGreeting()), \(firstName) 👋")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.horizontal)

                    // 🌡️ Core Temperature Card with Chart
                    NavigationLink(destination: CoreTempDetailView()) {
                        HealthMetricCard(
                            title: "Core Temperature",
                            value: formattedTemperature(coreTempC),
                            icon: "thermometer",
                            color: .orange,
                            isLarge: true,
                            trailingView: AnyView(
                                Chart(mockTempTrend) {
                                    AreaMark(
                                        x: .value("Time", $0.time),
                                        y: .value("Temp", $0.temperature)
                                    )
                                    .foregroundStyle(
                                        .linearGradient(
                                            colors: [.orange.opacity(0.3), .clear],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )

                                    LineMark(
                                        x: .value("Time", $0.time),
                                        y: .value("Temp", $0.temperature)
                                    )
                                    .interpolationMethod(.monotone)
                                    .foregroundStyle(.orange)
                                }
                                .chartXAxis(.hidden)
                                .chartYAxis(.hidden)
                                .frame(height: 100)
                            )
                        )
                    }

                    // ❤️ Heart Rate Card
                    NavigationLink(destination: HeartRateDetailView()) {
                        HealthMetricCard(
                            title: "Heart Rate",
                            value: "\(heartRate) BPM",
                            icon: "heart.fill",
                            color: .red
                        )
                    }

                    // 🔥 Activity Summary
                    NavigationLink(destination: ActivityDetailView()) {
                        HealthMetricCard(
                            title: "Activity",
                            value: "\(steps.formatted()) steps | \(calories) kcal | \(formattedDistance(distanceKm))",
                            icon: "flame.fill",
                            color: .green
                        )
                    }

                    // ⚡ Calories
                    NavigationLink(destination: CaloriesDetailView()) {
                        HealthMetricCard(
                            title: "Calories Burned",
                            value: "\(calories) kcal",
                            icon: "bolt.fill",
                            color: .purple
                        )
                    }

                    // 🗺️ Distance
                    NavigationLink(destination: DistanceDetailView()) {
                        HealthMetricCard(
                            title: "Distance Covered",
                            value: formattedDistance(distanceKm),
                            icon: "map.fill",
                            color: .blue
                        )
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Summary")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                // 👤 Profile image in top-right corner
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image("profile_pic")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 36, height: 36)
                        .clipShape(Circle())
                }
            }
        }
    }

    // MARK: - Helpers

    func formattedTemperature(_ celsius: Double) -> String {
        if temperatureUnit == "°F" {
            let fahrenheit = celsius * 9 / 5 + 32
            return String(format: "%.1f°F", fahrenheit)
        } else {
            return String(format: "%.1f°C", celsius)
        }
    }

    func formattedDistance(_ km: Double) -> String {
        if distanceUnit == "miles" {
            let miles = km * 0.621371
            return String(format: "%.2f miles", miles)
        } else {
            return String(format: "%.2f km", km)
        }
    }

    func timeBasedGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good Morning"
        case 12..<17: return "Good Afternoon"
        case 17..<22: return "Good Evening"
        default: return "Hello"
        }
    }
}

// MARK: - Temperature Trend Model
struct TemperatureData: Identifiable {
    let id = UUID()
    let time: String
    let temperature: Double
}

