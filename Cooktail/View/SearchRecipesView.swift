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
    @State var searchText: String = ""
    @State private var searchedRecipeData: [Items] = []
    @State private var isLoading: Bool = false
    @State private var recipeIsFound = true
    
    var body: some View {
        
        NavigationStack {
            
            HStack {
                
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.black)
                
                TextField("Rezept suchen", text: $searchText)
                    .onSubmit {
                        DispatchQueue.main.async {
                            fetchSearchedRecipe()
                        }
                    }
                    .submitLabel(.search)
                    .foregroundStyle(.black)
                
                Button(action: {
                    
                }, label: {
                    
                    if searchText != "" {
                        Image(systemName: "x.circle.fill")
                            .foregroundStyle(.gray)
                            .onTapGesture {
                                searchText = ""
                            }
                            .foregroundStyle(.black)
                            .padding(.trailing)
                    }
                })
            }
            .padding(7)
            .background(
                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                    .fill(Color(red: 211/255, green: 211/255, blue: 211/255))
            )
            .padding()
            
            VStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    if recipeIsFound {
                        List(searchedRecipeData, id: \.id) { recipe in
                            
                            NavigationLink(destination: SearchRecipeDetailView(recipeURL: recipe.source, sheetIsPresented: $sheetIsPresented)) {
                                SearchedRecipeCellView(title: recipe.title, image: recipe.image_urls[0])
                            }
                        }
                        .listStyle(PlainListStyle())
                    } else {
                        Text("Es wurde leider kein Rezept gefunden.")
                    }
                }
            }
            Spacer()
                .toolbar(content: {
                    Button(action: {
                        
                        DispatchQueue.main.async {
                            sheetIsPresented = false
                        }
                    }, label: {
                        
                        Text("Abbrechen")
                    })
                })
        }
    }
    
    private func fetchSearchedRecipe() {
        
        isLoading = true
        let recipes = RecipeRapidData()
        recipes.fetchSearchedRecipes(with: searchText) { recipeData in
            DispatchQueue.main.async {
                if let items = recipeData, !items.isEmpty {
                    self.searchedRecipeData = items
                    self.recipeIsFound = true
                } else {
                    self.recipeIsFound = false
                }
                self.isLoading = false
            }
        }
    }
}
