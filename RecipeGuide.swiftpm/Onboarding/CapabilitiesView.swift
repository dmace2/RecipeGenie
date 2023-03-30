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
                .frame(width: 40)
                .font(.body.weight(.bold))
            VStack(alignment: .leading) {
                Text(title).font(.body.weight(.bold))
                Text(description).font(.caption)
            }
            .padding(.horizontal)
        }
        .padding(.bottom, 30)
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
                
                CapabilityView(systemImg: "list.clipboard", title: "Keep Tabs on Your Pantry",
                               description: "Store all the ingredients in your house to keep track of what you have used and what you are missing")
                CapabilityView(systemImg: "carrot", title: "Find New Meals",
                               description: "Get recommendations on new recipes to try, ranging from bakery items to full home-cooked entrees")
                CapabilityView(systemImg: "rectangle.dashed", title: "Work Within Your Items",
                               description: "Add an additional filter for recipes only using items in your closet to avoid a trip to the grocery store")
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
