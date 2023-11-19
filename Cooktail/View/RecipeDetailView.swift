//
//  RecipeDetailView.swift
//  Cooktail
//
//  Created by Markus Platter on 09.11.23.
//

import Foundation
import SwiftUI

struct RecipeDetailView: View {
    
    var recipeData: MealRecipe
    
    var body: some View {
        
        HStack{
            List(Array(recipeData.instructionsArray.enumerated()), id: \.element) { index, step in
                HStack(alignment: .top) {
                    Text("\(index + 1).")
                        .bold()
                        .frame(width: 30, alignment: .leading)
                    
                    Text(step)
                    Spacer()
                }
            }
        }
        .navigationTitle("Anleitung")
    }
}
