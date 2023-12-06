//
//  RecipeDetailViewElement.swift
//  Cooktail
//
//  Created by Markus Platter on 28.11.23.
//

import Foundation
import SwiftUI

struct RecipeDetailViewElement: View {
    
    //MARK: - Properties
    var recipe: RecipeModel
    
    @Binding var portionsSelected: Int
    @Binding var reminderIsEnabled: Bool
    @Binding var notificationDate: Date
    
    //MARK: - Body
    var body: some View {
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
            Section("Zutaten") {
                ForEach(recipe.ingredients, id: \.self) { ingredient in
                    HStack {
                        Text("\(ingredient.name)")
                        Spacer()
                        if let amount = ingredient.amount {
                            Text("\(newIngredientAmount(newPortion: Double(portionsSelected), oldPortion: Double(recipe.portions), amount: amount))")
                        }
                        if let unit = ingredient.unit {
                            Text(unit)
                        }
                    }
                }
            }
            Section("Erinnerung") {
                VStack {
                    Toggle("Koch-Alarm", isOn: $reminderIsEnabled)
                    if reminderIsEnabled {
                        DatePicker("", selection: $notificationDate)
                    }
                }
            }
        }
    }
    
    //MARK: - func newIngredientAmount
    //Berechnet die neue Zutatenmenge anhand der neuen Portionsmenge
    private func newIngredientAmount(newPortion: Double, oldPortion: Double, amount: String) -> String {
        if let amountAsDouble = Double(amount) {
            let newAmount = (amountAsDouble / oldPortion) * newPortion
            return String(format: "%.2f", newAmount)
        } else {
            return ""
        }
    }
}
