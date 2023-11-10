//
//  Recipe.swift
//  Cooktail
//
//  Created by Markus Platter on 10.11.23.
//

import Foundation
import SwiftUI

struct Recipe {
    
    var title: String
    var persons: Int
    var calories: Int
    var instruction: String
    var cookingDuration: Int
    var ingredients: [Ingredients] = []
    var image: String
    
}

struct Ingredients {
    var name: String
    var details: String
}
