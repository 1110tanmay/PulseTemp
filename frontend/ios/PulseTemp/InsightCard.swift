import SwiftUI

struct InsightCard: View {
    let icon: String
    let color: Color
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title2)
                .frame(width: 40, height: 40)
            
            Text(text)
                .font(.body)
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

