//
//  ShoppingListView.swift
//  Cooktail
//
//  Created by Markus Platter on 09.11.23.
//

import Foundation
import SwiftUI

struct ShoppingListView: View {
    
    @FetchRequest(sortDescriptors: []) var mealRecipes: FetchedResults<MealRecipe>
    
    var body: some View {
        
        NavigationStack{
            List {
                ForEach(mealRecipes, id: \.self) { recipe in
                    Section(recipe.wrappedTitle) {
                        ForEach(recipe.ingredientArray, id: \.self) { ingredient in
                            Text("\(ingredient.wrappedName)")
                        }
                    }
                }
            }
            .navigationTitle("Einkaufsliste")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
