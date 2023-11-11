//
//  RecipeAPIData.swift
//  Cooktail
//
//  Created by Markus Platter on 09.11.23.
//

import Foundation

class RecipeAPIData {
    
    //Spoonacular
    private let baseURL = "https://api.apilayer.com/spoonacular/recipes/"
    private let appKey = "DkbN89O87aS3xbKZTdkWkFjF0jxS8AS6"
    
    //Ergebnis -> Alle Rezepte die das keyword enthalten
    func fetchAllRecipes(from keyword: String, completion: @escaping (SearchedRecipesDataModel?) -> Void) {
        
        let urlAsString = "\(baseURL)complexSearch?query=\(keyword)&apikey=\(appKey)"
        print(urlAsString)
        performRequestForAllRecipes(from: urlAsString, completion: completion)
    }
    
    //Das ausgewaehlte Rezept mittels id
    func fetchRecipe(with id: String, completion: @escaping (RecipeDataModel?) -> Void) {
        
        let urlAsString = "\(baseURL)\(id)/information?includeNutrition=false&apikey=\(appKey)"
        print(urlAsString)
        performRequestForRecipe(from: urlAsString, completion: completion)
    }
    
    private func performRequestForRecipe(from urlString: String, completion: @escaping (RecipeDataModel?) -> Void) {
        
        guard let url = URL(string: urlString) else {return}
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, URLResponse, error in
                if let error = error {
                    print("Keine Daten gefunden \(error)")
                    return
                }
                if let _data = data {
                    self.parseJSONForRecipe(from: _data, completion: completion)
                    print(_data)
                }
            }
        task.resume()
    }
    
    private func performRequestForAllRecipes(from urlString: String, completion: @escaping (SearchedRecipesDataModel?) -> Void) {
        
        guard let url = URL(string: urlString) else {return}
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, URLResponse, error in
                if let error = error {
                    print("Keine Daten gefunden \(error)")
                    return
                }
                if let _data = data {
                    self.parseJSONForAllRecipes(from: _data, completion: completion)
                    print(_data)
                }
            }
        task.resume()
    }
    
    private func parseJSONForRecipe(from data: Data, completion: @escaping (RecipeDataModel?) -> Void) {
        
        let decoder = JSONDecoder()
        do {
            let decoderData = try decoder.decode(RecipeDataModel.self, from: data)
            completion(decoderData)
        }catch {
            print(error)
        }
    }
    
    private func parseJSONForAllRecipes(from data: Data, completion: @escaping (SearchedRecipesDataModel?) -> Void) {
        
        let decoder = JSONDecoder()
        do {
            let decoderData = try decoder.decode(SearchedRecipesDataModel.self, from: data)
            completion(decoderData)
        }catch {
            print(error)
        }
    }
    
}
