//
//  ContentView.swift
//  Cooktail
//
//  Created by Markus Platter on 07.11.23.
//

import SwiftUI
import CoreData

struct RecipeListView: View {
    
    @EnvironmentObject var dataController: DataController
    @FetchRequest(sortDescriptors: []) var mealRecipes: FetchedResults<MealRecipe>
    
    private let recipeRapidData = RecipeRapidData()
    @State private var sheetIsPresented: Bool = false
    @State private var recipesList: [RecipeModel] = []
    @State private var recipeURL: String?
    @State private var recipe: RecipeModel?
    @State private var deleteAlert: Bool = false
    @State private var recipeToDelete: MealRecipe?
    
    var body: some View {
        
        NavigationStack {
            
            VStack{
                List(mealRecipes, id: \.id) { recipe in
                    NavigationLink(destination: RecipeDetailView(recipeData: recipe)) {
                        RecipeListCell(title: recipe.wrappedTitle, portions: Int(recipe.portions), readyInMinutes: Int(recipe.cookingDuration), image: recipe.imageURL)
                    }
                    .swipeActions {
                        Button {
                            self.recipeToDelete = recipe
                            deleteAlert = true
                        } label: {
                            Image(systemName: "trash.fill")
                        }
                    }
                    .tint(.red)
                }
            }
            .navigationTitle("Cooktail")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Rezept löschen?", isPresented: $deleteAlert, actions: {
                Button("Nein") {
                    self.recipeToDelete = nil
                    self.deleteAlert = false
                }
                Button("Ja") {
                    if let _recipeToDelete = recipeToDelete {
                        dataController.delete(_recipeToDelete)
                    }
                    self.deleteAlert = false
                }
            })
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
            print("RecipeListView OnChange = OK")
            if let url = recipeURL {
                recipeRapidData.fetchRecipe(with: url) { recipeModel in
                    if let _recipeModel = recipeModel {
                        recipe = _recipeModel
                        if let _recipe = recipe {
                            DispatchQueue.main.async {
                                dataController.saveData(from: _recipe)
                                print("AddToCoreData = OK")
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ContentView: View {
    
    var body: some View {
        
        TabView {
            RecipeListView()
                .tabItem {
                    Label("Rezepte", systemImage: "list.bullet")
                }
            ShoppingListView()
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
