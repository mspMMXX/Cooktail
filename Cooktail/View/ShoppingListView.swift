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
    
    @State private var isOn: Bool = false
    
    var body: some View {
        
        NavigationStack{
            //Searchbar
            List {
                ForEach(mealRecipes, id: \.self) { recipe in
                    Section(recipe.wrappedTitle) {
                        ForEach(recipe.ingredientArray, id: \.self) { ingredient in
                            HStack{
                                Text(ingredient.wrappedName)
                                Spacer()
                                Text("\(ingredient.wrappedAmount) \(ingredient.wrappedUnit)")
                            }
                        }
                    }
                }
                .navigationTitle("Shopping list")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}
