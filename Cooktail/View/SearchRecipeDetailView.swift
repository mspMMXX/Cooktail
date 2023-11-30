//
//  SearchRecipeDetailView.swift
//  Cooktail
//
//  Created by Markus Platter on 20.11.23.
//

import Foundation
import SwiftUI

struct SearchRecipeDetailView: View {
    
    //MARK: - @State Properties
    @State private var searchedRecipe: RecipeModel? //Recipe Objekt aus API
    @State private var portionsSelected: Int = 1 //Definierung der Portionsmengen
    @State private var reminderIsEnabled: Bool = false //Ein- und Ausblenden des DatePickers
    @State private var notificationDate: Date = Date()
    @State var recipeURL: String
    
    //MARK: - @StateObject / @Binding Properties
    @StateObject var dataController = DataController() //Datenhandhabung
    @Binding var searchRecipeViewIsPresented: Bool //Steuert die Anzeige des SearchRecipesView
    
    //MARK: - Properties
    var recipeRapidData = RecipeRapidData() //API-Recipe Objekt
    
    //MARK: - Body
    var body: some View {
        Group {
            if let _recipeData = searchedRecipe {
                RecipeDetailViewElement(portionsSelected: $portionsSelected, reminderIsEnabled: $reminderIsEnabled, notificationDate: $notificationDate, recipe: _recipeData)
            } else {
                ProgressView()
            }
        }
        .toolbar(content: {
            Button("Speichern") {
                if let _recipeData = searchedRecipe {
                    dataController.saveRecipe(from: _recipeData, newPortion: portionsSelected, notificationDate: notificationDate, reminderIsEnabled: reminderIsEnabled)
                    searchRecipeViewIsPresented = false
                }
            }
        })
        .onAppear {
            DispatchQueue.main.async {
                recipeRapidData.fetchRecipe(with: recipeURL) { recipe in
                    if let _recipe = recipe {
                        searchedRecipe = _recipe
                    }
                }
            }
        }
    }
}
