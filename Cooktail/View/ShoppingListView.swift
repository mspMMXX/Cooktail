//
//  ShoppingListView.swift
//  Cooktail
//
//  Created by Markus Platter on 09.11.23.
//

import Foundation
import SwiftUI

struct ShoppingListView: View {
    
    @EnvironmentObject private var shoppingListController: ShoppingListController
    
    var body: some View {
        
        NavigationStack{
            //Searchbar
            
            List(shoppingListController.shoppingList, id: \.id) { ingredient in
                Text(ingredient.name)
            }
            .navigationTitle("Shopping list")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
