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
    @Binding var searchText: String
    @State private var recipeData: AllRecipesDataModel? = nil
    
    var body: some View {
        
        NavigationStack{
            
            HStack{
                
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.gray)
                
                TextField("Rezept suchen", text: $searchText)
                    .onSubmit {
                        fetchRecipe()
                    }
                
                Button(action: {

                }, label: {
                    
                    Image(systemName: "x.circle")
                        .onTapGesture {
                            searchText = ""
                        }
                        .padding(.trailing)
                })
            }
            .padding()
            
            VStack{
                if let recipes = recipeData {
                    List(recipes.results, id: \.id) { recipe in
                        Text(recipe.title)
                            .foregroundStyle(.black)
                    }
                    .listStyle(PlainListStyle())
                } else {
                    Text("Keine Daten gefunden")
                        .foregroundStyle(.black)
                }
            }
            Spacer()
                .toolbar(content: {
                    Button(action: {
                        print("Yes")
                        sheetIsPresented = false
                    }, label: {
                        
                        Text("Save")
                    })
                })
        }
    }
    
    private func fetchRecipe() {
        
        let recipes = RecipeAPIData()
        recipes.fetchAllRecipes(from: searchText) { recipeData in
            DispatchQueue.main.async {
                self.recipeData = recipeData
            }
            
        }
    }
}

//#Preview {
//    SearchRecipesView(sheetIsPresented: .constant(true))
//}
