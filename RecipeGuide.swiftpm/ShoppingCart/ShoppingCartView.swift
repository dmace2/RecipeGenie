//
//  ShoppingCartView.swift
//  
//
//  Created by Dylan Mace on 3/31/23.
//

import SwiftUI
import CoreData

struct ShoppingCartView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(sortDescriptors: [
        NSSortDescriptor(keyPath: \ShoppableItem.id, ascending: true)
    ], animation: .default)
    private var items: FetchedResults<ShoppableItem>

    private var recipes: [Recipe] {
        var recipes = [Recipe]()
        items.forEach { elem in
            if let data = elem.data,
               let recipe = try? JSONDecoder().decode(Recipe.self, from: data) {
                recipes.append(recipe)
            }
        }
        return recipes.sorted { $0.title < $1.title }
    }
    private var ingredients: [TextItem] {
        return items.compactMap { $0.generateStruct(withType: TextItem.self)}
    }

    var body: some View {
        NavigationView {
                ZStack(alignment: .center) {
                        if items.count == 0 {
                            Text("Add something to your cart to see it here.")
                        } else {
                            List {
                                Section {
                                    ForEach(recipes, id: \.id) { elem in
                                        GroupBox {
                                            NavigationLink(destination: RecipeView(recipe: elem)) {
                                                RecipeOverviewView(recipe: elem).foregroundColor(.primary)
                                                    .frame(maxWidth: .infinity)
                                            }.frame(maxWidth: .infinity)
                                        }
                                        .listRowSeparator(.hidden)
                                    }.onDelete {
                                        onDelete($0, type: .recipe)
                                    }
                                } header: {
                                    Label("Recipes", systemImage: "carrot.fill")
                                        .font(.headline).foregroundColor(.red)
                                }
                                
                                Section {
                                    ForEach(ingredients, id: \.text) { item in
                                        GroupBox {
                                            IngredientView(ingredient: item)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        .listRowSeparator(.hidden)
                                    }.onDelete {
                                        onDelete($0, type: .ingredient)
                                    }
                                } header: {
                                    Label("Extra Ingredients", systemImage: "list.bullet.circle.fill")
                                        .font(.headline).foregroundColor(.blue)
                                }
                            }.listStyle(.plain)
                        }
                }
            .navigationTitle("Shopping Cart")
            .toolbar {
                let destination = AddShoppableItemView(completion: {
                    addItems($0)

                })
                NavigationLink(destination: destination) {
                    Image(systemName: "plus")
                }
            }
        }
    }

    func addItems(_ cartItems: [Shoppable]) {
        cartItems.forEach { elem in
            guard items.filter({$0.id == elem.id}).isEmpty else { return }
            let pantryItem = ShoppableItem(context: viewContext)
            pantryItem.update(with: elem)
        }
        viewContext.perform {
            try! viewContext.save()
            let editedRecipes = cartItems.compactMap({$0 as? Recipe})
            if !editedRecipes.isEmpty {
                NotificationCenter.default.post(name: Constants.shoppingCartRecipesEditedNotif,
                                                object: editedRecipes,
                                                userInfo: ["action": "added"])
            }
        }
    }

    func onDelete(_ deleteOffsets: IndexSet, type: Shoppables) {
        for idx in deleteOffsets {
            let arr: [Shoppable] = (type == .ingredient) ? ingredients : recipes
            guard let elem = items.firstIndex(where: {$0.id == arr[idx].id}) else { continue }
            viewContext.delete(items[elem])
        }
        try? viewContext.save()
        NotificationCenter.default.post(name: Constants.shoppingCartRecipesEditedNotif,
                                        object: items.compactMap({$0.generateStruct(withType: Recipe.self)}),
                                        userInfo: ["action": "deleted"])
    }
}

struct ShoppingCartView_Previews: PreviewProvider {
    static var previews: some View {
            ShoppingCartView()
                .previewInterfaceOrientation(.landscapeRight)
    }
}
