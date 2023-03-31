//
//  Classes.swift
//  Recipe Genie
//
//  Created by Dylan Mace on 3/30/23.
//

import Foundation
import SwiftUI

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

struct TextItem: Shoppable, Hashable  {
    var id: String {
        return text
    }
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


struct Recipe: Shoppable, Identifiable, Equatable, Hashable {
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.id == rhs.id
    }

    var fsa_lights_per100g: FSALights
    let id: String
    var ingredients: [TextItem]
    var instructions: [TextItem]
    var nutr_per_ingredient: [Nutrition]
    var nutr_values_per100g: Nutrition_100g
    var partition: String
    var quantity: [TextItem]
    var title: String
    var unit: [TextItem]
    var url: String
    var weight_per_ingr: [Float]
}
