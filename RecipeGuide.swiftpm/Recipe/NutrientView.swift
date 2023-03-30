//
//  NutrientView.swift
//  
//
//  Created by Dylan Mace on 3/30/23.
//

import SwiftUI

struct NutrientMacroView: View {
    var name: String
    var quant: Float
    var target: Float

    var body: some View {
        VStack {
            ProgressView(value: max(quant / target, 1.0))
            Text("\(String(format: "%.0f", quant / target * 100))%")
                .font(.caption).foregroundColor(.secondary)
            Text(name).font(.caption.weight(.bold))
        }
    }
}

struct NutrientView: View {
    var name: String
    var nutrient: Nutrition
    var quantity: String
    var unit: String

    @State var scalar: Float = 1.0

    var body: some View {
        VStack {
            List {
                VStack(alignment: .leading) {
                    Spacer()
                    Text(name.capitalized).font(.title.weight(.bold))
                        .foregroundColor(.white)
                        .shadow(radius: 10)
                }
                .frame(height: 150)
                .listRowBackground(
                    ZStack {
                        Image("Pantry-Spices")
                            .resizable().scaledToFill()
                            .ignoresSafeArea(.all)
                        LinearGradient(colors: [Color.black.opacity(0), Color.black], startPoint: .center, endPoint: .bottom)
                    }
                )

                Section {
                    let numberFormatter: NumberFormatter = {
                        let numberFormatter = NumberFormatter()
                        numberFormatter.numberStyle = .decimal
                        numberFormatter.maximumFractionDigits = 2
                        numberFormatter.minimum = 0
                        numberFormatter.maximum = 100
                        return numberFormatter
                    }()
                    HStack {
                        Text("Ingredient Quantity").font(.body.bold())
                        Spacer()
                        Text("\(quantity) \(unit)")
                            .font(.body.weight(.bold))
                    }
                    HStack {
                        Text("Number of Servings").font(.body.bold())
                        Spacer()
                        TextField("1.0", value: $scalar, formatter: numberFormatter)
                            .textFieldStyle(.roundedBorder)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                            .frame(width: 50)
                    }
                } header: {
                    Label("Ingredient Information", systemImage: "scalemass")
                        .font(.headline).foregroundColor(.red)
                }

                Section {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 3), spacing: 20) {
                        NutrientMacroView(name: "Calories", quant: nutrient.nrg * scalar,
                                          target: Float(Constants.calorieTarget))
                            .tint(.blue)
                        NutrientMacroView(name: "Fat", quant: nutrient.fat * scalar,
                                          target: Float(Constants.calorieTarget) * 0.2925)
                            .tint(.purple)
                        NutrientMacroView(name: "Protein", quant: nutrient.pro * scalar,
                                          target: Float(Constants.calorieTarget) * 0.1)
                    }

                } header: {
                    Label("Percent of Daily Goals", systemImage: "target")
                        .font(.headline).foregroundColor(.orange)
                }

                Section {
                    TextSpacerTextView(label: "Calories",
                                       otherContent: "\(String(format: "%.0f", nutrient.nrg * scalar)) cal")
                    TextSpacerTextView(label: "Fat",
                                       otherContent: "\(String(format: "%.2f", nutrient.fat * scalar)) g")
                    TextSpacerTextView(label: "Saturated Fat",
                                       otherContent: "\(String(format: "%.2f", nutrient.sat * scalar)) g")
                    TextSpacerTextView(label: "Protein",
                                       otherContent: "\(String(format: "%.2f", nutrient.pro * scalar)) g")
                    TextSpacerTextView(label: "Sodium",
                                       otherContent: "\(String(format: "%.2f", nutrient.sod * scalar)) g")
                    TextSpacerTextView(label: "Sugars",
                                       otherContent: "\(String(format: "%.2f", nutrient.sug * scalar)) g")
                } header: {
                    Label("Nutrition Facts", systemImage: "list.bullet.circle")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

struct NutrientView_Previews: PreviewProvider {
    static var previews: some View {
        NutrientView(
            name: RecipeDecoder.shared.decodeSampleRecipe().ingredients[2].text.components(separatedBy: ", ")[0],
            nutrient: RecipeDecoder.shared.decodeSampleRecipe().nutr_per_ingredient[2],
            quantity: RecipeDecoder.shared.decodeSampleRecipe().quantity[2].text,
            unit: RecipeDecoder.shared.decodeSampleRecipe().unit[2].text
        )
    }
}
