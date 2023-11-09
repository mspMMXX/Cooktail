//
//  BottomBarView.swift
//  Cooktail
//
//  Created by Markus Platter on 09.11.23.
//

import Foundation
import SwiftUI

struct BottomBarView: View {
    
    var body: some View {
        
        TabView {
            RecipeListView()
                .tabItem {
                    Label("Recipe", systemImage: "list.bullet")
                }
            ShoppingListView()
                .tabItem {
                    Label("Shopping", systemImage: "cart")
                }
        }
        .background(.blue)
    }
}
