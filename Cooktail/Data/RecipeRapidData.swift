//
//  RecipeRapidData.swift
//  Cooktail
//
//  Created by Markus Platter on 18.11.23.
//

import Foundation

class RecipeRapidData {

    //MARK: - func fetchSearchedRecipes
    /// Ladet anhand des inputTexts alle übereinstimmenden Recipes und parsed sie
    /// - Parameter inputText: Der Text zur Suche von Rezepten
    func fetchSearchedRecipes(with inputText: String, completion: @escaping ([Items]?) -> Void) {
        let headers = [
            "x-rapidapi-key": "acc4f02ef9msh063f3f22f773d42p18f871jsn9edf4640fa59",
            "x-rapidapi-host": "gustar-io-deutsche-rezepte.p.rapidapi.com"
        ]

        let encodedInputText = inputText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

        // Startzeit messen
        let startTime = Date()

        if let url = NSURL(string: "https://gustar-io-deutsche-rezepte.p.rapidapi.com/search_api?text=\(encodedInputText)") {
            var request = URLRequest(url: url as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 20.0)
            request.allHTTPHeaderFields = headers

            let session = URLSession.shared
            let task = session.dataTask(with: request) { (data, response, error) in
                let duration = Date().timeIntervalSince(startTime)
                print("API call took \(duration) seconds")

                if let error = error {
                    print("ERROR, RecipeRapidData: \(error)")
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    print("Status code (search): \(httpResponse.statusCode)")
                }

                if let data = data {
                    print(String(data: data, encoding: .utf8) ?? "No readable response")
                    self.parseJSONForSearchedRecipes(from: data, completion: completion)
                }
            }
            task.resume()
        }
    }

    //MARK: - func parseJSONForSearchedRecipes
    /// Parse-Funktion zur Umwandlung der gesuchten Recipes
    /// - Parameter data: Die erhaltenen Daten aus der Suche
    func parseJSONForSearchedRecipes(from data: Data, completion: @escaping ([Items]?) -> Void) {
        let decoder = JSONDecoder()
        do {
            let decoderData = try decoder.decode([Items].self, from: data)
            DispatchQueue.main.async {
                completion(decoderData)
            }
        } catch {
            print("Parse error (search): \(error)")
        }
    }

    //MARK: - func fetchRecipe
    /// Ladet jeweils ein Recipe mittels der URL
    /// - Parameter url: Die URL zur Suche eines konkreten Rezeptes
    func fetchRecipe(with url: String, completion: @escaping (RecipeModel?) -> Void) {
        let headers = [
            "x-rapidapi-key": "acc4f02ef9msh063f3f22f773d42p18f871jsn9edf4640fa59",
            "x-rapidapi-host": "gustar-io-deutsche-rezepte.p.rapidapi.com"
        ]

        let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

        if let url = NSURL(string: "https://gustar-io-deutsche-rezepte.p.rapidapi.com/crawl?target_url=\(encodedURL)") {
            var request = URLRequest(url: url as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 20.0)
            request.allHTTPHeaderFields = headers

            let session = URLSession.shared
            let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("ERROR, RecipeRapidData: \(error)")
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    print("Status code (recipe): \(httpResponse.statusCode)")
                }

                if let data = data {
                    self.parseJSONForRecipe(from: data, completion: completion)
                }
            }
            task.resume()
        }
    }

    //MARK: - func parseJSONRecipe
    /// Parse-Funktion zur Umwandlung eines Recipes
    /// - Parameter data: Die erhaltenen Daten aus der Suche
    func parseJSONForRecipe(from data: Data, completion: @escaping (RecipeModel?) -> Void) {
        let decoder = JSONDecoder()
        do {
            let decoderData = try decoder.decode(RecipeModel.self, from: data)
            DispatchQueue.main.async {
                completion(decoderData)
            }
        } catch {
            print("Parse error (recipe): \(error)")
        }
    }
}

