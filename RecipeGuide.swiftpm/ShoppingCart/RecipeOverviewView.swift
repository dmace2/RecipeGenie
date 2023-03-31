//
//  SwiftUIView.swift
//  
//
//  Created by Dylan Mace on 3/31/23.
//

import SwiftUI

struct RecipeOverviewView: View {
    var recipe: Recipe
    @State var showingIngredients = false

    var body: some View {
        VStack {
            Text(recipe.title).bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.primary)
            DisclosureGroup("Ingredients", isExpanded: $showingIngredients) {
                ForEach(recipe.ingredients.indices, id: \.self) { idx in
                    let ingredient = recipe.ingredients[idx]
                    let quantity = recipe.quantity[idx]
                    let unit = recipe.unit[idx]
                    IngredientView(ingredient: ingredient, quantity: quantity, unit: unit)
                }.foregroundColor(.primary)
            }
        }
    }
}

struct RecipeOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeOverviewView(recipe: RecipeDecoder.shared.decodeSampleRecipe())
    }
}
