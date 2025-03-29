import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            SummaryView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Summary")
                }

            TrendsView()
                .tabItem {
                    Image(systemName: "waveform.path.ecg")
                    Text("Trends")
                }

            ProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
        }
        .onAppear {
            HealthKitManager.shared.requestAuthorization { success, error in
                if success {
                    print("✅ HealthKit authorization granted")
                } else {
                    print("❌ HealthKit authorization failed: \(String(describing: error))")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

