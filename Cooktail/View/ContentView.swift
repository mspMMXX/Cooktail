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
    @State private var recipeData: [RecipeDataModel] = []
    @State private var recipeId: Int?
    @EnvironmentObject private var shoppingListController: ShoppingListController
    
    var body: some View {
        
        NavigationStack {
            
            VStack{
                
                List(recipeData, id: \.id) { recipe in
                    NavigationLink(destination: RecipeDetailView(recipeData: recipe)) {
                        RecipeListCell(title: recipe.title, servings: recipe.servings, readyInMinutes: recipe.readyInMinutes, image: recipe.image)
                    }
                }
                
            }
            .navigationTitle("Cooktail")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                
                Button(action: {
                    
                    sheetIsPresented = true
                    print("Sheet")
                }, label: {
                    Image(systemName: "plus")
                })
            })
            .sheet(isPresented: $sheetIsPresented, content: {
                SearchRecipesView(sheetIsPresented: $sheetIsPresented, recipeId: $recipeId)
                    .onChange(of: recipeId, initial: true) {
                        
                        if let id = recipeId {
                            
                            print("OnChange unter List wird ausgefuehrt")
                            
                            let recipeAPI = RecipeAPIData()
                            recipeAPI.fetchRecipe(with: String(id)) { recipe in
                                if let _recipe = recipe {
                                    recipeData.append(_recipe)
                                    for ingredient in _recipe.extendedIngredients {
                                        shoppingListController.shoppingList.append(ingredient)
                                    }
                                    recipeId = nil
                                }
                            }
                        }
                    }
            })
        }
    }
}

struct ContentView: View {
    
    @StateObject private var shoppingListController = ShoppingListController()
    
    var body: some View {
        
        TabView {
            RecipeListView()
                .environment(shoppingListController)
                .tabItem {
                    Label("Recipe", systemImage: "list.bullet")
                }
            ShoppingListView()
                .environment(shoppingListController)
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
