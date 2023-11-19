//
//  ContentView.swift
//  Cooktail
//
//  Created by Markus Platter on 07.11.23.
//

import SwiftUI

struct RecipeListView: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var mealRecipes: FetchedResults<MealRecipe>
    @EnvironmentObject private var shoppingListController: ShoppingListController
    private let recipeRapidData = RecipeRapidData()
    @State private var sheetIsPresented: Bool = false
    @State private var recipesList: [RecipeModel] = []
    @State private var recipeURL: String?
    
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
                recipeRapidData.fetchRecipe(with: url) { recipeModel in
                    if let _recipeModel = recipeModel {
                        addToCoreData(with: _recipeModel)
                    }
                }
            }
            //ES MUSS NOCH INGREDIENT GESPEICHERT WERDEN
            //UND DANN GELADEN WERDEN IN DER LIST
            
//            if let url = recipeURL {
//                
//                DispatchQueue.main.async {
//                    recipeRapidData.fetchRecipe(with: url) { recipe in
//                        if let _recipe = recipe {
//                            self.recipesList.append(_recipe)
//                            shoppingListController.shoppingList.append(_recipe)
//                            recipeURL = nil
//                        }
//                    }
//                }
//            }
        }
        
    }
    
    private func addToCoreData(with recipeModel: RecipeModel) {
        let ingredient = Ingredient(context: moc)
        ingredient.mealRecipe?.cookingDuration = Int64(recipeModel.totalTime)
        ingredient.mealRecipe?.imageURL = recipeModel.image_urls[0]
        ingredient.mealRecipe?.instructionsArray = recipeModel.steps
        ingredient.mealRecipe?.portions = Int16(recipeModel.portions)
        ingredient.mealRecipe?.title = recipeModel.title
        
        try? moc.save()
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
