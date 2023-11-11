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
    @State private var tappedRecipeId: Int?
    
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
                SearchRecipesView(sheetIsPresented: $sheetIsPresented, tappedRecipeId: $tappedRecipeId)
                    .onChange(of: tappedRecipeId, initial: true) {
                        if let id = tappedRecipeId {
                            print("OnChange unter List wird ausgefuehrt")
                            let recipeAPI = RecipeAPIData()
                            recipeAPI.fetchRecipe(with: String(id)) { recipe in
                                if let _recipe = recipe {
                                    recipeData.append(_recipe)
                                }
                            }
                        }
                    }
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
