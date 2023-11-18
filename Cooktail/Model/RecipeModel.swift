//
//  RecipeModel.swift
//  Cooktail
//
//  Created by Markus Platter on 18.11.23.
//

import Foundation

struct RecipeModel: Codable, Identifiable {
    
    var id: String { title }
    let image_urls: [String]
    let ingredients: [RecipeIngredients]
    let steps: [String]
    let title: String
    let totalTime: Int
    let portions: Int
}

struct RecipeIngredients: Codable, Identifiable {
    
    var id: String {name}
    let amount: String
    let name: String
    let unit: String
}
