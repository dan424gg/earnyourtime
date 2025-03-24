import SwiftUI

struct OtherInfo: View {
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Image(systemName: "envelope")
                        Text("Contact Us")
                    }
                    .fontWeight(.bold)

                    Text("Send us an email for support or feedback.")
                }

                Section {
                    HStack {
                        Image(systemName: "star")
                        Text("Rate Our App")
                    }
                    .fontWeight(.bold)

                    Text("Leave a rating and help improve the app.")
                }

                Section {
                    HStack {
                        Image(systemName: "wrench")
                        Text("Request a Feature")
                    }
                    .fontWeight(.bold)

                    Text("Suggest new features you'd like to see.")
                }

                Section {
                    HStack {
                        Image(systemName: "lock.shield")
                        Text("Privacy Policy")
                    }
                    .fontWeight(.bold)

                    Text("Read our privacy policy.")
                }

                Section {
                    HStack {
                        Image(systemName: "trash")
                        Text("Delete Data")
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.red)

                    Text("Permanently remove all stored data.")
                }
            }
            .navigationTitle("Other Settings")
        }
    }
}
