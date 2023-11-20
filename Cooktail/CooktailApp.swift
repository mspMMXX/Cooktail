//
//  CooktailApp.swift
//  Cooktail
//
//  Created by Markus Platter on 07.11.23.
//

import SwiftUI

@main
struct CooktailApp: App {
    
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
                
        }
    }
}
