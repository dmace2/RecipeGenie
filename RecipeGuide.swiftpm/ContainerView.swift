//
//  ContainerView.swift
//  RecipeGuide
//
//  Created by Dylan Mace on 3/29/23.
//

import SwiftUI

struct ContainerView: View {
    @State var showAboutView = false
    var body: some View {
        TabView {
            RecipeOptionsView().tabItem {
                Label("Recipes", systemImage: "takeoutbag.and.cup.and.straw.fill")
            }

            PantryView().tabItem {
                Label("Pantry", systemImage: "list.clipboard.fill")
            }

            ShoppingCartView().tabItem {
                Label("Cart", systemImage: "cart.fill")
            }

            AboutView().tabItem {
                Label("About", systemImage: "mug.fill")
            }
        }
    }
}

struct ContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ContainerView()
    }
}
