//
//  AllRecipeDataModel.swift
//  Cooktail
//
//  Created by Markus Platter on 10.11.23.
//

import Foundation

struct AllRecipesDataModel: Codable{
    
    var results: [Results]
}

struct Results: Codable {
    
    var id: Int
    var title: String
    var image: String
}
