//
//  Recipe.swift
//  Cooktail
//
//  Created by Markus Platter on 19.11.23.
//

import Foundation

struct Recipe {
    
    let id: UUID
    let title: String
    let imageURL: String
    let ingredients: [RecipeIngredient]
    let instructions: [String]
    let cookingDuration: Int
    let portions: Int
}

struct RecipeIngredient {
    
    let id: UUID
    let name: String
    let amount: String?
    let unit: String?
}

