//
//  RecipeListCell.swift
//  Cooktail
//
//  Created by Markus Platter on 11.11.23.
//

import Foundation
import SwiftUI

struct RecipeListCell: View {
    
    var title: String
    var servings: Int
    var readyInMinutes: Int
    var image: String?
    
    var body: some View {
        HStack{
            if let _image = image {
                AsyncImage(url: URL(string: _image), scale: 3.5)
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding(.horizontal)
            }
            VStack{
                Text(title)
                    .multilineTextAlignment(.center)
                    .font(.title3)
                Text("Zubereitungszeit: \(String(readyInMinutes)) min.")
                    .font(.footnote)
                Text("Personen: \(String(servings))")
                    .font(.footnote)
            }
        }
    }
}
