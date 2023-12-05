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
    
    //MARK: - @Environment Properties
    @EnvironmentObject var dataController: DataController //Datenhandhabung
    
    //MARK: - Body
    var body: some View {
        NavigationStack {
            List {
                ForEach(dataController.recipes, id: \.self) { recipe in
                    Section(recipe.wrappedTitle) {
                        ForEach(recipe.ingredientArray, id: \.self) { ingredient in
                            ShoppingListCellView(ingredient: ingredient, moc: dataController.container.viewContext)
                        }
                    }
                }
            }
            .navigationTitle("Einkaufsliste")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            DispatchQueue.main.async {
                dataController.loadRecipes()
            }
        }
    }
}
