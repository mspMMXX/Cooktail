//
//  RecipeRapidData.swift
//  Cooktail
//
//  Created by Markus Platter on 18.11.23.
//

import Foundation

class RecipeRapidData {
    
    
    func fetchSearchedRecipes(with inputText: String, completion: @escaping ([Items]?) -> Void){
        
        let headers = [
            "X-RapidAPI-Key": "acc4f02ef9msh063f3f22f773d42p18f871jsn9edf4640fa59",
            "X-RapidAPI-Host": "gustar-io-deutsche-rezepte.p.rapidapi.com"]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://gustar-io-deutsche-rezepte.p.rapidapi.com/search_api?text=\(inputText)")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if let _error = error {
                print("ERROR, RecipeRapidData: \(_error)")
                return
            }
            if let _data = data {
                self.parseJSONForSearchedRecipes(from: _data, completion: completion)
            }
        }
        task.resume()
    }
    
    func parseJSONForSearchedRecipes(from data: Data, completion: @escaping ([Items]?) -> Void) {
        
        let decoder = JSONDecoder()
        do {
            let decoderData = try decoder.decode([Items].self, from: data)
            DispatchQueue.main.async {
                completion(decoderData)
            }
        }catch {
            print(error)
        }
    }
    
    func fetchRecipe(with url: String, completion: @escaping (RecipeModel?) -> Void){
        
        let headers = [
            "X-RapidAPI-Key": "acc4f02ef9msh063f3f22f773d42p18f871jsn9edf4640fa59",
            "X-RapidAPI-Host": "gustar-io-deutsche-rezepte.p.rapidapi.com"]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://gustar-io-deutsche-rezepte.p.rapidapi.com/crawl?target_url=\(url)")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if let _error = error {
                print("ERROR, RecipeRapidData: \(_error)")
                return
            }
            if let _data = data {
                self.parseJSONForRecipe(from: _data, completion: completion)
            }
        }
        task.resume()
    }
    
    func parseJSONForRecipe(from data: Data, completion: @escaping (RecipeModel?) -> Void) {
        
        let decoder = JSONDecoder()
        
        do {
            let decoderData = try decoder.decode(RecipeModel.self, from: data)
            DispatchQueue.main.async {
                completion(decoderData)
            }
        }catch {
            print(error)
        }
    }
}

