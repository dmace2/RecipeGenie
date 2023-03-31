//
//  SwiftUIView.swift
//  
//
//  Created by Dylan Mace on 3/31/23.
//

import SwiftUI

struct RecipeOverviewView: View {
    var recipe: Recipe

    var body: some View {
        VStack(alignment: .leading) {
            Text(recipe.title).bold()
                .padding(.bottom, 5)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(generateIngredientList())
                .font(.callout).foregroundColor(.accentColor)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    func generateIngredientList() -> String {
        var text = ""
        recipe.ingredients.forEach { ingredient in
            let name = ingredient.text.components(separatedBy: ", ").first ?? ""
            text += (name.capitalized + ", ")
        }
        let range = text.index(text.startIndex,
                               offsetBy: 0)..<text.index(text.endIndex,
                                                         offsetBy: -2)
        return String(text[range])
    }
}

struct RecipeOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeOverviewView(recipe: RecipeDecoder.shared.decodeSampleRecipe())
    }
}
