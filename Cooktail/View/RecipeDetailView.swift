//
//  RecipeDetailView.swift
//  Cooktail
//
//  Created by Markus Platter on 09.11.23.
//

import Foundation
import SwiftUI

struct RecipeDetailView: View {
    
    var recipeData: RecipeModel
    
    var body: some View {
        
        HStack{
            List(recipeData.steps, id: \.self) { step in
                Text(step)
            }
        }
    }
}
