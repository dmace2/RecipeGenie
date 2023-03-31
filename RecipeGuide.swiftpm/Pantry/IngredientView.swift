//
//  IngredientView.swift
//  
//
//  Created by Dylan Mace on 3/29/23.
//

import SwiftUI

struct IngredientView: View {
    var ingredient: TextItem
    var quantity: TextItem?
    var unit: TextItem?

    var body: some View {
        VStack(alignment: .leading) {
        let elements = ingredient.text.capitalized.components(separatedBy: ", ")
            HStack(alignment: .lastTextBaseline) {
                Text(elements[0]).bold()
                Spacer()
                if let quantity, let unit {
                    Text("\(quantity.text) \(unit.text)")
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
            }
            ForEach(elements[1...], id: \.self) { subcat in
                HStack(alignment: .firstTextBaseline) {
                    Text("-").bold()
                    Text(subcat)
                }.padding(.leading, 30)
            }
        }
    }
}
