//
//  RecipeMakerApp.swift
//  RecipeMaker
//
//  Created by Dylan Mace on 3/29/23.
//

import SwiftUI

@main
struct RecipeMakerApp: App {
    let persistence = Persistence.shared
    @StateObject var viewRouter = ContainerRouter()

    var body: some Scene {
        WindowGroup {
            VStack {
                switch viewRouter.currentViewType {
                case .onboarding: OnboardingContainer()
                case .home: ContainerView()
                }
            }
            .environment(\.viewRouter, viewRouter)
            .environment(\.managedObjectContext, persistence.container.viewContext)
        }
    }
}

private struct ViewRouterKey: EnvironmentKey {
  static let defaultValue = ContainerRouter()
}

extension EnvironmentValues {
  var viewRouter: ContainerRouter {
      get { self[ViewRouterKey.self] }
      set { self[ViewRouterKey.self] = newValue }
  }
}
