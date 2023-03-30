//
//  OnboardingView.swift
//  RecipeGuide
//
//  Created by Dylan Mace on 3/29/23.
//

import SwiftUI

struct AppLaunchView: View {
    var namespaceID: Namespace.ID
    var buttonFunc: (() -> Void)

    init(animation: Namespace.ID = Namespace().wrappedValue,
         action: @escaping () -> Void = {}) {
        self.namespaceID = animation
        self.buttonFunc = action
    }

    var body: some View {
        ZStack(alignment: .center) {
            Constants.backgroundGradient
                .matchedGeometryEffect(id: "BACKGROUND", in: namespaceID)
                .blur(radius: 5).ignoresSafeArea(.all)
                VStack {
                    VStack {
                        Image(systemName: "fork.knife").resizable().scaledToFit()
                            .matchedGeometryEffect(id: "APPICON", in: namespaceID)
                            .frame(height: 150)
                        Text("RecipeGenie").font(.largeTitle.weight(.heavy))
                            .matchedGeometryEffect(id: "APPTITLE", in: namespaceID)
                    }
                    Spacer(minLength: 50)

                    Button("Get Started", action: buttonFunc)
                    .buttonStyle(ProminentButtonStyle(background: .black))
                    .matchedGeometryEffect(id: "ADVANCE", in: namespaceID)

                }
                .padding(.top, 100)
                .padding(.bottom)
                .opacity(0.9)
                .foregroundColor(.black)
        }
    }
}

struct AppLaunchView_Previews: PreviewProvider {
    static var previews: some View {
        AppLaunchView()
    }
}
