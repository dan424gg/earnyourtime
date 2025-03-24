import SwiftUI

struct AppExperienceInfo: View {
    @State private var vacationMode: Bool = false

    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Image(systemName: "beach.umbrella")
                        Text("Vacation Mode")
                    }
                    .fontWeight(.bold)

                    Text("Temporarily pause app restrictions while on vacation.")
                }

                Section {
                    HStack {
                        Image(systemName: "hand.thumbsup")
                        Text("Good Apps")
                    }
                    .fontWeight(.bold)

                    Text("Select apps that contribute to productive time.")
                }

                Section {
                    HStack {
                        Image(systemName: "hand.thumbsdown")
                        Text("Bad Apps")
                    }
                    .fontWeight(.bold)

                    Text("Select apps that count as distractions.")
                }

                Section {
                    HStack {
                        Image(systemName: "flag.checkered")
                        Text("Checkpoint Time")
                    }
                    .fontWeight(.bold)

                    Text("Set intervals for reviewing your progress.")
                }

                Section {
                    HStack {
                        Image(systemName: "timer")
                        Text("Bad App Time Limit")
                    }
                    .fontWeight(.bold)

                    Text("Set a daily limit for using unproductive apps.")
                }
            }
            .navigationTitle("App Experience")
        }
    }
}
