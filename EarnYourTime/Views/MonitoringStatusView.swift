import SwiftUI
import Combine

struct MonitoringStatusView: View {
    @AppStorage(StorageKey.vacationMode.rawValue) var vacationMode: Bool = true
    @AppStorage(StorageKey.vacationModeEndDate.rawValue) var vacationModeEndDate: Double = Date().timeIntervalSince1970 + 500
    @State private var timeLeft: Double = 0
    @State private var timerRunning: Bool = false
    private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var color: Color {
        vacationMode ? .yellow : .green
    }

    var body: some View {
        VStack {
            statusIndicator
                .activityBackground(color: color)
                .onAppear {
                    updateTimeLeft()
                }
                .onChange(of: vacationMode) { _, newValue in
                    if newValue {
                        updateTimeLeft()
                    } else {
                        timeLeft = 0
                        timerRunning = false
                    }
                }
        }
    }

    private var statusIndicator: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: vacationMode ? "clock.fill" : "checkmark.circle.fill")
                    .foregroundColor(color)
                    .font(.system(size: 18, weight: .semibold))
                    .animation(.easeInOut, value: vacationMode)
                
                Text(vacationMode ? "Vacation Mode" : "Monitoring Active")
                    .font(.system(size: 14, weight: .semibold))
                    .animation(.easeInOut, value: vacationMode)
            }

            if vacationMode {
                countdownTimer
            }
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
