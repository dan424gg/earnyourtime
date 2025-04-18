//
//  IntroOnboardingView.swift
//  EarnYourTime
//
//  Created by Daniel Wells on 4/4/25.
//

import SwiftUI

struct IntroOnboardingView: View {
    @Environment(OnboardingObservable.self) private var vm
    
    var body: some View {
        VStack(spacing: 75) {
            Text("Welcome to EarnYourTime")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            Image(systemName: "iphone.gen2.radiowaves.left.and.right")
                .font(.system(size: 100, weight: .light))
                .foregroundStyle(.black, .green, .white)
        }
    }
}

#Preview {
    IntroOnboardingView()
        .environment(OnboardingObservable())
}
