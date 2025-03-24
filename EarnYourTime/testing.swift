import SwiftUI
import UIKit

struct testing: View {
    

    var body: some View {
        VStack {
            Button("Press me") {
                Task {
                    await sendNotification(title: "Test", subtitle: "Stay calm, this is a test", waitDuration: 1, repeats: false)
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    testing()
}
