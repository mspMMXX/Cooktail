//
//  ContentView.swift
//  Cooktail
//
//  Created by Markus Platter on 07.11.23.
//

import SwiftUI
import CoreData

struct RecipeListView: View {
    
    @StateObject var dataController = DataController()
    @State private var recipes: [MealRecipe] = []
    @State private var sheetIsPresented: Bool = false
    @State private var deleteAlert: Bool = false
    @State private var recipeToDelete: MealRecipe?
    
    private var notificationController = NotificationController()
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                List(recipes, id: \.id) { recipe in
                    NavigationLink(destination: RecipeDetailView(recipeData: recipe)) {
                        RecipeCellView(title: recipe.wrappedTitle, image: recipe.wrappedImageURL)
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
                        DispatchQueue.main.async {
                            dataController.delete(_recipeToDelete)
                            loadRecipes()
                        }
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
                SearchRecipesView(sheetIsPresented: $sheetIsPresented)
            })
        }
        .onAppear {
            loadRecipes()
            notificationController.requestAuthorization()
        }
        .onChange(of: sheetIsPresented) {
            loadRecipes()
        }
    }
    
    private func loadRecipes() {
        let fetchRequest: NSFetchRequest<MealRecipe> = MealRecipe.fetchRequest()
        do {
            recipes = try dataController.container.viewContext.fetch(fetchRequest)
        } catch {
            print("Fehler beim laden der Rezepte.")
        }
    }
}

struct ContentView: View {
    
    @StateObject var dataController = DataController()
    
    var body: some View {
        
        TabView {
            RecipeListView()
                .tabItem {
                    Label("Rezepte", systemImage: "list.bullet")
                }
            ShoppingListView(dataController: dataController)
            
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
