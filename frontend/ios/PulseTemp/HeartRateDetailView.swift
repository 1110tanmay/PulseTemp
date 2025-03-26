import SwiftUI
import Charts // Make sure to use Swift Charts for graphing

struct HeartRateDetailView: View {
    // Mock Data for Heart Rate Graph
    let heartRateData: [(time: String, bpm: Int)] = [
        ("10:00 PM", 68),
        ("10:10 PM", 70),
        ("10:20 PM", 72),
        ("10:30 PM", 75),
        ("10:40 PM", 76),
        ("10:45 PM", 79)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Heart Rate Range Display
                VStack {
                    Text("RANGE")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("68 - 79 BPM")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                
                // Heart Rate Graph
                Chart {
                    ForEach(heartRateData, id: \.time) { dataPoint in
                        LineMark(
                            x: .value("Time", dataPoint.time),
                            y: .value("BPM", dataPoint.bpm)
                        )
                        .foregroundStyle(dataPoint.bpm == 79 ? Color.red : Color.blue)
                    }
                }
                .frame(height: 200)
                .padding()

                // Latest Heart Rate Highlight
                VStack {
                    Text("Latest: 10:46 PM")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    Text("76 BPM")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .cornerRadius(12)

                // Show More Data Button
                Button(action: {
                    print("Show More Heart Rate Data tapped")
                }) {
                    Text("Show More Heart Rate Data")
                        .foregroundColor(.blue)
                        .fontWeight(.semibold)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Heart Rate Details")
    }
}

// Preview
struct HeartRateDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HeartRateDetailView()
    }
}

