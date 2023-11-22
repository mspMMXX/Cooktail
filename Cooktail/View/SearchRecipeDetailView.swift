//
//  SearchRecipeDetailView.swift
//  Cooktail
//
//  Created by Markus Platter on 20.11.23.
//

import Foundation
import SwiftUI

struct SearchRecipeDetailView: View {
    
    @State private var portionsSelected: Int = 1
    @State private var recipeRapidData = RecipeRapidData()
    @State private var recipeData: RecipeModel?
    @State var recipeURL: String
    
    var body: some View {
        
        Group {
            if let _recipeData = recipeData {
                recipeDetailView(for: _recipeData)
            } else {
                ProgressView()
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                fetchRecipe(with: recipeURL)
            }
        }
    }
    
    private func fetchRecipe(with url: String?) {
        if let _url = url {
            recipeRapidData.fetchRecipe(with: _url) { recipe in
                if let _recipe = recipe {
                    recipeData = _recipe
                }
            }
        }
    }
    
    private func recipeDetailView(for recipe: RecipeModel) -> some View {
        Form {
            
            HStack {
                AsyncImage(url: URL(string: recipe.image_urls[0]), scale: 30) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                }
            placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding(.horizontal)
                
                VStack(alignment: .leading) {
                    Text(recipe.title)
                    Text("Arbeitsaufwand: \(recipe.totalTime / 60) min.")
                        .font(.caption)
                }
            }
            
            HStack {
                //                    Text("Portionen: \(portionsSelected)")
                Stepper(value: $portionsSelected, in: 0...30) {
                    Text("Portionen: \(portionsSelected)")
                }
            }
            
            
            
        }
    }
}
