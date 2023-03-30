//
//  ContentView.swift
//  RecipeMaker
//
//  Created by Dylan Mace on 3/29/23.
//

import SwiftUI
import Combine

struct RecipeOptionsView: View {
    @StateObject var recipeManager = RecipeDecoder.shared

    var body: some View {
        NavigationView {
            ScrollView {
                ZStack(alignment: .center) {
                    LazyVStack {
                        Toggle("Based On Your Ingredients", isOn: $recipeManager.withYourIngredients)
                        ForEach(recipeManager.recipeList) { item in
                            GroupBox {
                                NavigationLink(destination: RecipeView(recipe: item)) {
                                    HStack(alignment: .center) {
                                        Image(systemName: "fork.knife")
                                            .resizable().scaledToFit()
                                            .frame(height: 30)
                                        Text(item.title)
                                            .multilineTextAlignment(.leading)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                        if recipeManager.isLoading {
                            ProgressView("Loading Recipes...")
                        }
                    }.padding(.horizontal)
                }
            }
            .searchable(text: $recipeManager.searchText, placement: .toolbar)
            .onReceive(recipeManager.$searchText.debounce(for: 0.8, scheduler: RunLoop.main)) { searchTerm in
                recipeManager.updateSharedList(for: searchTerm)
            }
            .onReceive(recipeManager.$withYourIngredients.debounce(for: 0.5, scheduler: RunLoop.main)) { toggleVal in
                recipeManager.updateSharedList(toMatch: toggleVal)
            }
            .navigationTitle("Recipes")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeOptionsView()
    }
}
