//
//  ShoppingListView.swift
//  Cooktail
//
//  Created by Markus Platter on 09.11.23.
//

import Foundation
import SwiftUI

struct ShoppingListView: View {
    
    var items = ["Artiekl 1", "Artikel 2", "Artikel 3", "Artikel 4"]
    @EnvironmentObject private var shoppingListController: ShoppingListController
    
    var body: some View {
        
        NavigationStack{
            //Searchbar
           
            List(shoppingListController.shoppingList, id: \.id) { ingredient in
                Text(ingredient.nameClean)
            }
                .navigationTitle("Shopping list")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
