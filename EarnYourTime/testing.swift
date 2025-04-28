import SwiftUI
import Combine
import BackgroundTasks


struct Testing: View {
    
    var option1: some View {
        VStack {
            Text("Things are looking good!")
                .font(.title)
                .fontWeight(.bold)
            
            Divider()
            
            HStack {
                VStack {
                    Text("Productive Apps")
                    HStack {
                        Text("15m ").foregroundStyle(.green) +
                        Text("/") +
                        Text(" 45m").foregroundStyle(.blue)
                    }
                }
                
                VStack {
                    Text("Unproductive Apps")
                    HStack {
                        Text("5m ").foregroundStyle(.red) +
                        Text("/") +
                        Text(" 25m").foregroundStyle(.red)
                    }
                }
            }
            .fontWeight(.semibold)
        }
        .padding(25)
    }
    
    var Header: some View {
        VStack {
            ZStack {
                // Top bar with hamburger icon
                HStack {
                    Spacer()
                    
                    Button(action: {
                        // Handle hamburger tap here
                        print("Hamburger menu tapped")
                    }) {
                        Image(systemName: "gearshape")
                            .font(.system(size: 25))
                            .fontWeight(.light)
                            .padding()
                    }
                }
                
                // Greeting + Date Header
                VStack {
                    Text("Welcome back!")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(Date.now.formatted(date: .long, time: .omitted))
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
    
    struct Card: View {
        var title: String
        var usageTime: Int
        var restrictiveTime: Int
        var color: Color
        var secondaryColor: Color?
        
        // callbacks
        var onEditAppsTapped: (() -> Void)? = nil
        var onChangeTimeTapped: (() -> Void)? = nil

        var body: some View {
            VStack(alignment: .center, spacing: 10) {
                // title
                Text(title)
                    .font(.title2)
                
                // usage time
                HStack {
                    (Text("\(formatDuration(seconds: usageTime)) ").foregroundStyle(color) +
                     Text("/") +
                     Text(" \(formatDuration(seconds: restrictiveTime))").foregroundStyle(secondaryColor ?? color) + Text(" "))
                    .font(.title3)
                }
                
                Divider()
                    .padding(.vertical, 4)
                
                // Settings Section
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Apps:")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Button("Edit") {
                            onEditAppsTapped?()
                        }
                        .font(.subheadline)
                    }
                    
                    HStack {
                        Text("Checkpoint:")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Button(action: {
                            onChangeTimeTapped?()
                        }) {
                            Text("\(formatDuration(seconds: restrictiveTime))")
                        }
                        .font(.subheadline)
                    }
                }
                .foregroundStyle(.black)
                .buttonStyle(.bordered)
            }
            .padding()
            .frame(width: getWidthOfScreen() * 0.75)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(color, lineWidth: 3)
                    .fill(color.opacity(0.03))
            }
        }
    }
    
    struct TimeCard: View {
        var title: String
        var usageTime: Int
        var restrictiveTime: Int
        var color: Color
        var secondaryColor: Color?

        var body: some View {
            VStack(spacing: 20) {
                // Title
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)

                // Circular Progress (without actual calculation, just static)
                ZStack {
                    Circle()
                        .stroke(color.opacity(0.2), lineWidth: 20)  // Background circle
                    
                    Circle()
                        .trim(from: 0, to: 0.5) // You can change this to simulate time usage (static for now)
                        .stroke(color, lineWidth: 20) // Foreground circle (this could be a static representation of time)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 0.5), value: usageTime)
                }
                .frame(width: 100, height: 100)

                // Usage and Total Time
                HStack {
                    Text("\(formatDuration(seconds: usageTime))")
                        .font(.title3)
                        .foregroundColor(color)
                    Text("/")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    Text("\(formatDuration(seconds: restrictiveTime))")
                        .font(.title3)
                        .foregroundColor(secondaryColor ?? color)
                }
                .padding(.top, 8)
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(color, lineWidth: 3)
                    .fill(color.opacity(0.05))
            }
            .frame(width: getWidthOfScreen() * 0.75)
        }
    }
    
    struct TimeBarCard: View {
        var title: String
        var usageTime: Int
        var restrictiveTime: Int
        var color: Color
        var secondaryColor: Color?

        var body: some View {
            VStack(spacing: 20) {
                // Title
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)

                // Time Bar (Static)
                HStack {
                    Text("\(formatDuration(seconds: usageTime))")
                        .foregroundColor(color)
                        .font(.title3)
                    
                    Rectangle()
                        .fill(color.opacity(0.2)) // Background bar
                        .frame(height: 10)

                    Text("/")
                        .foregroundColor(.secondary)
                        .font(.title3)

                    Text("\(formatDuration(seconds: restrictiveTime))")
                        .foregroundColor(secondaryColor ?? color)
                        .font(.title3)
                }
                .padding(.horizontal, 10)

                // Bar background with visual fill (static)
                Rectangle()
                    .fill(color.opacity(0.1)) // Subtle background
                    .frame(height: 8)
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(color, lineWidth: 3)
                    .fill(color.opacity(0.05))
            }
            .frame(width: getWidthOfScreen() * 0.75)
        }
    }
    
    struct TimeIconCard: View {
        var title: String
        var usageTime: Int
        var restrictiveTime: Int
        var color: Color
        var secondaryColor: Color?

        var body: some View {
            VStack(spacing: 20) {
                // Title
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)

                // Icon with time indicators
                HStack {
                    Image(systemName: "clock.fill")
                        .foregroundColor(color)
                        .font(.title2)
                    
                    VStack {
                        Text("\(formatDuration(seconds: usageTime))")
                            .font(.title3)
                            .foregroundColor(color)
                        
                        Text("/")
                            .font(.title3)
                            .foregroundColor(.secondary)
                        
                        Text("\(formatDuration(seconds: restrictiveTime))")
                            .font(.title3)
                            .foregroundColor(secondaryColor ?? color)
                    }
                }

                // Additional visual icon can be added (optional)
                Image(systemName: "hourglass")
                    .foregroundColor(secondaryColor ?? color)
                    .font(.title)
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(color, lineWidth: 3)
                    .fill(color.opacity(0.05))
            }
            .frame(width: getWidthOfScreen() * 0.75)
        }
    }
    
    var Cards2: some View {
        VStack(spacing: 20) {
            Card(
                title: "Productive App Usage",
                usageTime: 60 * 15,
                restrictiveTime: 60 * 45,
                color: .green,
                secondaryColor: .blue
            )
            
            Card(
                title: "Unproductive App Usage",
                usageTime: 60 * 5,
                restrictiveTime: 60 * 20,
                color: .red
            )
        }
    }

    var Cards3: some View {
        VStack(spacing: 20) {
            TimeIconCard(
                title: "Productive App Usage",
                usageTime: 60 * 15,
                restrictiveTime: 60 * 45,
                color: .green,
                secondaryColor: .blue
            )
            
            TimeIconCard(
                title: "Unproductive App Usage",
                usageTime: 60 * 5,
                restrictiveTime: 60 * 20,
                color: .red
            )
        }
    }
    
    var Footer: some View {
        VStack {
            Spacer()
            Text("Keep it up 🌱")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.top, 40)
        }
    }
    
    var option2: some View {
        ZStack {
            Header
            
            Cards2
            
            Footer
        }
        .fontWeight(.semibold)
        .padding()
    }
    
    var goodTimeRow: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Productive App Time")
                    .fontWeight(.bold)
                Text("Time invested on productive apps")
                    .font(.caption)
                .foregroundStyle(.secondary)
            }
            Spacer()
            (Text("\(formatDuration(seconds: 60*15)) ").foregroundStyle(.black) +
             Text("/") +
             Text(" \(formatDuration(seconds: 60*45))").foregroundStyle(.black) + Text(" "))
            .padding(10)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.green)
            }
        }
    }
    
    var baddTimeRow: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Unproductive App Time")
                .fontWeight(.bold)
                Text("Time spent on unproductive apps")
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            Spacer()
            (Text("\(formatDuration(seconds: 60*5)) ").foregroundStyle(.black) +
             Text("/") +
             Text(" \(formatDuration(seconds: 60*20))").foregroundStyle(.black) + Text(" "))
            .padding(10)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.red)
            }
        }
    }

    var option3: some View {
        
        VStack {
            Header

            ScrollView {
                VStack {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(spacing: 10) {
                            goodTimeRow
                            baddTimeRow
                        }
                        
                        Divider()
                        
                        VStack {
                            HStack {
                                Text("Unlock Unproductive Apps")
                                    .fontWeight(.bold)
                                Spacer()
                                Text("45m")
                            }
                            
                            HStack {
                                Text("Requires 45m of productive app usage to unlock 20m of unproductive app time")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                Spacer()
                            }
                        }
                        
                        Divider()
                        
                        VStack(alignment: .leading) {
                            Text("Top Productive Apps")
                                .fontWeight(.bold)

                            let randomNumbers = (0..<5).map { _ in Int.random(in: 0...50) }.sorted(by: >)
                            
                            VStack {
                                ForEach(0..<5) { index in
                                    HStack {
                                        HStack {
                                            Image(systemName: "questionmark.app")
                                            Text("App \(index)")
                                        }
                                        Spacer()
                                        Text("\(randomNumbers[index])m")
                                    }
                                }
                            }
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.green, lineWidth: 3)
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Top Unproductive Apps")
                                .fontWeight(.bold)

                            let randomNumbers = (0..<5).map { _ in Int.random(in: 0...50) }.sorted(by: >)
                            
                            VStack {
                                ForEach(0..<5) { index in
                                    HStack {
                                        HStack {
                                            Image(systemName: "questionmark.app")
                                            Text("App \(index)")
                                        }
                                        Spacer()
                                        Text("\(randomNumbers[index])m")
                                    }
                                }
                            }
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.red, lineWidth: 3)
                            }

                        }
                    }
                    
                    Footer
                }
            }
            .fontWeight(.semibold)
            .padding()
        }
    }
    
    var body: some View {
        option3
    }
}

#Preview {
    ZStack {
        AppBackground()
        Testing()
    }
}
