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
    @State private var isOn: Bool = false
    
    var body: some View {
        
        NavigationStack{
            //Searchbar
            VStack {
                List(shoppingListController.shoppingList, id: \.id) { recipe in
                    Section(recipe.title) {
                        ForEach(recipe.ingredients, id: \.id) { ingredient in
                            HStack{
                                Text(ingredient.name)
                                Spacer()
                                Text("\(ingredient.amount ?? "") \(ingredient.unit ?? "")")
                            }
                        }
                    }
                }
                .navigationTitle("Shopping list")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}
