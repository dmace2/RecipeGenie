//
//  SelectIngredientView.swift
//  RecipeGuide
//
//  Created by Dylan Mace on 3/29/23.
//

import SwiftUI
import Combine

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

struct SelectIngredientView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var ingredientManager = IngredientManager(
        fullIngredientList: RecipeDecoder.shared.fullIngredients)
    var completion: ((Element) -> Void)?

    @State var selection: Element?

    var body: some View {
        ZStack(alignment: .bottom) {
            if RecipeDecoder.shared.isLoading {
                ProgressView("Loading Ingredients...")
            } else {
                List {
                    ForEach(ingredientManager.searchedIngredients, id: \.text) { item in
                        HStack {
                            IngredientView(ingredient: item)
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.accentColor)
                                .opacity(item == selection ? 1 : 0)
                        }.onTapGesture { withAnimation { selection = item } }
                    }
                }
                .searchable(text: $ingredientManager.searchText)
                .onReceive(ingredientManager.$searchText.debounce(for: 0.8, scheduler: RunLoop.main)) { searchTerm in
                    ingredientManager.search(searchTerm)
                }
            }
            if let selection {
                Button("Add to Pantry") {
                    completion?(selection)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
        }
        .navigationTitle("Available Ingredients")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SelectIngredientView_Previews: PreviewProvider {
    static var previews: some View {
        SelectIngredientView()
    }
}
