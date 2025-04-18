//
//  TextOnboardingView.swift
//  EarnYourTime
//
//  Created by Daniel Wells on 4/4/25.
//

import SwiftUI

struct TextOnboardingView: View {
    @Environment(OnboardingObservable.self) private var vm
    
    var body: some View {
        VStack(spacing: 50) {
            Text("I was stuck in a cycle of social media addiction...")
                .font(.title2)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
            
            Group {
                Text("So I built an app that lets me earn time on ") + Text("bad").foregroundStyle(.red) + Text(" apps by using ") + Text("good").foregroundStyle(.green) + Text(" ones first")
            }
                .font(.title2)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    TextOnboardingView()
        .environment(OnboardingObservable())
}
