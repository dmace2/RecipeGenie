//
//  RecipeCardView.swift
//  
//
//  Created by Dylan Mace on 3/29/23.
//

import SwiftUI

struct RecipeCardView: View {
    var recipe: Recipe

    var body: some View {
        ZStack(alignment: .bottom) {
            Image("cooking-ingredients")
                .resizable().scaledToFill()
                Text(recipe.title)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .padding()
                .font(.title.weight(.bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .shadow(radius: 10)
                .background { Color.black.opacity(0.6).blur(radius: 5).blendMode(.darken) }
        }
        .frame(maxWidth: .infinity, maxHeight: 450)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

struct RecipeCardView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeCardView(recipe: RecipeDecoder.shared.decodeSampleRecipe())
            .padding()
    }
}
