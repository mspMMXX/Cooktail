//
//  MealRecipe+CoreDataProperties.swift
//  Cooktail
//
//  Created by Markus Platter on 19.11.23.
//
//

import Foundation
import CoreData


extension MealRecipe {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MealRecipe> {
        return NSFetchRequest<MealRecipe>(entityName: "MealRecipe")
    }
    
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var cookingDuration: Int64
    @NSManaged public var portions: Int16
    @NSManaged public var instructions: NSObject?
    @NSManaged public var ingredient: NSSet?
    @NSManaged public var notificationDate: Date?
    @NSManaged public var reminderIsEnabled: Bool
    
    public var ingredientArray: [Ingredient] {
        get {
            let set = ingredient as? Set<Ingredient> ?? []
            return set.sorted { $0.wrappedName < $1.wrappedName }
        }
        set(newIngredients) {
            ingredient = NSSet(array: newIngredients)
        }
    }
    
    public var instructionsArray: [String] {
        get {
            return (instructions as? [String]) ?? []
        }
        set {
            instructions = newValue as NSObject
        }
    }
    
    public var wrappedTitle: String {
        title ?? "Unbekannt"
    }
    
    public var wrappedImageURL: String {
        imageURL ?? "data:image/png;base64,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"
    }
}

// MARK: Generated accessors for ingredient
extension MealRecipe {
    
    @objc(addIngredientObject:)
    @NSManaged public func addToIngredient(_ value: Ingredient)
    
    @objc(removeIngredientObject:)
    @NSManaged public func removeFromIngredient(_ value: Ingredient)
    
    @objc(addIngredient:)
    @NSManaged public func addToIngredient(_ values: NSSet)
    
    @objc(removeIngredient:)
    @NSManaged public func removeFromIngredient(_ values: NSSet)
    
}

extension MealRecipe : Identifiable {
    
}
