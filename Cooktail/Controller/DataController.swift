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
}
