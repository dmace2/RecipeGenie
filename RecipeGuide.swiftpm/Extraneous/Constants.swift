//
//  Constants.swift
//  Recipe Genie
//
//  Created by Dylan Mace on 3/29/23.
//

import Foundation
import SwiftUI

class Constants {
    static var backgroundGradient: LinearGradient = {
        var grad = LinearGradient(colors: [Color(red: 255/255, green: 181/255, blue: 36/255),
                                         Color(red: 255/255, green: 218/255, blue: 179/255),
                                          Color(red: 255/255, green: 141/255, blue: 42/255)], startPoint: .top, endPoint: .bottom)
        return grad
    }()
    static var defaultsOnboardingCompletedKey = "OnboardingCompleted"
    static var pantryEditedNotif = Notification.Name("PantryListEdited")
    static var shoppingCartRecipesEditedNotif = Notification.Name("ShoppingCartChanged")
    static var calorieTarget = 2000

}

struct ProminentButtonStyle: ButtonStyle {
    var color: Color
    var backgroundColor: Color

    init(color: Color = .white, background: Color = .accentColor) {
        self.color = color
        self.backgroundColor = background
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .padding(.horizontal)
            .padding(.vertical, 10)
            .foregroundColor(color)
            .background(backgroundColor)
            .background(Color.accentColor)
            .cornerRadius(10)
    }



}
