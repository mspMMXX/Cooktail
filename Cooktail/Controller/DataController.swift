//
//  DataController.swift
//  Cooktail
//
//  Created by Markus Platter on 19.11.23.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    
    //MARK: - Properties
    //Welches Datenmodell verwendet werden soll
    let container = NSPersistentContainer(name: "CooktailDataModel")
    let notificationController = NotificationController()
    
    //MARK: - init
    init() {
        container.loadPersistentStores { NSPersistentStoreDescription, error in
            if let error = error as NSError? {
                fatalError("ContainerError: \(error), \(error.userInfo))")
            }
        }
    }
    
    //MARK: - saveRecipe
     ///Speichert die Daten eines RecipeModel in MealRecipe (CoreData)
     ///Für jedes Objekt wird eine id erstellt
     ///Mit dem NotificationDate wird eine Notification erstellt
     ///Die for-Schleife speichert die Ingredientsdaten in ein Ingredient-Array
    func saveRecipe(from recipeModel: RecipeModel, newPortion: Int, notificationDate: Date) {
        let moc = container.viewContext
        let newMealRecipe = MealRecipe(context: moc)
        
        newMealRecipe.id = UUID()
        newMealRecipe.cookingDuration = Int64(recipeModel.totalTime)
        newMealRecipe.imageURL = recipeModel.image_urls[0]
        newMealRecipe.instructionsArray = recipeModel.steps
        newMealRecipe.portions = Int16(newPortion)
        newMealRecipe.title = recipeModel.title
        newMealRecipe.notificationDate = notificationDate
        
        notificationController.scheduleNotification(at: notificationDate, recipeTitle: recipeModel.title)
        
        for ingredientModel in recipeModel.ingredients {
            let ingredient = Ingredient(context: moc)
            ingredient.id = UUID()
            ingredient.name = ingredientModel.name
            ingredient.amount = calculateNewAmount(with: ingredientModel.amount, originalPortions: recipeModel.portions, newPortions: newPortion)
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
    
    //MARK: - loadRecipe
    //Ladet und speichert über inout die Recipes in das übergebene MealRecipe-Array
    func loadRecipes(to recipes: inout [MealRecipe]) {
        let fetchRequest: NSFetchRequest<MealRecipe> = MealRecipe.fetchRequest()
        
        do {
            recipes = try container.viewContext.fetch(fetchRequest)
        } catch {
            print("Fehler beim laden der Rezepte.")
        }
    }
    
    //MARK: - deleteRecipe
    func deleteRecipe(_ recipe: MealRecipe) {
        let moc = container.viewContext
        
        do {
            moc.delete(recipe)
            try moc.save()
        } catch let error as NSError {
            print("Fehler beim Löschen: \(error), \(error.userInfo)")
        }
    }
    
    //MARK: - calculateNewAmount
    //Berechnet den neuen Amount über die neue Portionsmenge
    private func calculateNewAmount(with originalAmount: String?, originalPortions: Int, newPortions: Int) -> String {
        guard let amountString = originalAmount, let amount = Double(amountString) else { return originalAmount ?? "" }
        let newAmount = (amount / Double(originalPortions)) * Double(newPortions)
        return String(format: "%.2f", newAmount)
    }
}
