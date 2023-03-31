//
//  SwiftUIView.swift
//  
//
//  Created by Dylan Mace on 3/31/23.
//

import SwiftUI

enum Shoppables: String, CaseIterable {
    case ingredient = "Ingredients"
    case recipe = "Recipes"
}

struct AddShoppableItemView: View {
    @State private var selectedSegment: Shoppables = .ingredient
    var completion: (([Shoppable]) -> Void)?
    @Namespace var namespace

    var body: some View {
        VStack {
            Picker(selection: $selectedSegment, label: Text("")) {
                ForEach(Shoppables.allCases, id: \.self) { index in
                    Text(index.rawValue).tag(index)
                }
            }.pickerStyle(.segmented).padding()

            switch selectedSegment {
            case .ingredient:
                SelectIngredientView(completion: completion)
                    .matchedGeometryEffect(id: "SHOPPABLE_SELECT", in: namespace)
            case .recipe:
                SelectRecipeView(completion: completion)
                    .matchedGeometryEffect(id: "SHOPPABLE_SELECT", in: namespace)
            }
            Spacer()
        }
    }
}

struct AddShoppableItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddShoppableItemView()
    }
}
