//
//  DataController.swift
//  Cooktail
//
//  Created by Markus Platter on 19.11.23.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    
    /// Welches Datenmodell verwendet werden soll
    let container = NSPersistentContainer(name: "CooktailDataModel")
    
    init() {
        container.loadPersistentStores { NSPersistentStoreDescription, error in
            if let error = error as NSError? {
                fatalError("ContainerError: \(error), \(error.userInfo))")
            }
        }
    }
    
    func saveData(from recipeModel: RecipeModel) {
        
        let moc = container.viewContext
        let newMealRecipe = MealRecipe(context: moc)
        
        newMealRecipe.id = UUID()
        newMealRecipe.cookingDuration = Int64(recipeModel.totalTime)
        newMealRecipe.imageURL = recipeModel.image_urls[0]
        newMealRecipe.instructionsArray = recipeModel.steps
        newMealRecipe.portions = Int16(recipeModel.portions)
        newMealRecipe.title = recipeModel.title
        
        for ingredientModel in recipeModel.ingredients {
            let ingredient = Ingredient(context: moc)
            ingredient.id = UUID()
            ingredient.name = ingredientModel.name
            ingredient.amount = ingredientModel.amount
            ingredient.unit = ingredientModel.unit
            ingredient.isChecked = false
            newMealRecipe.addToIngredient(ingredient)
        }
        
        do {
            try moc.save()
        } catch let error as NSError {
            print("Fehler beim speichern: \(error), \(error.userInfo)")
        }
        
    }
    
    func delete(_ recipe: MealRecipe) {
        
        let moc = container.viewContext
        
        moc.delete(recipe)
        
        do {
            try moc.save()
        } catch let error as NSError {
            // Fehlerbehandlung
            print("Fehler beim Löschen: \(error), \(error.userInfo)")
        }
        
    }
}
