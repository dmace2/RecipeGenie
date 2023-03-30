//
//  RecipeView.swift
//  RecipeMaker
//
//  Created by Dylan Mace on 3/29/23.
//

import SwiftUI
import UIKit

struct FSAView: View {
    var elem: FSALights

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 4), spacing: 20) {
            VStack {
                Text("Fats")
                    .font(.callout).bold()
                AnyView(elem.fat.view)
            }
            VStack {
                Text("Salt")
                    .font(.callout).bold()
                AnyView(elem.salt.view)
            }
            VStack {
                Text("Saturates").font(.callout).bold()
                AnyView(elem.saturates.view)
            }
            VStack {
                Text("Sugar").font(.callout).bold()
                AnyView(elem.sugars.view)
            }
        }
    }
}

struct TextSpacerTextView: View {
    var label: String
    var otherContent: String

    var body: some View {
        HStack {
            Text(label).bold()
            Spacer()
            Text("\(otherContent)")
                .font(.callout)
                .foregroundColor(.secondary)
        }
    }
}

struct RecipeView: View {
    let recipe: Recipe

    var body: some View {
        VStack(alignment: .leading) {
            Text(recipe.title)
                .padding(.horizontal)
                .font(.title.weight(.bold))
            List {
                Section {
                    FSAView(elem: recipe.fsa_lights_per100g)
                    // TODO: add nav link for nutrition per ingredient
                    TextSpacerTextView(label: "Energy", otherContent: "\(String(format: "%.2f", recipe.nutr_values_per100g.energy)) J")
                    TextSpacerTextView(label: "Fat", otherContent: "\(String(format: "%.2f", recipe.nutr_values_per100g.fat)) g")
                    TextSpacerTextView(label: "Protein", otherContent: "\(String(format: "%.2f", recipe.nutr_values_per100g.protein)) g")
                    TextSpacerTextView(label: "Salt", otherContent: "\(String(format: "%.2f", recipe.nutr_values_per100g.salt)) g")
                    TextSpacerTextView(label: "Sugar", otherContent: "\(String(format: "%.2f", recipe.nutr_values_per100g.sugars)) g")

                } header: {
                    Label("Nutrition Information Per 100g", systemImage: "fork.knife.circle.fill")
                        .font(.headline)
                        .foregroundColor(.red)
                }
                Section {
                    ForEach(recipe.ingredients.indices, id: \.self) { idx in
                        let ingredient = recipe.ingredients[idx]
                        let quantity = recipe.quantity[idx]
                        let unit = recipe.unit[idx]
                        IngredientView(ingredient: ingredient, quantity: quantity, unit: unit)
                    }
                } header: {
                    Label("Ingredients", systemImage: "list.bullet.circle.fill")
                        .font(.headline)
                        .foregroundColor(.orange)
                }

                Section {
                    let instr_para = getSentences(from: recipe.instructions.map({$0.text}).joined(separator: " "))
//                    Text(instr_para)
                    ForEach(instr_para, id: \.self) { instruction in
                        Text(instruction)
                            .listRowSeparator(.hidden)
                    }
                } header: {
                    Label("Instructions", systemImage: "cooktop.fill")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
            }.listStyle(.sidebar)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
    }

    func getSentences(from text: String) -> [String] {
            let regex = try! NSRegularExpression(pattern: "(?<=[.?!])\\s+(?=[A-Z])", options: [])
            let range = NSRange(text.startIndex..<text.endIndex, in: text)
            let matches = regex.matches(in: text, options: [], range: range)
            var sentences = [String]()
            var previousEndIndex = text.startIndex
            for match in matches {
                let startIndex = text.index(text.startIndex, offsetBy: match.range.lowerBound)
                let endIndex = text.index(text.startIndex, offsetBy: match.range.upperBound)
                sentences.append(String(text[previousEndIndex..<startIndex]))
                previousEndIndex = endIndex
            }
            sentences.append(String(text[previousEndIndex..<text.endIndex]))
            return sentences
        }
}

extension Color {

    init(wordName: String) {
        switch wordName {
        case "clear":       self = .clear
        case "black":       self = .black
        case "white":       self = .white
        case "gray":        self = .gray
        case "red":         self = .red
        case "green":       self = .green
        case "blue":        self = .blue
        case "orange":      self = .orange
        case "yellow":      self = .yellow
        case "pink":        self = .pink
        case "purple":      self = .purple
        case "primary":     self = .primary
        case "secondary":   self = .secondary
        default:            self = .black
        }
    }
}
