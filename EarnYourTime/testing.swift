import SwiftUI
import UIKit

struct testing: View {
    @State private var showLoading = true
    @State private var showView: Bool = false


    var body: some View {
        ZStack {
            if showLoading {
                Text("Loading...")
            }

            if showView {
                Text("Actual view")
                    .background(Color.white)
            }
        }
        .onAppear {
            showLoading = true
        }
        .task {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                showLoading = false
                showView = true
            }
        }
    }
}

#Preview {
    testing()
}
