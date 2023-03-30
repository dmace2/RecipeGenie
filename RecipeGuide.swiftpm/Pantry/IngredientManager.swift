//
//  IngredientManager.swift
//  
//
//  Created by Dylan Mace on 3/30/23.
//

import Foundation
import Combine
import SwiftUI

class IngredientManager: ObservableObject {
    var fullIngredientList: [Element]
    @Published var searchedIngredients: [Element] = []
    @Published var searchText = ""
    var anyCancellable: AnyCancellable?

    init(fullIngredientList: [Element]) {
        self.fullIngredientList = fullIngredientList
        self.searchedIngredients = fullIngredientList

        anyCancellable = RecipeDecoder.shared.$recipeList.sink { _ in
            self.fullIngredientList = RecipeDecoder.shared.fullIngredients.sorted {$0.text < $1.text}
            if self.searchText == "" {
                withAnimation {
                    self.searchedIngredients = self.fullIngredientList
                }
            }

        }
    }

    func search(_ text: String) {
        guard searchText != "" else {
            withAnimation { searchedIngredients = fullIngredientList }
            return
        }
        withAnimation {
            searchedIngredients = fullIngredientList.filter { $0.text.lowercased().contains(text.lowercased())}
        }
    }

}
