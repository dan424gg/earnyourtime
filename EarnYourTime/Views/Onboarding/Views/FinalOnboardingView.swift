//
//  FinalOnboardingView.swift
//  EarnYourTime
//
//  Created by Daniel Wells on 4/4/25.
//

import SwiftUI

struct FinalOnboardingView: View {
    @Environment(OnboardingObservable.self) private var vm
    
    var body: some View {
        Text("Let's get started!")
            .font(.largeTitle)
            .fontWeight(.medium)
            .multilineTextAlignment(.center)
    }
}

#Preview {
    FinalOnboardingView()
        .environment(OnboardingObservable())
}
