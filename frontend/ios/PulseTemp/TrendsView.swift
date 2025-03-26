import SwiftUI
import Charts

struct TrendsView: View {
    @AppStorage("temperatureUnit") private var temperatureUnit: String = "°C"
    @AppStorage("distanceUnit") private var distanceUnit: String = "km"
    
    @State private var selectedTimeframe: String = "Week"
    let timeframes = ["Day", "Week", "Month", "Year"]

    // MARK: - Mock Data
    let heartRateTrendData: [(date: String, bpm: Int)] = [
        ("Mon", 72), ("Tue", 75), ("Wed", 74),
        ("Thu", 73), ("Fri", 70), ("Sat", 76), ("Sun", 78)
    ]
    
    let coreTempTrendData: [(date: String, temp: Double)] = [
        ("Mon", 36.7), ("Tue", 36.8), ("Wed", 37.0),
        ("Thu", 36.9), ("Fri", 36.6), ("Sat", 37.1), ("Sun", 37.2)
    ]
    
    let stepsTrendData: [(date: String, steps: Int)] = [
        ("Mon", 4500), ("Tue", 5000), ("Wed", 5500),
        ("Thu", 6000), ("Fri", 6200), ("Sat", 7000), ("Sun", 7500)
    ]

    let caloriesTrendData: [(date: String, calories: Int)] = [
        ("Mon", 300), ("Tue", 320), ("Wed", 350),
        ("Thu", 370), ("Fri", 400), ("Sat", 420), ("Sun", 450)
    ]
    
    let distanceTrendData: [(date: String, distance: Double)] = [
        ("Mon", 2.1), ("Tue", 2.3), ("Wed", 2.5),
        ("Thu", 2.7), ("Fri", 3.0), ("Sat", 3.4), ("Sun", 3.8)
    ]

    @State private var insights: [String] = []

    // MARK: - Computed Properties
    var convertedTempData: [(String, Double)] {
        coreTempTrendData.map { ($0.date, temperatureUnit == "°F" ? celsiusToFahrenheit($0.temp) : $0.temp) }
    }

    var convertedDistanceData: [(String, Double)] {
        distanceTrendData.map { ($0.date, distanceUnit == "miles" ? kmToMiles($0.distance) : $0.distance) }
    }

    // MARK: - Body
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Timeframe Picker
                    Picker("Timeframe", selection: $selectedTimeframe) {
                        ForEach(timeframes, id: \.self) { timeframe in
                            Text(timeframe).tag(timeframe)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    .onChange(of: selectedTimeframe) { _ in updateInsights() }

                    // Charts
                    TrendChart(
                        title: "Core Temperature Trends (\(temperatureUnit))",
                        color: .orange,
                        data: convertedTempData
                    )

                    TrendChart(
                        title: "Heart Rate Trends (\(selectedTimeframe))",
                        color: .red,
                        data: heartRateTrendData.map { ($0.date, Double($0.bpm)) }
                    )

                    TrendChart(
                        title: "Steps Trends (\(selectedTimeframe))",
                        color: .blue,
                        data: stepsTrendData.map { ($0.date, Double($0.steps)) }
                    )

                    TrendChart(
                        title: "Calories Burned Trends (\(selectedTimeframe))",
                        color: .purple,
                        data: caloriesTrendData.map { ($0.date, Double($0.calories)) }
                    )

                    TrendChart(
                        title: "Distance Covered Trends (\(distanceUnit))",
                        color: .green,
                        data: convertedDistanceData
                    )

                    // Health Insights
                    VStack(alignment: .leading, spacing: 15) {
                        Text("🧠 Health Insights")
                            .font(.title2)
                            .fontWeight(.bold)

                        ForEach(insights, id: \.self) { insight in
                            InsightCard(icon: "lightbulb.fill", color: .blue, text: insight)
                        }
                    }
                    .padding()

                    Spacer()
                }
                .padding()
                .onAppear { updateInsights() }
            }
            .navigationTitle("Trends")
        }
    }

    // MARK: - Update Insights
    func updateInsights() {
        insights.removeAll()
        
        // Core Temp Insight
        if let first = coreTempTrendData.first?.temp,
           let last = coreTempTrendData.last?.temp {
            let f = temperatureUnit == "°F" ? celsiusToFahrenheit(first) : first
            let l = temperatureUnit == "°F" ? celsiusToFahrenheit(last) : last
            let delta = l - f
            if delta < 0 {
                insights.append("Your core temperature dropped by \(abs(delta).formatted(.number.precision(.fractionLength(1))))\(temperatureUnit) this \(selectedTimeframe).")
            } else {
                insights.append("Your core temperature increased by \(delta.formatted(.number.precision(.fractionLength(1))))\(temperatureUnit) this \(selectedTimeframe).")
            }
        }

        // Heart Rate Insight
        if let first = heartRateTrendData.first?.bpm,
           let last = heartRateTrendData.last?.bpm {
            let change = last - first
            if change < 0 {
                insights.append("Your heart rate dropped by \(abs(change)) BPM this \(selectedTimeframe).")
            } else {
                insights.append("Your heart rate increased by \(change) BPM this \(selectedTimeframe).")
            }
        }

        // Steps Insight
        if let first = stepsTrendData.first?.steps,
           let last = stepsTrendData.last?.steps {
            let change = last - first
            if change > 500 {
                insights.append("Great job! You walked \(change) more steps this \(selectedTimeframe).")
            } else {
                insights.append("Try increasing your daily steps for better health.")
            }
        }

        // Calories Insight
        if let first = caloriesTrendData.first?.calories,
           let last = caloriesTrendData.last?.calories {
            let change = last - first
            if change > 50 {
                insights.append("You burned \(change) more calories this \(selectedTimeframe). Keep it up!")
            } else {
                insights.append("Consider increasing your activity to burn more calories.")
            }
        }

        // Distance Insight
        if let first = distanceTrendData.first?.distance,
           let last = distanceTrendData.last?.distance {
            let f = distanceUnit == "miles" ? kmToMiles(first) : first
            let l = distanceUnit == "miles" ? kmToMiles(last) : last
            let delta = l - f
            if delta > 0.5 {
                insights.append("You covered \(delta.formatted(.number.precision(.fractionLength(2)))) \(distanceUnit) more this \(selectedTimeframe).")
            } else {
                insights.append("Try to increase your distance for better endurance.")
            }
        }
    }

    // MARK: - Helpers
    func celsiusToFahrenheit(_ c: Double) -> Double {
        (c * 9/5) + 32
    }

    func kmToMiles(_ km: Double) -> Double {
        km * 0.621371
    }
}

// MARK: - Reusable TrendChart View
struct TrendChart: View {
    let title: String
    let color: Color
    let data: [(String, Double)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .padding(.leading)

            Chart {
                ForEach(data, id: \.0) { point in
                    LineMark(
                        x: .value("Date", point.0),
                        y: .value("Value", point.1)
                    )
                    .foregroundStyle(color)
                }
            }
            .frame(height: 200)
            .padding(.horizontal)
        }
    }
}

