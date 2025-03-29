import SwiftUI
import Combine

struct MonitoringStatusView: View {
    @AppStorage(StorageKey.vacationMode.rawValue) var vacationMode: Bool = true
    @AppStorage(StorageKey.vacationModeEndDate.rawValue) var vacationModeEndDate: Double = Date().timeIntervalSince1970 + 500
    @State var timeLeft: Double = 0
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var color: Color {
        vacationMode ? .yellow : .green
    }
    
    var body: some View {
        VStack {
            statusIndicator
            .activityBackground(color: color)
            .padding()
            .onChange(of: vacationMode, initial: true) { (old, new) in
                if new {
                    timeLeft = vacationModeEndDate - Date().timeIntervalSince1970
                }
            }
            toggleSwitch
        }
    }
    
    private var statusIndicator: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: vacationMode ? "clock.fill" : "checkmark.circle.fill")
                    .foregroundColor(color)
                    .font(.system(size: 22, weight: .semibold))
                    .animation(.easeInOut, value: vacationMode)
                
                Text(vacationMode ? "Vacation Mode" : "Monitoring Active")
                    .font(.system(size: 18, weight: .semibold))
                    .animation(.easeInOut, value: vacationMode)
            }
            if vacationMode {
                countdownTimer
            }
        }
    }
    
    private var toggleSwitch: some View {
        Toggle("", isOn: $vacationMode)
            .labelsHidden()
    }
    
    private var countdownTimer: some View {
        Text("Monitoring resumes in \(formatDuration(seconds: Int(timeLeft)))")
        .font(.system(size: 12, weight: .semibold))
        .foregroundStyle(.gray.opacity(0.8))
        .onReceive(timer) { _ in
            if timeLeft > 0 {
                timeLeft -= 1
            } else {
                timeLeft = 10
            }
        }
    }
}

#Preview {
    MonitoringStatusView()
}
