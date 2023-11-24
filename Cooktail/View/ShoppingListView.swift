//
//  ShoppingListView.swift
//  Cooktail
//
//  Created by Markus Platter on 09.11.23.
//

import Foundation
import SwiftUI
import CoreData

struct ShoppingListView: View {
    
    @Environment(\.managedObjectContext) var moc
    @StateObject var dataController = DataController()
    @State private var recipes: [MealRecipe] = []
    
    var body: some View {
        
        NavigationStack {
            List {
                ForEach(recipes, id: \.self) { recipe in
                    Section(recipe.wrappedTitle) {
                        ForEach(recipe.ingredientArray, id: \.self) { ingredient in
                            ShoppingListCellView(ingredient: ingredient, moc: _moc)
                        }
                    }
                }
            }
            .navigationTitle("Einkaufsliste")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            loadRecipes()
        }
    }
    
    private func loadRecipes() {
        let fetchRequest: NSFetchRequest<MealRecipe> = MealRecipe.fetchRequest()
        do {
            recipes = try dataController.container.viewContext.fetch(fetchRequest)
        } catch {
            print("Fehler beim laden der Rezepte.")
        }
    }
}
