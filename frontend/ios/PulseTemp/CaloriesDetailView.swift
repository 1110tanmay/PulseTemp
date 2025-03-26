import SwiftUI
import Charts

struct CaloriesDetailView: View {
    // Mock Data for Calories Burned Trends
    let caloriesTrendData: [(time: String, calories: Int)] = [
        ("10 AM", 100), ("11 AM", 120), ("12 PM", 150),
        ("1 PM", 180), ("2 PM", 210), ("3 PM", 250)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // Title
                Text("Calories Burned Details")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                // Calories Burned Trend Chart
                Chart {
                    ForEach(caloriesTrendData, id: \.time) { point in
                        LineMark(
                            x: .value("Time", point.time),
                            y: .value("Calories", point.calories)
                        )
                        .foregroundStyle(Color.purple)
                    }
                }
                .frame(height: 200)
                .padding()

                // Latest Highlight
                if let latest = caloriesTrendData.last {
                    VStack {
                        Text("Latest: \(latest.time)")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        Text("\(latest.calories) kcal")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .cornerRadius(12)
                }

                // Insights
                VStack(alignment: .leading, spacing: 15) {
                    Text("🧠 Health Insights")
                        .font(.title2)
                        .fontWeight(.bold)

                    InsightCard(icon: "flame.fill", color: .purple, text: "You burned 15% more calories than last week!")
                    InsightCard(icon: "figure.run", color: .orange, text: "Your most active hour was between 2 PM - 3 PM.")
                }
                .padding()

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Calories Burned")
    }
}

