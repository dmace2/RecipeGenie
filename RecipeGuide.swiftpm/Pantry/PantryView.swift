//
//  PantryView.swift
//  RecipeGuide
//
//  Created by Dylan Mace on 3/29/23.
//

import SwiftUI

struct PantryView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(sortDescriptors: [
        NSSortDescriptor(keyPath: \CDIngredient.name, ascending: true)
    ], animation: .default)
    private var items: FetchedResults<CDIngredient>


    var body: some View {
        NavigationView {
                ZStack(alignment: .center) {
                        if items.count == 0 {
                            Text("Add something to your pantry to see it here.")
                        } else {
                            List {
                                ForEach(items) { item in
                                    let ingredient = TextItem(text: item.name)
                                    GroupBox {
                                        IngredientView(ingredient: ingredient)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .listRowSeparator(.hidden)
                                }
                                .onDelete { deleteOffsets in
                                    for idx in deleteOffsets {
                                        viewContext.delete(items[idx])
                                    }
                                    try? viewContext.save()
                                    NotificationCenter.default.post(name: Constants.pantryEditedNotif, object: nil)
                                }
                            }.listStyle(.plain)
                        }
                }
            .navigationTitle("Pantry")
            .toolbar {
                let destination = SelectIngredientView(completion: { addItems($0) })
                NavigationLink(destination: destination) {
                    Image(systemName: "plus")
                }
            }
        }
    }

    func addItems(_ ingredients: [TextItem]) {
        ingredients.forEach { ingredient in
            guard items.filter({$0.name == ingredient.text}).isEmpty else { return }
            let pantryItem = CDIngredient(context: viewContext)
            pantryItem.name = ingredient.text
        }
        viewContext.perform {
            try! viewContext.save()
            NotificationCenter.default.post(name: Constants.pantryEditedNotif, object: nil)
        }
    }
}

struct PantryView_Previews: PreviewProvider {
    static var previews: some View {
        PantryView()
    }
}
