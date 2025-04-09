import SwiftUI

@main
struct PulseTempApp: App {
    @StateObject private var healthKitManager = HealthKitManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(healthKitManager)
        }
    }
}

