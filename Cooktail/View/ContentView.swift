//
//  ContentView.swift
//  Cooktail
//
//  Created by Markus Platter on 07.11.23.
//

import SwiftUI

struct RecipeListView: View {
    
    private let recipeRapidData = RecipeRapidData()
    @State private var sheetIsPresented: Bool = false
    @State private var recipesList: [RecipeModel] = []
    @State private var recipeURL: String?
    @EnvironmentObject private var shoppingListController: ShoppingListController
    
    var body: some View {
        
        NavigationStack {
            
            VStack{
                
                List(recipesList, id: \.id) { recipe in
                    NavigationLink(destination: RecipeDetailView(recipeData: recipe)) {
                        RecipeListCell(title: recipe.title, portions: recipe.portions, readyInMinutes: recipe.totalTime, image: recipe.image_urls[0])
                    }
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
                SearchRecipesView(sheetIsPresented: $sheetIsPresented, recipeURL: $recipeURL)
            })
        }
        .onChange(of: recipeURL) {
            
            if let url = recipeURL {
                
                DispatchQueue.main.async {
                    recipeRapidData.fetchRecipe(with: url) { recipe in
                        if let _recipe = recipe {
                            self.recipesList.append(_recipe)
                            for ingredient in _recipe.ingredients {
                                shoppingListController.shoppingList.append(ingredient)
                            }
                            recipeURL = nil
                        }
                    }
                }
            }
        }
        
    }
}

struct ContentView: View {
    
    @StateObject private var shoppingListController = ShoppingListController()
    
    var body: some View {
        
        TabView {
            RecipeListView()
                .environmentObject(shoppingListController)
                .tabItem {
                    Label("Rezepte", systemImage: "list.bullet")
                }
            ShoppingListView()
                .environmentObject(shoppingListController)
                .tabItem {
                    Label("Einkaufen", systemImage: "cart")
                }
        }
        .background(.blue)
    }
}

#Preview {
    ContentView()
}
