//
//  RecipeModel.swift
//  Cooktail
//
//  Created by Markus Platter on 10.11.23.
//

import Foundation

struct RecipeDataModel: Codable {
    
    let id: Int
    let extendedIngredients: [ExtendedIngredients]
    let title: String
    let readyInMinutes: Int
    let servings: Int
    let image: String
    let instructions: String
}

struct ExtendedIngredients: Codable {
    
    let id: Int
    let nameClean: String
    let originalName: String
    let amount: Double
    let unit: String
}
