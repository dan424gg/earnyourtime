//
//  NameOnboardingView.swift
//  EarnYourTime
//
//  Created by Daniel Wells on 4/12/25.
//

import SwiftUI

struct NameOnboardingView: View {
    @State private var tempName: String = ""
    @AppStorage(StorageKey.fullName.rawValue) var name: String = ""
    @Environment(\.dismiss) var dismiss
    @Environment(OnboardingObservable.self) private var vm
    @FocusState private var keyboardHasFocus: Bool
    
    var body: some View {
        VStack {
            Text("Firstly, what's your name?")
                .font(.title)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)

            TextField("Enter your name", text: $tempName)
                .padding(12)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                }
                .frame(width: getWidthOfScreen() * 0.8)
                .submitLabel(.continue)
                .onSubmit {
                    name = tempName
                    withAnimation {
                        vm.phase += 1
                    }
                }
                .focused($keyboardHasFocus)
            
            Spacer()
        }
        .onAppear {
            keyboardHasFocus = true
            tempName = name
        }
    }
}

#Preview {
    NameOnboardingView()
        .environment(OnboardingObservable())
}
