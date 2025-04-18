//
//  OnboardingObservable.swift
//  EarnYourTime
//
//  Created by Daniel Wells on 4/4/25.
//

import Foundation
import SwiftUI


@Observable
class OnboardingObservable {
    var phase: Int = 0
    var disableButton: Bool = false
}
