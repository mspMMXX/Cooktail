//
//  DataController.swift
//  Cooktail
//
//  Created by Markus Platter on 19.11.23.
//

import Foundation
import CoreData
import UIKit

class DataController: ObservableObject {
    
    //MARK: - Properties
    @Published var recipes: [MealRecipe] = []
    
    /// Zuweisung des Datenmodells
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
    
    //MARK: - func saveRecipe
    /// Speichert die Daten eines RecipeModel in MealRecipe (CoreData)
    /// Für jedes Objekt wird eine id erstellt
    /// Mit dem NotificationDate wird eine Notification erstellt
    /// Die for-Schleife speichert die Ingredientsdaten in ein Ingredient-Array
    /// - Parameter recipeModel: Ein konkretes Rezept-Objekt
    /// - Parameter newPortion: Die neue Portionsmenge zur Berechnung der neuen Mengen
    /// - Parameter notificationDate: Das Datum zur Erstellung der Benachrichtigung
    /// - Parameter reminderIsEnabled: Ob eine Benachrichtigung erstellt werden soll
    func saveRecipe(from recipeModel: RecipeModel, newPortion: Int, notificationDate: Date, reminderIsEnabled: Bool) {

        let moc = container.viewContext
        let newMealRecipe = MealRecipe(context: moc)
        let id = UUID()
        
        newMealRecipe.id = id
        newMealRecipe.cookingDuration = Int64(recipeModel.totalTime)
        newMealRecipe.imageURL = recipeModel.image_urls[0]
        newMealRecipe.instructionsArray = recipeModel.steps
        newMealRecipe.portions = Int16(newPortion)
        newMealRecipe.title = recipeModel.title
        newMealRecipe.reminderIsEnabled = reminderIsEnabled
        
        if reminderIsEnabled {
            newMealRecipe.notificationDate = notificationDate
            notificationController.scheduleNotification(at: notificationDate, recipeTitle: recipeModel.title, id: id)
        }
        
        for ingredientModel in recipeModel.ingredients {
            let ingredient = Ingredient(context: moc)
            ingredient.id = UUID()
            ingredient.name = ingredientModel.name
            ingredient.amount = calculateNewAmount(originalAmount: ingredientModel.amount, originalPortions: recipeModel.portions, newPortions: newPortion)
            ingredient.unit = ingredientModel.unit
            ingredient.isChecked = false
            newMealRecipe.addToIngredient(ingredient)
        }
        
        if let url = URL(string: recipeModel.image_urls[0]) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let image = UIImage(data: data)?.pngData() {
                    DispatchQueue.main.async {
                        newMealRecipe.image = image
                    }
                }
            }.resume()
        }
        do {
            try moc.save()
        } catch let error as NSError {
            print("Fehler beim speichern: \(error), \(error.userInfo)")
        }
    }
    
    //MARK: - func updateRecipe
    /// Ändern der Benachrichtigung und oder der Portionsmenge
    /// - Parameter recipe: Das bereits gespeicherte Rezept
    /// - Parameter newPortion: Die neue Portionsmenge zur Berechnung der neuen Mengen
    /// - Parameter notificationDate: Das Datum zur Erstellung der Benachrichtigung
    /// - Parameter reminderIsEnabled: Ob eine Benachrichtigung erstellt werden soll
    func updateRecipe(from recipe: MealRecipe, newPortion: Int, newNotificationDate: Date, reminderIsEnabled: Bool) {
        let moc = container.viewContext
        
        let fetchRequest: NSFetchRequest<MealRecipe> = MealRecipe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", recipe.id! as CVarArg)
        
        do {
            let results = try moc.fetch(fetchRequest)
            if let recipeToUpdate = results.first {
                
                recipeToUpdate.title = recipe.wrappedTitle
                recipeToUpdate.reminderIsEnabled = reminderIsEnabled
                
                if reminderIsEnabled {
                    recipeToUpdate.notificationDate = newNotificationDate
                    if let id = recipe.id {
                        notificationController.updateScheduledNotification(at: newNotificationDate, recipeTitle: recipe.wrappedTitle, id: id)
                    }
                } else {
                    if let id = recipe.id {
                        notificationController.deleteNotification(with: id)
                    }
                }
                
                for newIngredient in recipeToUpdate.ingredientArray {
                    newIngredient.amount = calculateNewAmount(originalAmount: newIngredient.amount, originalPortions: Int(recipeToUpdate.portions), newPortions: newPortion)
                }
                recipeToUpdate.portions = Int16(newPortion)
                
                try moc.save()
            }
        } catch let error as NSError {
            print("Fehler beim Aktualisieren: \(error), \(error.userInfo)")
        }
    }
    
    //MARK: - func loadRecipe
    /// Ladet und speichert über inout die Recipes in das übergebene MealRecipe-Array
    func loadRecipes() {
        let fetchRequest: NSFetchRequest<MealRecipe> = MealRecipe.fetchRequest()
        
        do {
            self.recipes = try container.viewContext.fetch(fetchRequest)
        } catch {
            print("Fehler beim laden der Rezepte.")
        }
    }
    
    //MARK: - func deleteRecipe
    ///- Parameter recipe: Das zu löschende Rezept
    func deleteRecipe(_ recipe: MealRecipe) {
        let moc = container.viewContext
        
        do {
            moc.delete(recipe)
            if let id = recipe.id {
                notificationController.deleteNotification(with: id)
            }
            try moc.save()
        } catch let error as NSError {
            print("Fehler beim Löschen: \(error), \(error.userInfo)")
        }
    }
    
    //MARK: - func calculateNewAmount
    /// Berechnet den neuen Amount/Menge über die neue Portionsmenge
    /// - Parameter originalAmount: Der alte Zutaten-Mengenwert
    /// - Parameter originalPortions: Der alte Portionswert
    /// - Parameter newPortions: Der neue Portionswert
    private func calculateNewAmount(originalAmount: String?, originalPortions: Int, newPortions: Int) -> String {
        guard let originalAmount = originalAmount, let amount = Double(originalAmount) else {
            return ""
        }
        let newAmount = (amount / Double(originalPortions)) * Double(newPortions)
        return String(format: "%.2f", newAmount)
    }
    
}
