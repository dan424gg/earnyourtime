import SwiftUI
import Combine

struct MonitoringStatusView: View {
    @AppStorage(StorageKey.vacationMode.rawValue) var vacationMode: Bool = true
    @AppStorage(StorageKey.vacationModeEndDate.rawValue) var vacationModeEndDate: Double = 0
    @AppStorage(StorageKey.isMonitoring.rawValue) private var isMonitoring: Bool = false
    @State private var timeLeft: Double = 0
    @State private var timerRunning: Bool = false
    private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var color: Color {
        isMonitoring ? .green : .red
    }

    var body: some View {
        VStack {
            statusIndicator
                .activityBackground(color: color)
        }
    }

    private var statusIndicator: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: isMonitoring ? "checkmark.circle.fill" : "x.circle.fill")
                    .foregroundColor(color)
                    .font(.system(size: 18, weight: .medium))
                    .animation(.easeInOut, value: isMonitoring)
                
                Text(isMonitoring ? "Monitoring Active" : "Monitoring Inactive")
                    .font(.system(size: 14, weight: .medium))
                    .animation(.easeInOut, value: isMonitoring)
            }

//            if vacationMode {
//                countdownTimer
//            }
        }
    }

    private var countdownTimer: some View {
        Text("Monitoring resumes in \(formatDuration(seconds: Int(timeLeft)))")
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(.gray.opacity(0.8))
            .onReceive(timer) { _ in
                if timerRunning && timeLeft > 0 {
                    timeLeft -= 1
                } else {
                    timerRunning = false
                }
            }
    }

    private func updateTimeLeft() {
        timeLeft = max(0, vacationModeEndDate - Date().timeIntervalSince1970)
        timerRunning = timeLeft > 0
    }
}

#Preview {
    MonitoringStatusView()
}
