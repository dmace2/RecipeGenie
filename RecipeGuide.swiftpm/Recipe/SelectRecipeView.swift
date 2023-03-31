//
//  SelectRecipeView.swift
//  
//
//  Created by Dylan Mace on 3/31/23.
//
import SwiftUI
import Combine

class SelectRecipeSearchModel: ObservableObject {
    @Published var searchedRecipes: [Recipe] = []
    @Published var searchText = ""
    var anyCancellable: AnyCancellable?

    init() {
        self.searchedRecipes = RecipeDecoder.shared.fullRecipes

        anyCancellable = RecipeDecoder.shared.$fullRecipes.sink { _ in
            self.searchedRecipes = RecipeDecoder.shared.fullRecipes
            self.search(self.searchText)

        }
    }

    func search(_ text: String) {
        guard searchText != "" else {
            withAnimation { searchedRecipes = RecipeDecoder.shared.fullRecipes }
            return
        }
        withAnimation {
            searchedRecipes = RecipeDecoder.shared.fullRecipes.filter { $0.title.lowercased().contains(text.lowercased())}
        }
    }
}

struct SelectRecipeView: View {
    @Environment(\.dismiss) var dismiss
    var completion: (([Recipe]) -> Void)?
    @StateObject var recipeSelectionManager: SelectRecipeSearchModel = .init()
    @State var selectedItems: [Recipe] = []

    var body: some View {
        ZStack(alignment: .bottom) {
            if RecipeDecoder.shared.isLoading {
                ProgressView("Loading Recipes...")
            } else {
                List {
                    ForEach(recipeSelectionManager.searchedRecipes, id: \.id) { item in
                        HStack {
                            RecipeOverviewView(recipe: item)
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.accentColor)
                                .opacity(selectedItems.contains(item) ? 1 : 0)
                        }.onTapGesture {
                            withAnimation {
                                if !selectedItems.contains(item) {
                                    selectedItems.append(item)
                                } else { selectedItems.remove(at: selectedItems.firstIndex(of: item)!)}
                            } }
                    }
                }
                .searchable(text: $recipeSelectionManager.searchText)
                .onReceive(recipeSelectionManager.$searchText.debounce(for: 0.8, scheduler: RunLoop.main)) { searchTerm in
                    recipeSelectionManager.search(searchTerm)
                }
            }
            if !selectedItems.isEmpty {
                Button("Add") {
                    completion?(selectedItems)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
        }
        .navigationTitle("Available Recipes")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SelectRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        SelectRecipeView()
    }
}
