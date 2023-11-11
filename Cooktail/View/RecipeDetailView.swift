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
            
            Text("Recipe details \(recipeData.instructions)")
        }
    }
}
