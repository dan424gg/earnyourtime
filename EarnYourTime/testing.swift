import SwiftUI
import Combine
import BackgroundTasks


struct Testing: View {
    var body: some View {
        Button ("Start Background Task!") {
            scheduleAppRefresh()
        }
    }
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "StartBackgroundTask!")
        let time = Date.now.addingTimeInterval(5)
        request.earliestBeginDate = time // in 5 seconds
        try? BGTaskScheduler.shared.submit(request)
        
        print("submitted task for \(request.earliestBeginDate ?? Date())")
    }

}

#Preview {
    Testing()
}
