//
//  SwiftUIView.swift
//  
//
//  Created by Dylan Mace on 3/29/23.
//

import SwiftUI

struct CapabilityView: View {
    var systemImg: String
    var title: String
    var description: String

    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: systemImg)
                .resizable().scaledToFit()
                .frame(width: 40, height: 40)
                .font(.body.weight(.bold))
            VStack(alignment: .leading) {
                Text(title).font(.body.weight(.bold))
                Text(description).font(.caption)
            }
            .padding(.horizontal)
        }
    }
}

struct CapabilitiesView: View {
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

                Spacer().frame(height: 100)
                
                CapabilityListView()
                Spacer()

                HStack {
                    Spacer()
                    Button("Continue", action: buttonFunc)
                        .buttonStyle(ProminentButtonStyle(background: .black))
                        .matchedGeometryEffect(id: "ADVANCE", in: namespaceID)
                    Spacer()
                }

            }
            .padding(.top, 100)
            .padding(.bottom)
            .padding(.horizontal, 40)
            .opacity(0.9)
            .foregroundColor(.black)
        }
    }
}

struct CapabilitiesView_Previews: PreviewProvider {
    static var previews: some View {
        CapabilitiesView()
            .preferredColorScheme(.dark)
    }
}
