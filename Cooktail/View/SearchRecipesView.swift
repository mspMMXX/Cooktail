//
//  SearchRecipeView.swift
//  Cooktail
//
//  Created by Markus Platter on 09.11.23.
//

import Foundation
import SwiftUI

struct SearchRecipesView: View {
    
    @Binding var sheetIsPresented: Bool
    @Binding var recipeId: Int?
    @State private var alertIsPresented: Bool = false
    @State var searchText: String = ""
    @State private var searchedRecipeData: SearchedRecipesDataModel? = nil
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        NavigationStack{
            
            HStack{
                
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.black)
                
                TextField("Rezept suchen", text: $searchText)
                    .onSubmit {
                        fetchSearchedRecipe()
                    }
                    .foregroundStyle(.black)
                
                Button(action: {
                    
                }, label: {
                    
                    Image(systemName: "x.circle")
                        .onTapGesture {
                            searchText = ""
                        }
                        .foregroundStyle(.black)
                        .padding(.trailing)
                })
            }
            .padding(7)
            .background(
                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                    .fill(Color(red: 211/255, green: 211/255, blue: 211/255))
            )
            .padding()
            
            VStack{
                if let recipes = searchedRecipeData {
                    List(recipes.results, id: \.id) { recipe in
                        SearchedRecipeCellView(title: recipe.title, image: recipe.image)
                            .onTapGesture {
                                alertIsPresented = true
                            }
                            .alert("Möchten Sie das Rezept zu Ihrer Liste hinzufügen?", isPresented: $alertIsPresented) {
                                Button("Hinzufügen") {
                                    
                                        recipeId = recipe.id
                                        print("ID:  \(recipe.id)")
                                    
                                    DispatchQueue.main.async {
                                        alertIsPresented = false
                                        sheetIsPresented = false
                                    }
                                }
                                Button("Abbrechen") {
                                    alertIsPresented = false
                                }
                            }
                    }
                    .listStyle(PlainListStyle())
                } else {
                    Text("Keine Daten gefunden")
                }
            }
            Spacer()
                .toolbar(content: {
                    Button(action: {
                        print("Yes")
                        sheetIsPresented = false
                    }, label: {
                        
                        Text("Abbrechen")
                    })
                })
        }
    }
    
    private func fetchSearchedRecipe() {
        
        let recipes = RecipeAPIData()
        recipes.fetchAllRecipes(from: searchText) { recipeData in
            DispatchQueue.main.async {
                self.searchedRecipeData = recipeData
            }
            
        }
    }
}
