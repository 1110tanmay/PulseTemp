import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            SummaryView()  // ✅ Summary Tab
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Summary")
                }

            TrendsView()  // ✅ Trends Tab
                .tabItem {
                    Image(systemName: "waveform.path.ecg")
                    Text("Trends")
                }

            ProfileView()  // ✅ Profile Tab (Added)
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
        }
    }
}

// ✅ Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

