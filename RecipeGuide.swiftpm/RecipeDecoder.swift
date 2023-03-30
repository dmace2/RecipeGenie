//
//  RecipeDecoder.swift
//  RecipeMaker
//
//  Created by Dylan Mace on 3/29/23.
//

import Foundation
import SwiftUI
import CoreData


enum LightColor: String, Codable {
    case orange
    case red
    case green

    var view: any View {
        let name = (self == .green) ? "checkmark.circle.fill" : (self == .orange) ? "exclamationmark.triangle.fill" : "exclamationmark.octagon.fill"
        return Image(systemName: name)
            .resizable().scaledToFit()
            .frame(width: 30, height: 30)
            .foregroundColor(Color(wordName: rawValue))
    }
}

struct FSALights: Codable, Hashable {
    var fat: LightColor
    var salt: LightColor
    var saturates: LightColor
    var sugars: LightColor
}

struct Element: Codable, Hashable {
    var text: String
}

struct Nutrition: Codable, Hashable {
    var fat: Float
    var nrg: Float
    var pro: Float
    var sat: Float
    var sod: Float
    var sug: Float
}

struct Nutrition_100g: Codable, Hashable {
    var energy: Float
    var fat: Float
    var protein: Float
    var salt: Float
    var saturates: Float
    var sugars: Float
}


struct Recipe: Identifiable, Codable, Equatable, Hashable {
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.id == rhs.id
    }

    var fsa_lights_per100g: FSALights
    var id: String
    var ingredients: [Element]
    var instructions: [Element]
    var nutr_per_ingredient: [Nutrition]
    var nutr_values_per100g: Nutrition_100g
    var partition: String
    var quantity: [Element]
    var title: String
    var unit: [Element]
    var url: String
    var weight_per_ingr: [Float]
}




class RecipeDecoder: ObservableObject {
    @Published var recipeList: [Recipe] = []
    private var fullRecipes: [Recipe] = []
    private(set) var fullIngredients: [Element] = []

    @Published var isLoading: Bool = false

    @Published var searchText = ""
    @Published var withYourIngredients = false

    private var decodeTask: Task<Void, Never>?

    static var shared = RecipeDecoder()

    private init() {
        self.decodeRecipeList()
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
                        self.recipeList = self.fullRecipes
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func updateSharedList(for searchTerm: String) {
        withAnimation {
            guard searchTerm != "" else {
                withAnimation { recipeList = fullRecipes }
                return
            }
            recipeList = fullRecipes.filter { $0.title.lowercased().contains(searchTerm.lowercased()) }
        }
    }

    func updateSharedList(toMatch toggle: Bool) {
        guard  toggle else {
            recipeList = fullRecipes
            return
        }
        let request = CDIngredient.fetchRequest()
        guard let vals = try? Persistence.shared.container.viewContext.fetch(request) as? [CDIngredient] else {
//        guard let vals = try? context.fetch(NSFetchRequest(entityName: "CDIngredient")) as? [CDIngredient] else {
            print("failed to get from CD")
            return
        }
        withAnimation {
            let mappedVals = vals.map { Element(text: $0.name)}
            recipeList = recipeList.compactMap({ recipe in
                var good = true
                recipe.ingredients.forEach {
                    if !mappedVals.contains($0) {
                        good = false
                    }
                }
                return good ? recipe : nil
            })
        }
    }

    func decodeSampleRecipe() -> Recipe {
        let url = Bundle.main.url(forResource: "sample_recipe", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let recipes = try! JSONDecoder().decode([Recipe].self, from: data)
        return recipes[0]
    }
}
