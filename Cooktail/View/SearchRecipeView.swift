//
//  SearchRecipeView.swift
//  Cooktail
//
//  Created by Markus Platter on 09.11.23.
//

import Foundation
import SwiftUI

struct SearchRecipeView: View {
    
    var title: String
    @Binding var sheetIsPresented: Bool
    
    var body: some View {
        
        NavigationStack{
            
            Text(title)
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
}

#Preview {
    SearchRecipeView(title: "Placeholder", sheetIsPresented: .constant(true))
}
