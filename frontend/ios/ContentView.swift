import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("PulseTemp")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 40)

            VStack(spacing: 15) {
                HealthMetricView(title: "Core Temperature", value: "37.2°C")
                HealthMetricView(title: "Heart Rate", value: "75 BPM")
                HealthMetricView(title: "Steps Taken", value: "3,450")
                HealthMetricView(title: "Calories Burned", value: "220 kcal")
                HealthMetricView(title: "Workout Duration", value: "25 min")
            }
            .padding()
            
            Spacer()
        }
        .padding()
    }
}

// A reusable SwiftUI component for displaying health metrics
struct HealthMetricView: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(value)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.blue)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

