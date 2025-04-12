import SwiftUI
import Charts

struct ActivityDetailView: View {
    @EnvironmentObject var healthKitManager: HealthKitManager
    @AppStorage("distanceUnit") private var distanceUnit: String = "km"
    @State private var timer: Timer?

    var convertedDistanceTrend: [DistancePoint] {
        healthKitManager.distanceTrendData.map { point in
            var updated = point
            updated.distance = distanceUnit == "miles" ? kmToMiles(point.distance) : point.distance
            return updated
        }
    }

    var totalDistanceText: String {
        guard let latest = convertedDistanceTrend.last else { return "-" }
        return String(format: "%.2f %@", latest.distance, distanceUnit)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // 🧍 Steps Walked
                VStack {
                    Text("Steps Walked")
                        .font(.headline)
                    Text("\(healthKitManager.latestSteps ?? 0) steps")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }

                Chart {
                    ForEach(healthKitManager.stepsTrendData) { point in
                        BarMark(
                            x: .value("Time", point.timestamp),
                            y: .value("Steps", point.steps)
                        )
                        .foregroundStyle(Color.blue)
                    }
                }
                .frame(height: 200)
                .padding()

                // 🔥 Calories Burned
                VStack {
                    Text("Calories Burned")
                        .font(.headline)
                    Text("\(Int(healthKitManager.latestCalories ?? 0)) kcal")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }

                Chart {
                    ForEach(healthKitManager.caloriesTrendData) { point in
                        BarMark(
                            x: .value("Time", point.timestamp),
                            y: .value("Calories", point.calories)
                        )
                        .foregroundStyle(Color.red)
                    }
                }
                .frame(height: 200)
                .padding()

                // 🏃‍♂️ Distance Traveled
                VStack {
                    Text("Distance Traveled")
                        .font(.headline)
                    Text(totalDistanceText)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }

                Chart {
                    ForEach(convertedDistanceTrend) { point in
                        LineMark(
                            x: .value("Time", point.timestamp),
                            y: .value("Distance (\(distanceUnit))", point.distance)
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
        .onAppear {
            startPolling()
        }
        .onDisappear {
            stopPolling()
        }
    }

    // MARK: - Conversion
    func kmToMiles(_ km: Double) -> Double {
        km * 0.621371
    }

    // MARK: - Timer-based Polling
    func startPolling() {
        healthKitManager.fetchLatestSteps()
        healthKitManager.fetchLatestCalories()
        healthKitManager.fetchLatestDistance()
        healthKitManager.fetchStepsTrend()
        healthKitManager.fetchCaloriesTrend()
        healthKitManager.fetchDistanceTrend()

        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { _ in
            healthKitManager.fetchLatestSteps()
            healthKitManager.fetchLatestCalories()
            healthKitManager.fetchLatestDistance()
            healthKitManager.fetchStepsTrend()
            healthKitManager.fetchCaloriesTrend()
            healthKitManager.fetchDistanceTrend()
        }
    }

    func stopPolling() {
        timer?.invalidate()
        timer = nil
    }
}

