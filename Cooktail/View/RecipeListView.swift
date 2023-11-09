//
//  RecipeListView.swift
//  Cooktail
//
//  Created by Markus Platter on 09.11.23.
//

import Foundation
import SwiftUI

struct RecipeListView: View {
    
    var items = ["Eins", "Zwei", "Drei"]
    @State private var sheetIsPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            List(items, id: \.self) { item in
                NavigationLink(destination: RecipeDetailView(title: item)) {
                    Text(item)
                }
            }
            .navigationTitle("Cooktail")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                Button(action: {
                    sheetIsPresented = true
                }, label: {
                    Image(systemName: "plus")
                })
            })
            .sheet(isPresented: $sheetIsPresented, content: {
                SearchRecipeView(title: "Rezept Suche", sheetIsPresented: $sheetIsPresented)
            })
        }
    }
}
