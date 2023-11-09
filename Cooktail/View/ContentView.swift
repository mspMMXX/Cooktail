//
//  ContentView.swift
//  Cooktail
//
//  Created by Markus Platter on 07.11.23.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationStack{
            List(1..<101){ value in
                NavigationLink("Zelle \(value)"){
                    SecondContentView(number: value)
                }
            }
            .navigationTitle("Cooktail")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                Button(action: {
                    print("Plus tapped")
                }, label: {
                    Image(systemName: "plus")
                })
            })
        }
    }
}

#Preview {
    ContentView()
}
