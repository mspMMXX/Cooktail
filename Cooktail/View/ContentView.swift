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
    @State var searchText: String = ""
    
    var body: some View {
        
        NavigationStack {
            List(items, id: \.self) { item in
                
                NavigationLink(destination: RecipeDetailView(title: item)) {
                    Text(item)
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
                SearchRecipesView(sheetIsPresented: $sheetIsPresented, searchText: $searchText)
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
