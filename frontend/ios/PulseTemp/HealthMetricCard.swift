import SwiftUI
import Charts

struct HealthMetricCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    var isLarge: Bool = false
    var trailingView: AnyView? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 16) {
                // Icon Circle
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 50, height: 50)

                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(color)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Text(value)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }

            // Optional Trailing View (Chart, etc.)
            if let trailingView = trailingView {
                trailingView
                    .frame(height: 60)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: isLarge ? 150 : nil)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 4)
        )
    }
}

