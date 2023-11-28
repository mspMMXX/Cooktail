//
//  ContentView.swift
//  Cooktail
//
//  Created by Markus Platter on 07.11.23.
//

import SwiftUI
import CoreData

struct RecipeListView: View {
    
    //MARK: - @State Properties
    @State private var recipes: [MealRecipe] = []
    @State private var searchRecipeViewIsPresented: Bool = false //Steuert die Anzeige des SearchRecipesView
    @State private var deleteAlertIsPresented: Bool = false //Steuert die Anzeige des Delet-Alerts
    @State private var recipeToDelete: MealRecipe? //Referenz auf das zu löschende Recipe-Objekt
    
    //MARK: - @StateObject Properties
    @StateObject var dataController = DataController() //Datenhandhabung
    
    //MARK: - Private Properties
    private var notificationController = NotificationController() //Notification-Handhabung
    
    
    //MARK: - Body
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
                            deleteAlertIsPresented = true
                        } label: {
                            Image(systemName: "trash.fill")
                        }
                    }
                    .tint(.red)
                }
            }
            .navigationTitle("Cooktail")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Rezept löschen?", isPresented: $deleteAlertIsPresented, actions: {
                Button("Nein") {
                    self.recipeToDelete = nil
                    self.deleteAlertIsPresented = false
                }
                Button("Ja") {
                    if let _recipeToDelete = recipeToDelete {
                        DispatchQueue.main.async {
                            dataController.deleteRecipe(_recipeToDelete)
                            dataController.loadRecipes(to: &recipes)
                        }
                    }
                    self.deleteAlertIsPresented = false
                }
            })
            .toolbar(content: {
                Button(action: {
                    searchRecipeViewIsPresented = true
                }, label: {
                    Image(systemName: "plus")
                })
            })
            .sheet(isPresented: $searchRecipeViewIsPresented, content: {
                SearchRecipesView(searchRecipeViewIsPresented: $searchRecipeViewIsPresented)
            })
        }
        .onAppear {
            DispatchQueue.main.async {
                dataController.loadRecipes(to: &recipes)
                notificationController.requestAuthorization()
            }
        }
        .onChange(of: searchRecipeViewIsPresented) {
            DispatchQueue.main.async {
                dataController.loadRecipes(to: &recipes)
            }
        }
    }
}

//MARK: - ContentView

struct ContentView: View {
    
    //MARK: - ContentView Properties
    
    @StateObject var dataController = DataController()
    
    //MARK: - ContentView Body
    
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
