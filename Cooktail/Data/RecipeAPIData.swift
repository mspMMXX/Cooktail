//
//  RecipeAPIData.swift
//  Cooktail
//
//  Created by Markus Platter on 09.11.23.
//

import Foundation

class RecipeAPIData {
    
    private let baseURL = "https://api.edamam.com/api/recipes/v2"
    private let appId = "847e3d28"
    private let appKey = "112c097cdff38cedfdecc4cda77d6518"
    
    func createURL(with keyword: String) -> String {
        let urlAsString = "\(baseURL)?type=public&q=\(keyword)&app_id=\(appId)&app_key=\(appKey)"
        print(urlAsString)
        return urlAsString
    }
}
