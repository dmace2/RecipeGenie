//
//  ContainerRouter.swift
//  Recipe Genie
//
//  Created by Dylan Mace on 3/29/23.
//

import Foundation
import SwiftUI

enum ViewType {
    case onboarding
    case home
}

class ContainerRouter: ObservableObject {
    @Published var currentViewType: ViewType = .onboarding

    init() {
        withAnimation {
            if UserDefaults.standard.bool(forKey: Constants.defaultsOnboardingCompletedKey) {
                self.currentViewType = .home
            } else {
                self.currentViewType = .onboarding
            }
        }
    }

    func didCompleteOnboarding() {
        UserDefaults.standard.set(true, forKey: Constants.defaultsOnboardingCompletedKey)
        self.currentViewType = .home
    }
}
