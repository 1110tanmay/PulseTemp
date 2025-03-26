import SwiftUI
import Charts

struct CoreTempDetailView: View {
    @AppStorage("temperatureUnit") private var temperatureUnit: String = "°C"
    
    // Raw temperature data in Celsius
    let tempData: [(time: String, temp: Double)] = [
        ("10:00 PM", 36.5),
        ("10:10 PM", 36.7),
        ("10:20 PM", 37.0),
        ("10:30 PM", 37.2),
        ("10:40 PM", 37.6),
        ("10:45 PM", 38.2)
    ]

    // MARK: - Computed Properties
    var convertedTempData: [(time: String, temp: Double)] {
        tempData.map { (time, temp) in
            (time, temperatureUnit == "°F" ? celsiusToFahrenheit(temp) : temp)
        }
    }

    var tempRange: String {
        guard let min = convertedTempData.map({ $0.temp }).min(),
              let max = convertedTempData.map({ $0.temp }).max() else {
            return "-"
        }
        return String(format: "%.1f - %.1f%@", min, max, temperatureUnit)
    }

    var latestTemp: String {
        guard let latest = convertedTempData.last else { return "-" }
        return String(format: "%.1f%@", latest.temp, temperatureUnit)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Range display
                VStack {
                    Text("RANGE")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(tempRange)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }

                // Temperature graph
                Chart {
                    ForEach(convertedTempData, id: \.time) { dataPoint in
                        LineMark(
                            x: .value("Time", dataPoint.time),
                            y: .value("Temperature", dataPoint.temp)
                        )
                        .foregroundStyle(dataPoint.temp == convertedTempData.last?.temp ? Color.orange : Color.blue)
                    }
                }
                .frame(height: 200)
                .padding()

                // Latest temperature
                VStack {
                    Text("Latest: 10:46 PM")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    Text(latestTemp)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.orange)
                .cornerRadius(12)

                // Show more button
                Button(action: {
                    print("Show More Temperature Data tapped")
                }) {
                    Text("Show More Temperature Data")
                        .foregroundColor(.blue)
                        .fontWeight(.semibold)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Core Temperature")
    }

    // MARK: - Conversion
    func celsiusToFahrenheit(_ celsius: Double) -> Double {
        (celsius * 9/5) + 32
    }
}

