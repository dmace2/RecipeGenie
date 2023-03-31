//
//  CapabilityListView.swift
//  
//
//  Created by Dylan Mace on 3/31/23.
//

import SwiftUI

struct CapabilityListView: View {
    var withPadding = true

    var body: some View {
        CapabilityView(systemImg: "list.clipboard", title: "Keep Tabs on Your Pantry",
                       description: "Store all the ingredients in your house to keep track of what you have used and what you are missing")
        .padding(.bottom, withPadding ? 30 : 0)
        CapabilityView(systemImg: "carrot", title: "Find New Meals",
                       description: "Get recommendations on new recipes to try, ranging from bakery items to full home-cooked entrees")
        .padding(.bottom, withPadding ? 30 : 0)
        CapabilityView(systemImg: "rectangle.dashed", title: "Work Within Your Items",
                       description: "Add an additional filter for recipes only using items in your closet to avoid a trip to the grocery store.")
        .padding(.bottom, withPadding ? 30 : 0)
        CapabilityView(systemImg: "cart", title: "Shop by Recipe",
                       description: "Add both individual ingredients and entire recipes to your own personalized shopping cart for quicker and easier grocery trips")
        .padding(.bottom, withPadding ? 30 : 0)
    }
}

struct CapabilityListView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CapabilityListView()
        }
    }
}
