//
//  OnboardingContainer.swift
//  
//
//  Created by Dylan Mace on 3/29/23.
//

import SwiftUI

enum OnboardingState {
    case applogo
    case capabilities
    case getstarted

    func next() -> Self {
        if self == .applogo {
            return .capabilities
        } else if self == .capabilities {
            return .getstarted
        } else {
            return .getstarted
        }
    }
}

struct OnboardingContainer: View {
    @Namespace var namespace
    @State var state = OnboardingState.applogo
    @Environment(\.viewRouter) var viewRouter

    var body: some View {
        switch state {
        case .applogo:
            AppLaunchView(animation: namespace, action: advance)
        case .capabilities:
            CapabilitiesView(animation: namespace, action: advance)
        case .getstarted:
            CompleteOnboardingView(animation: namespace, action: advance)
        }
    }

    func advance() {
        withAnimation {
            if state == .getstarted {
                viewRouter.didCompleteOnboarding()
            }
            state = state.next()
        }
    }
}

struct OnboardingContainer_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingContainer()
    }
}
