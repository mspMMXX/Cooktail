//
//  RecipeListCell.swift
//  Cooktail
//
//  Created by Markus Platter on 11.11.23.
//

import Foundation
import SwiftUI

struct RecipeCellView: View {
    
    //MARK: - Properties
    var title: String
    var imageURL: String
    var image: Data?
    
    //MARK: - Body
    var body: some View {
        HStack{
            if let imageData = image,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding(.trailing)
            } else if let _imageURL = URL(string: imageURL) {
                AsyncImage(url: _imageURL, scale: 17)
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding(.trailing)
            }
            VStack{
                Text(title)
                    .font(.body)
            }
        }
    }
}
