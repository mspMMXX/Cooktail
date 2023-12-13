//
//  RecipeModel.swift
//  Cooktail
//
//  Created by Markus Platter on 18.11.23.
//

import Foundation

/// Das Modell für die Umwandlung eines konkreten Recipes der JSON-API-Daten und zur Verwendung als Objekte
public struct RecipeModel: Codable, Identifiable, Hashable {
    
    public let id: UUID?
    let image_urls: [String]
    let ingredients: [IngredientModel]
    let steps: [String]
    let title: String
    let totalTime: Int
    let portions: Int
}

public struct IngredientModel: Codable, Identifiable, Hashable {
    
    public let id: UUID?
    let amount: String?
    let name: String
    let unit: String?
}
