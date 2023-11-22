//
//  ShoppingListView.swift
//  Cooktail
//
//  Created by Markus Platter on 09.11.23.
//

import Foundation
import SwiftUI

struct ShoppingListView: View {
    
    @FetchRequest(sortDescriptors: [], animation: .default) var mealRecipes: FetchedResults<MealRecipe>
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        
        NavigationStack {
            List {
                ForEach(mealRecipes, id: \.self) { recipe in
                    Section(recipe.wrappedTitle) {
                        ForEach(recipe.ingredientArray, id: \.self) { ingredient in
                            ShoppingListCellView(ingredient: ingredient, moc: _moc)
                        }
                    }
                }
            }
            .navigationTitle("Einkaufsliste")
            .navigationBarTitleDisplayMode(.inline)

        }
    }
}
