import SwiftUI

struct PersonalInfo: View {
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Image(systemName: "person")
                        Text("Name")
                    }
                    .fontWeight(.bold)
                    
                    Text("This is your full name.")
                }
                
                Section {
                    HStack {
                        Image(systemName: "bell")
                        Text("Notifications")
                    }
                    .fontWeight(.bold)
                    
                    Text("Manage your notification preferences.")
                }
            }
            .navigationTitle("Personal Settings")
        }
    }
}
