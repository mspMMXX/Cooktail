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
    @AppStorage("ShowTutorial") private var showTutorial = true
    
    var body: some Scene {
        WindowGroup {
            if showTutorial {
                TutorialView(showTutorial: $showTutorial)
            } else {
                ContentView()
                    .environment(\.managedObjectContext, dataController.container.viewContext)
                    .environmentObject(dataController)
            }
        }
    }
}


