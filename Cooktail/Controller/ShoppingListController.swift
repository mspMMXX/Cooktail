//
//  ShoppingListController.swift
//  Cooktail
//
//  Created by Markus Platter on 12.11.23.
//

import Foundation

class ShoppingListController: ObservableObject {
    @Published var shoppingList: [RecipeIngredients] = []
}
