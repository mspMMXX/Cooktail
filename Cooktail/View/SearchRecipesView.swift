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
    @Binding var recipeURL: String?
    @State private var tappedRecipeURL: String?
    @State private var alertIsPresented: Bool = false
    @State var searchText: String = ""
    @State private var searchedRecipeData: [Items] = []
    @State private var isLoading: Bool = false
    @State private var recipeIsFound = true
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        NavigationStack{
            
            HStack{
                
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.black)
                
                TextField("Rezept suchen", text: $searchText)
                    .onSubmit {
                        DispatchQueue.main.async {
                            fetchSearchedRecipe()
                        }
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
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    if recipeIsFound {
                        List(searchedRecipeData, id: \.id) { recipe in
                            SearchedRecipeCellView(title: recipe.title, image: recipe.image_urls[0])
                                .onTapGesture {
                                    tappedRecipeURL = recipe.source
                                    alertIsPresented = true
                                }
                                .alert("Möchten Sie das Rezept zu Ihrer Liste hinzufügen?", isPresented: $alertIsPresented) {
                                    Button("Hinzufügen") {
                                        
                                        if let _tappedRecipeURL = tappedRecipeURL {
                                            DispatchQueue.main.async {
                                                recipeURL = _tappedRecipeURL
                                                alertIsPresented = false
                                                sheetIsPresented = false
                                            }
                                        }
                                    }
                                    Button("Abbrechen") {
                                        
                                        DispatchQueue.main.async {
                                            alertIsPresented = false
                                        }
                                    }
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
                        
                        Image(systemName: "x.circle.fill")
                            .foregroundStyle(.gray)
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
