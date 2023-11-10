//
//  ContentView.swift
//  Cooktail
//
//  Created by Markus Platter on 07.11.23.
//

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
                    
                    //NUR TESTCODE UNTEN
                    let recipes = RecipeAPIData()
                    recipes.fetchRecipe(with: "637631") { recipe in
                        if let _recipe = recipe {
                            print("\(_recipe.title) \(_recipe.instructions)")
                            for ingrediant in _recipe.extendedIngredients {
                                print("\(ingrediant.nameClean) - \(ingrediant.amount) \(ingrediant.unit)")
                            }
                        }
                    }
                    //NUR TESTCODE OBEN
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

struct ContentView: View {
    
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

#Preview {
    ContentView()
}
