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
        
        VStack {
            HStack {
                AsyncImage(url: URL(string: recipeData.wrappedImageURL), scale: 17)
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding(.trailing)
                VStack(alignment: .leading) {
                    Text(recipeData.wrappedTitle)
                        .bold()
                    Text("Arbeitsaufwand: \(recipeData.cookingDuration / 60) min.")
                        .font(.caption)
                    Text("Portionen: \(recipeData.portions)")
                        .font(.caption)
                }
            }
            .padding(.bottom)
            Form {
                Section("Zutaten") {
                    List {
                        ForEach(recipeData.ingredientArray, id: \.self) { ingredient in
                            HStack {
                                Text(ingredient.wrappedName)
                                Spacer()
                                Text(ingredient.wrappedAmount.replacing(".", with: ","))
                                Text(ingredient.wrappedUnit)
                            }
                        }
                    }
                }
                
                Section("Anleitung") {
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
            }
        }
    }
    
    private func dateAsString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy, HH:mm"
        return dateFormatter.string(from: date)
    }
}
