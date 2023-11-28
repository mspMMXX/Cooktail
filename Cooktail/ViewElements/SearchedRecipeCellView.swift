//
//  SearchRecipeCellView.swift
//  Cooktail
//
//  Created by Markus Platter on 11.11.23.
//

import Foundation
import SwiftUI


struct SearchedRecipeCellView: View {
    
    //MARK: - Properties
    var title: String
    var image: String?
    
    //MARK: - Body
    var body: some View {
        HStack{
            if let _image = image {
                AsyncImage(url: URL(string: _image), scale: 30) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                }
            placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding(.horizontal)
                
            }
            Text(title)
                .font(.body)
        }
    }
}
