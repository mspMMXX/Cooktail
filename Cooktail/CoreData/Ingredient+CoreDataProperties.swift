//
//  Ingredient+CoreDataProperties.swift
//  Cooktail
//
//  Created by Markus Platter on 19.11.23.
//
//

import Foundation
import CoreData


extension Ingredient {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingredient> {
        return NSFetchRequest<Ingredient>(entityName: "Ingredient")
    }
    
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var amount: String?
    @NSManaged public var unit: String?
    @NSManaged public var isChecked: Bool
    @NSManaged public var mealRecipe: MealRecipe?
    
    public var wrappedName: String {
        name ?? "Unbekannt"
    }
    
    public var wrappedAmount: String {
        amount ?? ""
    }
    
    public var wrappedUnit: String {
        unit ?? ""
    }
}

extension Ingredient : Identifiable {
    
}
