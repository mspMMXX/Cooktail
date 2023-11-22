//
//  RecipeListCell.swift
//  Cooktail
//
//  Created by Markus Platter on 11.11.23.
//

import Foundation
import SwiftUI

struct RecipeCellView: View {
    
    var title: String
    var image: String
    
    var body: some View {
        HStack{
            AsyncImage(url: URL(string: image), scale: 30) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
            }
        placeholder: {
            ProgressView()
        }
        .frame(width: 50, height: 50)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding(.horizontal)
            
            
            VStack{
                Text(title)
                    .font(.body)
            }
        }
    }
}
