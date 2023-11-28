//
//  SearchedRecipesModel.swift
//  Cooktail
//
//  Created by Markus Platter on 18.11.23.
//

import Foundation

///Das Modell für die Umwandlung der gesuchten JSON-API-Daten und zur Verwendung als Objekte
struct SearchedRecipesModel: Codable {
    
    let items: [Items]
}

struct Items: Codable, Identifiable {
    
    var id: String { title }
    let image_urls: [String]
    let portions: Int
    let source: String
    let title: String
    let totalTime: Int
}
