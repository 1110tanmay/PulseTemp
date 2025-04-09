import SwiftUI
import Charts

struct CaloriesDetailView: View {
    @EnvironmentObject var healthManager: HealthKitManager

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Title
                Text("Calories Burned Details")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                // Basic chart using latest value
                if let calories = healthManager.latestCalories {
                    Chart {
                        LineMark(
                            x: .value("Time", "Today"),
                            y: .value("Calories", calories)
                        )
                        .foregroundStyle(Color.purple)
                    }
                    .frame(height: 200)
                    .padding()
                } else {
                    Text("Loading calorie data...")
                        .foregroundColor(.gray)
                        .padding()
                }

                // Latest Highlight
                if let calories = healthManager.latestCalories {
                    VStack {
                        Text("Today")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        Text("\(Int(calories)) kcal")
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
        .onAppear {
            healthManager.fetchLatestCalories()
        }
    }
}

