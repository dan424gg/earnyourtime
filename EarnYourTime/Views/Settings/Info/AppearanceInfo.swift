import SwiftUI

struct AppearanceInfo: View {
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Image(systemName: "paintbrush")
                        Text("Theme")
                    }
                    .fontWeight(.bold)

                    Text("Customize the app's appearance.")
                }
            }
            .navigationTitle("Appearance Settings")
        }
    }
}
