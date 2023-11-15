//
//  RecipeDetailView.swift
//  Cooktail
//
//  Created by Markus Platter on 09.11.23.
//

import Foundation
import SwiftUI

struct RecipeDetailView: View {
    
    var recipeData: RecipeDataModel
    
    var body: some View {
        
        HStack{
            List(recipeData.analyzedInstructions.first?.steps ?? [], id: \.number) { recipe in
                Text("\(recipe.number). \(recipe.step)")
            }
        }
    }
}
