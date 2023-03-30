//
//  CompleteOnboardingView.swift
//  
//
//  Created by Dylan Mace on 3/29/23.
//

import SwiftUI

struct CompleteOnboardingView: View {
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
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "fork.knife")
                        .resizable().scaledToFit()
                        .matchedGeometryEffect(id: "APPICON", in: namespaceID)
                        .frame(height: 50)
                    Text("RecipeGenie")
                        .font(.largeTitle.weight(.heavy))
                        .matchedGeometryEffect(id: "APPTITLE", in: namespaceID)
                }
                Text("Ready to get started?").font(.body.weight(.bold))

                Spacer()

                HStack {
                    Spacer()
                    Button("Start", action: buttonFunc)
                        .buttonStyle(ProminentButtonStyle(background: .black))
                        .matchedGeometryEffect(id: "ADVANCE", in: namespaceID)
                    Spacer()
                }

            }
            .padding(.top, 100)
            .padding(.horizontal, 40)
            .padding(.bottom)
            .opacity(0.9)
            .foregroundColor(.black)
        }
    }
}

struct CompleteOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        CompleteOnboardingView()
    }
}
