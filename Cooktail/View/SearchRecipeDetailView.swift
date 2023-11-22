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
                Stepper(value: $portionsSelected, in: 1...30) {
                    Text("Portionen: \(portionsSelected)")
                }
            }
            
            Section("Zutaten") {
                ForEach(recipe.ingredients, id: \.self) { ingredient in
                    HStack {
                        Text("\(ingredient.name)")
                        Spacer()
                        if let amount = ingredient.amount {
                            Text(newIngredientAmount(newPortion: Double(portionsSelected), oldPortion: Double(recipe.portions), amount: amount))
                        }
                        if let unit = ingredient.unit {
                            Text(unit)
                        }
                    }
                }
            }
            
            Section("Anleitung") {
                List(Array(recipe.steps.enumerated()), id: \.element) { index, step in
                    HStack(alignment: .top) {
                        Text("\(index + 1).")
                            .bold()
                            .frame(width: 30, alignment: .leading)
                        
                        Text(step)
                        Spacer()
                    }
                }
            }
        }
    }
    
    //Diese Funktion als Vorlage zur Zuweisung der neuen Amounts bei save verwenden wegen String
    private func newIngredientAmount(newPortion: Double, oldPortion: Double, amount: String) -> String {
        if let amountAsDouble = Double(amount) {
            let newAmount = (amountAsDouble / oldPortion) * newPortion
            return String(format: "%.2f", newAmount)
        } else {
            return ""
        }
    }
    
}
