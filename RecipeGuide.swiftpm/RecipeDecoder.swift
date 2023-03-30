//
//  RecipeDecoder.swift
//  RecipeMaker
//
//  Created by Dylan Mace on 3/29/23.
//

import Foundation
import SwiftUI
import CoreData
import Combine

class RecipeDecoder: ObservableObject {
    static var shared = RecipeDecoder()

    @Published var recipeList: [Recipe] = []
    private var fullRecipes: [Recipe] = []
    private(set) var fullIngredients: [Element] = []

    @Published var isLoading: Bool = false

    @Published var searchText = ""
    @Published var withYourIngredients = false


    var ingredientCancellable: AnyCancellable?
    private var decodeTask: Task<Void, Never>?

    private init() {
        self.decodeRecipeList()
        ingredientCancellable = NotificationCenter.default
            .publisher(for: Constants.pantryEditedNotif)
            .sink { _ in
                self.updateFilter(searchText: self.searchText, toggle: self.withYourIngredients)
            }
    }

    deinit {
        ingredientCancellable?.cancel()
        decodeTask?.cancel()
    }


    private func decodeRecipeList() {
        decodeTask?.cancel()
        guard let url = Bundle.main.url(forResource: "recipes_with_nutritional_info", withExtension: "json") else {
            fatalError("Couldn't find data.json in the project")
        }
        print("found file")
        decodeTask = Task {
            defer { DispatchQueue.main.async { self.isLoading = false } }
            do {
                isLoading = true
                let data = try Data(contentsOf: url)
                let recipes = try JSONDecoder().decode([Recipe].self, from: data)
                guard !Task.isCancelled else { return }
                DispatchQueue.main.async {
                    withAnimation {
                        self.fullRecipes = recipes.shuffled()
                        self.fullIngredients = Array(Set(recipes.map({$0.ingredients}).flatMap({$0})))
                        self.updateFilter(searchText: self.searchText, toggle: self.withYourIngredients)
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func refresh() {
        updateFilter(searchText: searchText, toggle: withYourIngredients)
        recipeList.shuffle()
    }

    func updateFilter(searchText: String, toggle: Bool) {
        var tmpResults = fullRecipes
        withAnimation {
            if searchText != "" {
                tmpResults = tmpResults.filter { $0.title.lowercased().contains(searchText.lowercased()) }
            }
            if toggle {
                filterByIngredients(recipes: &tmpResults)
            }
            recipeList = tmpResults
        }
    }

    private func filterByIngredients(recipes: inout [Recipe]) {
        let request = CDIngredient.fetchRequest()
        guard let vals = try? Persistence.shared.container.viewContext.fetch(request) as? [CDIngredient] else {
            print("failed to get from CD")
            return
        }
        let mappedVals = vals.map { Element(text: $0.name)}
        recipes = recipes.compactMap({ recipe in
            var good = true
            recipe.ingredients.forEach {
                if !mappedVals.contains($0) {
                    good = false
                }
            }
            return good ? recipe : nil
        })
    }

//    func updateSharedList(for searchTerm: String) {
//        withAnimation {
//            guard searchTerm != "" else {
//                recipeList = fullRecipes
//                return
//            }
//            recipeList = fullRecipes.filter { $0.title.lowercased().contains(searchTerm.lowercased()) }
//        }
//    }
//
//    func updateSharedList(toMatch toggle: Bool) {
//        withAnimation {
//            guard  toggle else {
//                recipeList = fullRecipes
//                return
//            }
//            let request = CDIngredient.fetchRequest()
//            guard let vals = try? Persistence.shared.container.viewContext.fetch(request) as? [CDIngredient] else {
//                //        guard let vals = try? context.fetch(NSFetchRequest(entityName: "CDIngredient")) as? [CDIngredient] else {
//                print("failed to get from CD")
//                return
//            }
//            let mappedVals = vals.map { Element(text: $0.name)}
//            recipeList = recipeList.compactMap({ recipe in
//                var good = true
//                recipe.ingredients.forEach {
//                    if !mappedVals.contains($0) {
//                        good = false
//                    }
//                }
//                return good ? recipe : nil
//            })
//        }
//    }
    

    func decodeSampleRecipe() -> Recipe {
        let url = Bundle.main.url(forResource: "sample_recipe", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let recipes = try! JSONDecoder().decode([Recipe].self, from: data)
        return recipes[0]
    }
}
