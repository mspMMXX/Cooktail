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
