//
//  DataController.swift
//  Cooktail
//
//  Created by Markus Platter on 19.11.23.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    
    //MARK: - @Environment Properties
    @Published var recipes: [MealRecipe] = []
    
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
        
        do {
            try moc.save()
        } catch let error as NSError {
            print("Fehler beim speichern: \(error), \(error.userInfo)")
        }
    }
    
    //MARK: - updateRecipe
    ///Es werden alle Daten des Recipe verändert
    ///Aber nur die Amounts der Ingredients, da unit und name gleich bleiben
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
    
    //MARK: - loadRecipe
    //Ladet und speichert über inout die Recipes in das übergebene MealRecipe-Array
    func loadRecipes() {
        let fetchRequest: NSFetchRequest<MealRecipe> = MealRecipe.fetchRequest()
        
        do {
            self.recipes = try container.viewContext.fetch(fetchRequest)
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
    private func calculateNewAmount(originalAmount: String?, originalPortions: Int, newPortions: Int) -> String {
        guard let originalAmount = originalAmount, let amount = Double(originalAmount) else {
            return ""
        }
        let newAmount = (amount / Double(originalPortions)) * Double(newPortions)
        return String(format: "%.2f", newAmount)
    }
    
}
