//
//  ShoppingListCellView.swift
//  Cooktail
//
//  Created by Markus Platter on 22.11.23.
//

import Foundation
import SwiftUI
import CoreData

struct ShoppingListCellView: View {
    
    @StateObject var ingredient: Ingredient
    var moc: NSManagedObjectContext
    
    var body: some View {
        HStack {
            Button(action: {
                DispatchQueue.main.async {
                    ingredient.isChecked.toggle()
                    do {
                        try moc.save()
                        print("Änderungen in isChecked wurden gespeichert.")
                    } catch {
                        print("Änderungen in isChecked konnten nicht gespeichert werden.")
                    }
                }
            }, label: {
                Image(systemName: ingredient.isChecked ? "checkmark.circle.fill" : "circle")
            })
            Text(ingredient.wrappedName)
            Spacer()
            Text(ingredient.wrappedAmount)
            Text(ingredient.wrappedUnit)
        }
    }
}
